import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: AColor().White,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios, size: 16),
        padding: const EdgeInsets.all(13),
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AColor().Black),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _headingText(),
          const SizedBox(height: 10),
          _subText(),
          const SizedBox(height: 30),
          _emailField(),
          const SizedBox(height: 30),
          _sendCodeBtn(),
          const Spacer(),
          _loginLink(),
        ],
      ),
    );
  }

  Widget _headingText() {
    return Text(
      'Forgot Password?',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AColor().green,
      ),
    );
  }

  Widget _subText() {
    return Text(
      'Don\'t worry! It occurs. Please enter the email\naddress linked with your account.',
      style: TextStyle(
        fontSize: 16,
        color: AColor().Black,
        height: 1.4,
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Enter Your Email',
        filled: true,
        fillColor: AColor().grey100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AColor().green),
        ),
      ),
    );
  }

  Widget _sendCodeBtn() {
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
         Navigator.pushNamed(context, AppRoute.otp);
        },
        child: Text(
          'Send Code',
          style: TextStyle(
            color: AColor().White,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _loginLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Remember password? ',
                style: TextStyle(color: AColor().Black),
              ),
              TextSpan(
                text: 'Login Now',
                style: TextStyle(
                  color: AColor().green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
