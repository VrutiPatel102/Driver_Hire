import 'dart:async';
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
  StreamSubscription<DocumentSnapshot>? _bookingListener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bookingDetails = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String bookingId = bookingDetails['bookingId'];

    // Listen for status change in booking document
    _bookingListener = FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        if (data['status'] == 'accepted') {
          _bookingListener?.cancel();
          Navigator.pushReplacementNamed(
            context,
            AppRoute.userRideDetailScreen,
            arguments: bookingDetails,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _bookingListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Waiting for \n    Driver",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
          ),
          Center(
            child: Image.asset("assets/car_running2.gif", height: 320),
          ),
        ],
      ),
    );
  }
}
