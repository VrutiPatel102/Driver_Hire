import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  final List<Map<String, String>> bookings = const [
    {
      'driverName': 'John Doe',
      'date': '12 July 2025',
      'time': '10:00 AM',
      'carType': 'Sedan',
      'rideType': 'One Way',
      'status': 'Pending',
      'amount': '₹ 500.00',
    },
    {
      'driverName': 'Jane Smith',
      'date': '10 July 2025',
      'time': '2:00 PM',
      'carType': 'SUV',
      'rideType': 'Round Trip',
      'status': 'Completed',
      'amount': '₹ 1200.00',
    },
    {
      'driverName': 'Alex Johnson',
      'date': '8 July 2025',
      'time': '5:30 PM',
      'carType': 'EV',
      'rideType': 'One Way',
      'status': 'Cancelled',
      'amount': '₹ 0.00',
    },
  ];

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
        child: ListView.separated(
          itemCount: bookings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _buildBookingCard(
              driverName: booking['driverName']!,
              date: booking['date']!,
              time: booking['time']!,
              carType: booking['carType']!,
              rideType: booking['rideType']!,
              status: booking['status']!,
              amount: booking['amount']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingCard({
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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Driver Name: $driverName'),
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
              Text(
                status,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
