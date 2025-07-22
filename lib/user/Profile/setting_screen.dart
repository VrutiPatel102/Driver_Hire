import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLocationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AColor().White,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Location", style: TextStyle(fontSize: 16)),
            trailing: Switch(
              value: isLocationEnabled,
              onChanged: (value) {
                setState(() {
                  isLocationEnabled = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.green,
            ),
          ),
          Divider(indent: 16, endIndent: 16),
          ListTile(
            title: Text("Privacy Policy"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, AppRoute.privacyPolicy);
            },
          ),
          Divider(indent: 16, endIndent: 16),
          ListTile(
            title: Text("Terms and Conditions"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, AppRoute.termsAndCondition);
            },
          ),
        ],
      ),
    );
  }
}
