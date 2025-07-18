import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody(context)));
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          "Profile Setting",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        _buildProfileAvatar(),
        SizedBox(height: 10),
        Text(
          "Albert Stevano Bajefski",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 30),
        _buildSectionTitle("Profile"),
        _buildMenuItem(Icons.person, "Personal Data", () {
          Navigator.pushNamed(context, AppRoute.personalData);
        }),
        _buildMenuItem(Icons.settings, "Settings", () {}),
        SizedBox(height: 20),
        _buildSectionTitle("Support"),
        _buildMenuItem(Icons.info_outline, "Help Center", () {}),
        _buildMenuItem(Icons.delete_outline, "Request Account Deletion", () {}),
        Spacer(),
        _buildSignOutButton(context),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return CircleAvatar(
      radius: 45,
      backgroundColor: Color(0xFFF5F5F5),
      child: Icon(Icons.person, size: 40, color: Colors.grey),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AColor().green100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AColor().green),
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AColor().Black,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            "Sign Out",
            style: TextStyle(fontSize: 20, color: AColor().White),
          ),
        ),
      ),
    );
  }
}
