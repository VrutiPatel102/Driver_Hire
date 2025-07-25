
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';

class WaitingDriver extends StatefulWidget {
  const WaitingDriver({super.key});

  @override
  State<WaitingDriver> createState() => _WaitingDriverState();
}

class _WaitingDriverState extends State<WaitingDriver> {
  late Map<String, dynamic> bookingDetails;
  bool _hasNavigated = false;
  String? driverName;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Map<String, dynamic>) {
      return const Scaffold(
        body: Center(child: Text("Missing or invalid arguments.")),
      );
    }

    bookingDetails = args;

    final bookingId = bookingDetails['bookingId'];
    final pickupAddress = bookingDetails['pickupAddress'] ?? '';
    final dropAddress = bookingDetails['dropAddress'] ?? '';
    final date = bookingDetails['date'] ?? '';
    final time = bookingDetails['time'] ?? '';
    final carType = bookingDetails['carType'] ?? '';
    final tripType = bookingDetails['rideType'] ?? '';

    return Scaffold(
      backgroundColor: AColor().White,
      body: Stack(
        children: [
          // Static UI
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Waiting for \nDriver",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                Image.asset("assets/car_running2.gif", height: 320),
                const SizedBox(height: 20),
                if (driverName != null) ...[
                  const Text(
                    "Driver Assigned:",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    driverName!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ],
            ),
          ),

          // Stream listening to booking document
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('bookings')
                .doc(bookingId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const SizedBox();
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final driverId = data['driverId'];
              final driverEmail = data['driver_email'];

              // Fetch driver name once when driver_email is available
              if (driverId != null &&
                  driverId.toString().isNotEmpty &&
                  !_hasNavigated) {
                _hasNavigated = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoute.userRideDetailScreen,
                    arguments: {
                      'pickupAddress': pickupAddress,
                      'dropAddress': dropAddress,
                      'date': date,
                      'time': time,
                      'carType': carType,
                      'rideType': tripType,
                    },
                  );
                });
              }


              // Navigate only once when driver accepts
              if (driverId != null &&
                  driverId.toString().isNotEmpty &&
                  !_hasNavigated) {
                _hasNavigated = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoute.userRideDetailScreen,
                    arguments: {
                      'pickupAddress': pickupAddress,
                      'dropAddress': dropAddress,
                      'date': date,
                      'time': time,
                      'carType': carType,
                      'rideType': tripType,
                    },
                  );
                });
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
