import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';

class DriverBookingScreen extends StatelessWidget {
  const DriverBookingScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchBookingsWithUserNames() async {
    final bookingsSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .orderBy('date', descending: true)
        .get();

    List<Map<String, dynamic>> bookingsWithNames = [];

    for (var doc in bookingsSnapshot.docs) {
      final bookingData = doc.data();
      final userEmail = bookingData['user_email'];

      String userName = 'Unknown';

      if (userEmail != null && userEmail is String) {
        final trimmedEmail = userEmail.trim();

        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(trimmedEmail)
              .get();

          if (userDoc.exists && userDoc.data()!.containsKey('name')) {
            userName = userDoc.data()!['name'];
          } else {
            print("User not found for email: $trimmedEmail");
          }
        } catch (e) {
          print('Error fetching user $trimmedEmail: $e');
        }
      }

      bookingsWithNames.add({
        'userName': userName,
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

    return bookingsWithNames;
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchBookingsWithUserNames(),
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
                  userName: booking['userName'],
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
    required String userName,
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
          Text('User Name: $userName'),
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
}
