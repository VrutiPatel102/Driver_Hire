import 'dart:async';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bookingDetails = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
        context,
        AppRoute.userRideDetailScreen,
        arguments: bookingDetails,
      );
    });
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
