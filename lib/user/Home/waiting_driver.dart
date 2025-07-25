// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:driver_hire/color.dart';
// import 'package:driver_hire/navigation/appRoute.dart';
// import 'package:flutter/material.dart';
//
// class WaitingDriver extends StatefulWidget {
//   const WaitingDriver({super.key});
//
//   @override
//   State<WaitingDriver> createState() => _WaitingDriverState();
// }
//
// class _WaitingDriverState extends State<WaitingDriver> {
//   late Map<String, dynamic> bookingDetails;
//
//   @override
//   Widget build(BuildContext context) {
//     final args = ModalRoute.of(context)?.settings.arguments;
//     if (args == null || args is! Map<String, dynamic>) {
//       return const Scaffold(
//         body: Center(child: Text("Missing or invalid arguments.")),
//       );
//     }
//
//     bookingDetails = args;
//
//     final pickupAddress = bookingDetails['pickupAddress'] ?? '';
//     final dropAddress = bookingDetails['dropAddress'] ?? '';
//     final date = bookingDetails['date'] ?? '';
//     final time = bookingDetails['time'] ?? '';
//     final carType = bookingDetails['carType'] ?? '';
//     final tripType = bookingDetails['rideType'] ?? '';
//
//     return Scaffold(
//       backgroundColor: AColor().White,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Waiting for \n    Driver",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 30),
//           ),
//           Center(
//             child: Image.asset("assets/car_running2.gif", height: 320),
//           ),
//
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pushNamed(
//                 context,
//                 AppRoute.userRideDetailScreen,
//                 arguments: {
//                   'pickupAddress': pickupAddress,
//                   'dropAddress': dropAddress,
//                   'date': date,
//                   'time': time,
//                   'carType': carType,
//                   'rideType': tripType,
//                 },
//               );
//             },
//             child: const Icon(Icons.add),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              if (driverEmail != null && driverName == null) {
                FirebaseFirestore.instance
                    .collection('drivers')
                    .doc(driverEmail)
                    .get()
                    .then((driverSnap) {
                  if (driverSnap.exists) {
                    final name = driverSnap.data()?['name'] ?? '';
                    setState(() {
                      driverName = name;
                    });
                  }
                });
              }

              if (driverId != null &&
                  driverId.toString().isNotEmpty &&
                  !_hasNavigated) {
                _hasNavigated = true;
                final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

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
                      'userEmail': userEmail,
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
