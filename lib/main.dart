import 'package:driver_hire/navigation/appRoute.dart';
import 'package:driver_hire/navigation/routeGenerator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoute.driverBottombar,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

