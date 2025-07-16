import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  final List<Map<String, String>> rideRequests = const [
    {
      'name': 'Prakruti Shah',
      'date': '01/01/2025',
      'time': '6.54 pm',
      'pickup': '1 Sky Heven Avenue, Satellite',
      'dropoff': '1 Bola Dada Avenue, Satellite',
      'amount': '600',
    },
    {
      'name': 'Prakruti Shah',
      'date': '01/01/2025',
      'time': '6.54 pm',
      'pickup': '1 Sky Heven Avenue, Satellite',
      'dropoff': '1 Bola Dada Avenue, Satellite',
      'amount': '600',
    },
    {
      'name': 'Prakruti Shah',
      'date': '01/01/2025',
      'time': '6.54 pm',
      'pickup': '1 Sky Heven Avenue, Satellite',
      'dropoff': '1 Bola Dada Avenue, Satellite',
      'amount': '600',
    },
  ];

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
        return _buildRequestCard(data,context);
      },
    );
  }

  Widget _buildRequestCard(Map<String, String> data, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.rideRequestDetailScreen,
          arguments: data, // Send data to details screen
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AColor().green.withAlpha(26), // 26 is 10% of 255,
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
            _buildAddress(label: 'Pickup', address: data['pickup']!),
            SizedBox(height: 10),
            _buildAddress(label: 'Dropoff', address: data['dropoff']!),
            SizedBox(height: 20),
            _buildAcceptButton(context),
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
              data['name'] ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${data['date']}  -  ${data['time']}',
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
