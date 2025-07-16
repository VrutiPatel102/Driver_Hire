import 'dart:async';
import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';

import 'choose_driverORuser.dart';
class Spalshscreen extends StatefulWidget {
  const Spalshscreen({super.key});

  @override
  State<Spalshscreen> createState() => _SpalshscreenState();
}

class _SpalshscreenState extends State<Spalshscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(context, AppRoute.chooseScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      body: Center(child: Image.asset("assets/appIcon.png"))
    );
  }

}