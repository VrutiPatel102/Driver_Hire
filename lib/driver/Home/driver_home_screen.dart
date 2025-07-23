import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  List<Map<String, dynamic>> rideRequests = [];

  @override
  void initState() {
    super.initState();
    fetchRideRequests();
  }

  Future<void> fetchRideRequests() async {
    final bookingSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .get();

    List<Map<String, dynamic>> mergedData = [];

    for (var doc in bookingSnapshot.docs) {
      final bookingData = doc.data();
      final bookingUid = bookingData['uid'];

      if (bookingUid == null || bookingUid.isEmpty) {
        continue; // skip if no UID in booking
      }

      // Find user who matches the UID in 'users' collection
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: bookingUid)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        print("No user found for UID: $bookingUid");
        continue;
      }

      final userData = userQuery.docs.first.data();
      final userName = userData['name'] ?? 'User';

      print("Booking UID: $bookingUid, User: $userName");

      // Combine booking + user data
      mergedData.add({
        'name': userName,
        'pickup': bookingData['pickup'] ?? '',
        'dropoff': bookingData['drop'] ?? '',
        'date': bookingData['date'] ?? '',
        'time': bookingData['time'] ?? '',
        'amount': bookingData['amount']?.toString() ?? '',
      });
    }

    setState(() {
      rideRequests = mergedData;
    });

    print("Total ride requests: ${rideRequests.length}");
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AColor().White,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Ride Requests',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AColor().Black,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: rideRequests.length,
      separatorBuilder: (_, __) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final data = rideRequests[index];
        return _buildRequestCard(data, context);
      },
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> data, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.rideRequestDetailScreen,
          arguments: data,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AColor().green.withAlpha(26),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(data),
            SizedBox(height: 12),
            Divider(color: AColor().green.withAlpha(102)),
            SizedBox(height: 12),
            _buildAddress(label: 'Pickup', address: data['pickup'] ?? ''),
            SizedBox(height: 10),
            _buildAddress(label: 'Dropoff', address: data['dropoff'] ?? ''),
            SizedBox(height: 20),
            _buildAcceptButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['name'] ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${data['date'] ?? ''}  -  ${data['time'] ?? ''}',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
        Text(
          data['amount'] ?? '',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAddress({required String label, required String address}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(
          address,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AColor().Black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.driverRideDetailScreen);
        },
        child: Text(
          'Accept',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}