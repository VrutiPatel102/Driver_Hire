import 'package:driver_hire/navigation/appRoute.dart';
import 'package:driver_hire/navigation/routeGenerator.dart';
import 'package:driver_hire/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoute.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

