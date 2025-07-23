import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

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
          _otpFields(),
          const SizedBox(height: 30),
          _verifyBtn(),
          const Spacer(),
          _loginLink(),
        ],
      ),
    );
  }

  Widget _headingText() {
    return Text(
      'OTP Verification',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AColor().green,
      ),
    );
  }

  Widget _subText() {
    return Text(
      'Enter the verification code we just sent on your\nemail address',
      style: TextStyle(fontSize: 16, color: AColor().Black, height: 1.4),
    );
  }

  Widget _otpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        _otpControllers.length,
        (index) => SizedBox(
          width: 60,
          height: 60,
          child: TextField(
            controller: _otpControllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AColor().Black,
            ),
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AColor().grey100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _verifyBtn() {
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
        onPressed: _verifyOtp,
        child: Text(
          'Verify',
          style: TextStyle(color: AColor().White, fontSize: 18),
        ),
      ),
    );
  }

  void _verifyOtp() {
    String enteredOtp = _otpControllers.map((c) => c.text).join();
    if (enteredOtp == '1234') {
      Navigator.pushNamed(context, AppRoute.resetPwd);
    } else {
      _showCustomToast('Invalid OTP, please try again!');
    }
  }

  void _showCustomToast(String message) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 150,
        left: MediaQuery.of(context).size.width * 0.5 - (message.length * 4.0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AColor().grey300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(message, style: TextStyle(color: AColor().Black)),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(
      const Duration(seconds: 2),
    ).then((_) => overlayEntry.remove());
  }

  Widget _loginLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.login);
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
