import 'package:driver_hire/color.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: AppBar(
        title: const Text("Privacy Policy", style: TextStyle(color: Colors.black)),
        backgroundColor: AColor().White,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: const [
          Text(
            "Privacy Policy",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            "Your privacy is important to us. It is our policy to respect your privacy regarding any "
                "information we may collect from you across our website, [YourWebsiteURL], and other sites we own and operate.",
          ),

          SizedBox(height: 20),
          Text(
            "1. Information we collect",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            "We only collect information about you if we have a reason to do so — for example, to provide "
                "our services, to communicate with you, or to make our services better. The types of information we collect may include:",
          ),
          SizedBox(height: 10),
          BulletPoint(text: "Contact details (such as name, email address, phone number)"),
          BulletPoint(text: "Payment information (if you make a purchase)"),
          BulletPoint(text: "Demographic information (such as age, gender, location)"),
          BulletPoint(text: "Usage data (such as pages visited, interactions with the website)"),

          SizedBox(height: 20),
          Text(
            "2. How we use your information",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text("We use the information we collect for various purposes, including to:"),
          SizedBox(height: 10),
          BulletPoint(text: "Provide, operate, and maintain our website and services"),
          BulletPoint(text: "Process and complete transactions"),
          BulletPoint(text: "Respond to your inquiries, requests, and comments"),
          BulletPoint(text: "Communicate with you about promotions, updates, and news"),
          BulletPoint(text: "Analyze and improve our website and services"),

          SizedBox(height: 20),
          Text(
            "3. Data retention",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            "We will retain your personal information only for as long as is necessary for the purposes set out "
                "in this Privacy Policy. We will retain and use your information to the extent necessary to comply "
                "with our legal obligations, resolve disputes, and enforce our policies.",
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
