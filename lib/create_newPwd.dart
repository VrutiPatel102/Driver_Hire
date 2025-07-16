import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

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
        icon:  Icon(Icons.arrow_back_ios, size: 16),
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
          _newPasswordField(),
          const SizedBox(height: 16),
          _confirmPasswordField(),
          const SizedBox(height: 20),
          _resetBtn(),
          const SizedBox(height: 10),
          if (_errorMessage != null) _errorText(),
        ],
      ),
    );
  }

  Widget _headingText() {
    return Text(
      'Create new\nPassword',
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

  Widget _newPasswordField() {
    return TextField(
      controller: _newPasswordController,
      obscureText: _obscureNewPassword,
      decoration: InputDecoration(
        hintText: 'New Password',
        filled: true,
        fillColor: AColor().grey100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AColor().green, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureNewPassword = !_obscureNewPassword;
            });
          },
        ),
      ),
    );
  }

  Widget _confirmPasswordField() {
    return TextField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        filled: true,
        fillColor: AColor().grey100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AColor().green, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ),
    );
  }

  Widget _resetBtn() {
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
        onPressed: _handleResetPassword,
        child: Text(
          'Reset Password',
          style: TextStyle(
            color: AColor().White,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _handleResetPassword() {
    setState(() {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        _errorMessage = 'Password not match! please try again';
      } else {
        _errorMessage = null;
       Navigator.pushNamed(context,AppRoute.pwdChanged);
      }
    });
  }

  Widget _errorText() {
    return Text(
      _errorMessage!,
      style: TextStyle(
        color: Colors.redAccent,
        fontSize: 16,
      ),
    );
  }
}
