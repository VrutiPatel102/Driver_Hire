import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';

class ChooseDriverUser extends StatelessWidget {
  const ChooseDriverUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 60),
              Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.transparent,
                    child: Image.asset("assets/appIcon.png"),
                  ),
                  const SizedBox(height: 32),
                  RichText(
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
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
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
                        Navigator.pushNamed(context, AppRoute.login);
                      },
                      child: Text(
                        'Login as User',
                        style: TextStyle(fontSize: 16, color: AColor().White),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoute.login);
                      },
                      child: const Text(
                        'Login as Driver',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
