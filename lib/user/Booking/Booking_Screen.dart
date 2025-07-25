import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  Stream<List<Map<String, dynamic>>> _bookingsStream() async* {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final currentEmail = currentUser.email?.trim();
    if (currentEmail == null) return;

    yield* FirebaseFirestore.instance
        .collection('bookings')
        .where('user_email', isEqualTo: currentEmail)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> bookingsWithNames = [];

      for (var doc in snapshot.docs) {
        final bookingData = doc.data();
        final driverEmail = bookingData['driver_email'];

        String driverName = 'Pending Assignment';

        if (driverEmail != null && driverEmail is String && driverEmail.trim().isNotEmpty) {
          try {
            final driverDoc = await FirebaseFirestore.instance
                .collection('drivers')
                .doc(driverEmail.trim())
                .get();

            if (driverDoc.exists && driverDoc.data()!.containsKey('name')) {
              driverName = driverDoc.data()!['name'];
            }
          } catch (e) {
            print('Error fetching driver $driverEmail: $e');
          }
        }

        bookingsWithNames.add({
          'id': doc.id, // Added document ID
          'driverName': driverName,
          'date': bookingData['date'] ?? '',
          'time': bookingData['time'] ?? '',
          'carType': bookingData['carType'] ?? '',
          'rideType': bookingData['rideType'] ?? '',
          'status': bookingData['status'] ?? '',
          'amount': bookingData.containsKey('fare') && bookingData['fare'] != null
              ? bookingData['fare'].toString()
              : '0',
        });
      }

      bookingsWithNames.sort((a, b) => b['date'].compareTo(a['date']));

      return bookingsWithNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: AppBar(
        backgroundColor: AColor().White,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.bookmark_outline, color: AColor().Black),
            const SizedBox(width: 8),
            Text(
              'Bookings',
              style: TextStyle(
                color: AColor().Black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _bookingsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final bookings = snapshot.data ?? [];

            if (bookings.isEmpty) {
              return const Center(child: Text('No bookings found.'));
            }

            return ListView.separated(
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return _buildBookingCard(
                  context: context,
                  id: booking['id'],
                  driverName: booking['driverName'],
                  date: booking['date'],
                  time: booking['time'],
                  carType: booking['carType'],
                  rideType: booking['rideType'],
                  status: booking['status'],
                  amount: booking['amount'],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingCard({
    required BuildContext context,
    required String id,
    required String driverName,
    required String date,
    required String time,
    required String carType,
    required String rideType,
    required String status,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AColor().green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with Driver and delete icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Driver: $driverName'),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmAndDeleteBooking(context, id),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Date: $date'),
          const SizedBox(height: 8),
          Text('Time: $time'),
          const SizedBox(height: 8),
          Text('Car Type: $carType'),
          const SizedBox(height: 8),
          Text('Ride Type: $rideType'),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(status, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                ' ₹$amount',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmAndDeleteBooking(BuildContext context, String id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Booking"),
        content: const Text("Are you sure you want to delete this booking?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete")),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await FirebaseFirestore.instance.collection('bookings').doc(id).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking deleted successfully")),
        );
      } catch (e) {
        print("Error deleting booking: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete booking")),
        );
      }
    }
  }
}
