import 'dart:async';

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
  StreamSubscription<QuerySnapshot>? _bookingSubscription;

  @override
  void initState() {
    super.initState();
    listenToRideRequests();
  }

  void listenToRideRequests() {
    _bookingSubscription = FirebaseFirestore.instance
        .collection('bookings')
        .orderBy('saved_at', descending: true)
        .snapshots()
        .listen((snapshot) async {
      final List<Map<String, dynamic>> updatedRequests = [];

      // Collect all futures to fetch user names in parallel
      List<Future<void>> futures = snapshot.docs.map((doc) async {
        final bookingData = doc.data();
        bookingData['rideId'] = doc.id;

        final userEmail = bookingData['user_email'];
        String userName = 'Unknown';

        if (userEmail != null && userEmail.toString().isNotEmpty) {
          try {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(userEmail)
                .get();
            if (userDoc.exists) {
              userName = userDoc['name'] ?? 'Unknown';
            }
          } catch (e) {
            print("Error fetching user for $userEmail: $e");
          }
        }

        updatedRequests.add({
          ...bookingData,
          'name': userName,
          'pickup': bookingData['pickupAddress'],
          'dropoff': bookingData['dropAddress'],
          'amount': bookingData['fare'].toString(),
        });
      }).toList();

      await Future.wait(futures);

      if (mounted) {
        setState(() {
          rideRequests = updatedRequests;
        });
      }
    });
  }

  @override
  void dispose() {
    _bookingSubscription?.cancel();
    super.dispose();
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
            _buildAcceptButton(context, data),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              '${data['date'] ?? ''}  -  ${data['time'] ?? ''}',
              style: TextStyle(color: AColor().grey700),
            ),
          ],
        ),
        Row(
          children: [
            Text("₹", style: TextStyle(fontSize: 20)),
            SizedBox(width: 5),
            Text(
              data['amount'] ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddress({required String label, required String address}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AColor().grey700, fontSize: 14)),
        SizedBox(height: 4),
        Text(
          address,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildAcceptButton(
      BuildContext context,
      Map<String, dynamic> rideData,
      ) {
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
        onPressed: () async {
          try {
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser == null) {
              _showCustomToast(context, "Driver not logged in");
              return;
            }

            final rideId = rideData['rideId'];
            final updatedRideData = {
              ...rideData,
              'driverId': currentUser.uid,
            };

            await FirebaseFirestore.instance
                .collection('bookings')
                .doc(rideId)

                .update({
              'status': 'accepted',
              'driverId': currentUser.uid,
            });

            _showCustomToast(context, "Ride accepted");

            Navigator.pushNamed(
              context,
              AppRoute.driverRideDetailScreen,
              arguments: {
                'pickupAddress': rideData['pickup'] ?? '',
                'dropAddress': rideData['dropoff'] ?? '',
                'date': rideData['date'] ?? '',
                'time': rideData['time'] ?? '',
                'carType': rideData['car_type'] ?? '',
                'rideType': rideData['trip_type'] ?? '',
                'rideId': rideId,
                'userEmail': rideData['user_email'] ?? '',
              },
            );


          } catch (e) {
            print("Error accepting ride: $e");
            _showCustomToast(context, "Failed to accept ride");
          }
        },
        child: Text('Accept', style: TextStyle(color: AColor().White)),
      ),
    );
  }

  void _showCustomToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final textWidth = (message.length * 8.0).clamp(
      100.0,
      MediaQuery.of(context).size.width * 0.8,
    );

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 150,
        left: (MediaQuery.of(context).size.width - textWidth) / 2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AColor().grey300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(color: AColor().Black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(
      const Duration(seconds: 2),
    ).then((_) => overlayEntry.remove());
  }
}
