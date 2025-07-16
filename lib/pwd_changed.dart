import 'package:driver_hire/color.dart';
import 'package:flutter/material.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _successIcon(),
            const SizedBox(height: 40),
            _headingText(),
            const SizedBox(height: 20),
            _subText(),
            const SizedBox(height: 40),
            _backToLoginBtn(context),
          ],
        ),
      ),
    );
  }

  Widget _successIcon() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AColor().green,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        color: AColor().White,
        size: 60,
      ),
    );
  }

  Widget _headingText() {
    return Text(
      'Password Changed!',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AColor().green,
      ),
    );
  }

  Widget _subText() {
    return Text(
      'Your password has been\nchanged successfully.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: AColor().Black,
        height: 1.4,
      ),
    );
  }

  Widget _backToLoginBtn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AColor().Black,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // Go back to Login Screen
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: Text(
          'Back to Login',
          style: TextStyle(
            color: AColor().White,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
