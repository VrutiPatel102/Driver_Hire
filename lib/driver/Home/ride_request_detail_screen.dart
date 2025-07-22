import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';

class RideRequestDetailScreen extends StatelessWidget {
  const RideRequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> data =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>;

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
        icon: Icon(Icons.arrow_back_ios, color: AColor().green),
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
              data['name'] ?? '',
              style:  TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
             SizedBox(height: 4),
            Text('${data['date']}  -  ${data['time']}'),
          ],
        ),
        Text(
          ' ${data['amount']}',
          style:  TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
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
        Text(value, style:  TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTripDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text("Car Type"),
        const Text("SUV", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text("Trip Type"),
        const Text("One-Way Trip", style: TextStyle(fontWeight: FontWeight.w600)),
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
          children: const [
            Text("Ride Fare"),
            Text("₹ 590.00"),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Tax Fare"),
            Text("₹ 10.00"),
          ],
        ),
        const Divider(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Total Estimate", style: TextStyle(fontWeight: FontWeight.bold)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.driverRideDetailScreen);
        },
        child: const Text("Go To Pickup", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
