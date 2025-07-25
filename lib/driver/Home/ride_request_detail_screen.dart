import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';

class RideRequestDetailScreen extends StatefulWidget {
  const RideRequestDetailScreen({super.key});

  @override
  State<RideRequestDetailScreen> createState() =>
      _RideRequestDetailScreenState();
}

class _RideRequestDetailScreenState extends State<RideRequestDetailScreen> {
  String userName = '';
  Map<String, String> data = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Map<String, dynamic>) {
      data = args.map((key, value) => MapEntry(key, value.toString()));
      fetchUserName(data['user_email'] ?? '');
    }
  }

  Future<void> fetchUserName(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        setState(() {
          userName = doc['name'] ?? '';
        });
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: _buildAppBar(context),
      body: _buildBody(data),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AColor().White,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Request Details',
        style: TextStyle(
          color: AColor().Black,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(Map<String, String> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AColor().green.withAlpha(26),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(data),
            const SizedBox(height: 12),
            _buildAddress(label: 'Pickup', value: data['pickup']!),
            const SizedBox(height: 10),
            _buildAddress(label: 'Dropoff', value: data['dropoff']!),
            const SizedBox(height: 16),
            _buildTripDetails(),
            const SizedBox(height: 16),
            _buildPaymentDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, String> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName.isNotEmpty ? userName : 'Loading...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text('${data['date']}  -  ${data['time']}'),
          ],
        ),
        Text(
          ' ${data['amount']}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildAddress({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700])),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTripDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text("Car Type"),
        Text(
          data['carType'] ?? 'N/A',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text("Trip Type"),
        Text(
          data['rideType'] ?? 'N/A',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text("Payment Details"),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [Text("Ride Fare"), Text("₹ 590.00")],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [Text("Tax Fare"), Text("₹ 10.00")],
        ),
        const Divider(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Total Estimate",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("₹ 600 .00", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AColor().Black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () async {
          final driver = FirebaseAuth.instance.currentUser;
          if (driver == null) return;

          final rideId = data['rideId'];
          if (rideId != null) {
            try {
              await FirebaseFirestore.instance
                  .collection('bookings')
                  .doc(rideId)
                  .update({
                    'driver_email': driver.email,
                    'driverId': driver.uid,
                    'status': 'Accepted',
                  });

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Ride accepted")));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Failed to accept ride: $e")),
              );
              return;
            }
          }

          // Navigation (already exists)
          Navigator.pushNamed(
            context,
            AppRoute.driverRideDetailScreen,
            arguments: data,
          );
        },
        child: const Text(
          "Go To Pickup",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
