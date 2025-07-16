import 'package:flutter/material.dart';

class DriverRideDetailScreen extends StatefulWidget {
  const DriverRideDetailScreen({super.key});

  @override
  State<DriverRideDetailScreen> createState() => _DriverRideDetailScreenState();
}

class _DriverRideDetailScreenState extends State<DriverRideDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(),);
  }

  AppBar _buildAppbar()
  {
    return AppBar(title: Text("Ride Details"),);
  }
}
