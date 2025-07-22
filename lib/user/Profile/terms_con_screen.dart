import 'package:driver_hire/color.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: AppBar(
        title: const Text("Terms of Use", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AColor().White,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text("Effective Date: 18/07/2024\n", style: TextStyle(fontWeight: FontWeight.w500)),

          _Section(
            title: "1. Acceptance of Terms",
            content:
            "By accessing and using the HR Attendance App (\"the App\"), you accept and agree to be bound by the terms and provision of this agreement. In addition, when using the App's particular services, you shall be subject to any posted guidelines or rules applicable to such services. Any participation in this service will constitute acceptance of this agreement. If you do not agree to abide by the above, please do not use this service.",
          ),
          _Section(
            title: "2. Description of Service",
            content:
            "The App provides employees and employers with attendance tracking and management services. Features include clock-in/out functionality, attendance history, and reporting tools.",
          ),
          _Section(
            title: "3. User Responsibilities",
            content:
            "Users agree to use the App for lawful purposes only. Users are responsible for maintaining the confidentiality of their login information and for all activities that occur under their account.",
          ),
          _Section(
            title: "4. Privacy Policy",
            content:
            "Your use of the App is also governed by our Privacy Policy, which is incorporated into these Terms by reference. Please review our Privacy Policy to understand our practices regarding the collection and use of your personal information.",
          ),
          _Section(
            title: "5. Intellectual Property",
            content:
            "The App and its original content, features, and functionality are and will remain the exclusive property of [Your Company Name] and its licensors. The App is protected by copyright, trademark, and other laws of both the United States and foreign countries.",
          ),
          _Section(
            title: "6. Termination",
            content:
            "We may terminate or suspend access to our App immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.",
          ),
          _Section(
            title: "7. Limitation of Liability",
            content:
            "In no event shall [Your Company Name], nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.",
          ),
          _Section(
            title: "8. Changes to the Terms",
            content:
            "We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days' notice prior to any new terms taking effect.",
          ),
          _Section(
            title: "9. Contact Information",
            content:
            "If you have any questions about these Terms, please contact us at: [Your Contact Information]",
          ),
          _Section(
            title: "10. Governing Law",
            content:
            "These Terms shall be governed and construed in accordance with the laws of [Your State/Country], without regard to its conflict of law provisions.",
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          const SizedBox(height: 8),
          Text(content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              )),
        ],
      ),
    );
  }
}
