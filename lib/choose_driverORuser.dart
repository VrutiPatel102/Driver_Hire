import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';

class ChooseDriverUser extends StatelessWidget {
  const ChooseDriverUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context)
  {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             SizedBox(height: 60),
            _buildHeader(),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.transparent,
          child: Image.asset("assets/appIcon.png"),
        ),
         SizedBox(height: 32),
        _buildTitleText(),
      ],
    );
  }

  Widget _buildTitleText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Your All in one\n',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AColor().Black,
        ),
        children: [
          TextSpan(
            text: 'Driver booking\n',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AColor().green,
            ),
          ),
          TextSpan(
            text: 'Application',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AColor().Black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        _buildLoginButton(context, 'Login as User', 'user'),
         SizedBox(height: 12),
        _buildOutlinedButton(context, 'Login as Driver', 'driver'),
         SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, String text, String role) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AColor().Black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoute.login,
            arguments: role,
          );
        },
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: AColor().White),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, String text, String role) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side:  BorderSide(color: AColor().Black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoute.login,
            arguments: role,
          );
        },
        child: Text(
          text,
          style:  TextStyle(fontSize: 16, color: AColor().Black),
        ),
      ),
    );
  }
}
