import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';

class DriverBookingScreen extends StatelessWidget {
  const DriverBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driver = FirebaseAuth.instance.currentUser;

    if (driver == null) {
      return const Scaffold(body: Center(child: Text('Driver not logged in')));
    }

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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .where('driverId', isEqualTo: driver.uid)
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final bookings = snapshot.data?.docs ?? [];

            if (bookings.isEmpty) {
              return const Center(child: Text('No bookings found.'));
            }

            return ListView.separated(
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final bookingDoc = bookings[index];
                final bookingData = bookingDoc.data() as Map<String, dynamic>;
                final userEmail = bookingData['user_email'] ?? '';

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userEmail)
                      .get(),
                  builder: (context, userSnapshot) {
                    String userName = 'Unknown';
                    if (userSnapshot.hasData && userSnapshot.data!.exists) {
                      final userDocData =
                          userSnapshot.data!.data() as Map<String, dynamic>?;
                      if (userDocData != null &&
                          userDocData.containsKey('name')) {
                        userName = userDocData['name'];
                      }
                    }
                    return _buildBookingCard(
                      bookingId: bookingDoc.id,
                      userName: userName,
                      date: bookingData['date'] ?? '',
                      time: bookingData['time'] ?? '',
                      carType: bookingData['carType'] ?? '',
                      rideType: bookingData['rideType'] ?? '',
                      status: bookingData['status'] ?? '',
                      amount: bookingData['fare']?.toString() ?? '0',
                      context: context,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingCard({
    required String bookingId,
    required String userName,
    required String date,
    required String time,
    required String carType,
    required String rideType,
    required String status,
    required String amount,
    required BuildContext context,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('User Name: $userName'),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmAndDeleteBooking(context, bookingId),
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

  void _confirmAndDeleteBooking(BuildContext context, String bookingId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Booking"),
        content: const Text("Are you sure you want to delete this booking?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking deleted successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete booking")),
        );
      }
    }
  }
}
