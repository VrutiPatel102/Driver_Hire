import 'package:driver_hire/bottom_bar.dart';
import 'package:driver_hire/Home/book_driver.dart';
import 'package:driver_hire/Home/detail_screen.dart';
import 'package:driver_hire/Home/waiting_driver.dart';
import 'package:driver_hire/choose_driverORuser.dart';
import 'package:driver_hire/create_newPwd.dart';
import 'package:driver_hire/driver/driver_bottom_bar.dart';
import 'package:driver_hire/forgotPwd.dart';
import 'package:driver_hire/login_screen.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:driver_hire/otp.dart';
import 'package:driver_hire/pwd_changed.dart';
import 'package:driver_hire/register_screen.dart';
import 'package:driver_hire/splash_screen.dart';
import 'package:driver_hire/user/Home/book_driver.dart';
import 'package:flutter/material.dart';

class RouteGenerator{

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.splash:
        return MaterialPageRoute(
          builder: (context) => Spalshscreen(),
          settings: settings,
        );
      case AppRoute.chooseScreen:
        return MaterialPageRoute(
          builder: (context) => ChooseDriverUser(),
          settings: settings,
        );
      case AppRoute.login:
        final loginAs = settings.arguments as String? ?? 'user'; // default to 'user'
        return MaterialPageRoute(
          builder: (context) => LoginScreen(loginAs: loginAs),
          settings: settings,
        );
      case AppRoute.register:
        return MaterialPageRoute(
          builder: (context) => RegisterScreen(),
          settings: settings,
        );
      case AppRoute.forgotpassword:
        return MaterialPageRoute(
          builder: (context) => ForgotPasswordScreen(),
          settings: settings,
        );
      case AppRoute.otp:
        return MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(),
          settings: settings,
        );
      case AppRoute.resetPwd:
        return MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(),
          settings: settings,
        );
      case AppRoute.pwdchanged:
        return MaterialPageRoute(
          builder: (context) => PasswordChangedScreen(),
          settings: settings,
        );
      case AppRoute.bottombar:
        return MaterialPageRoute(
          builder: (context) => BottomBarScreen(),
          settings: settings,
        );
      case AppRoute.driverBooking:
        return MaterialPageRoute(
          builder: (context) => BookDriverScreen(),
          settings: settings,
        );
      case AppRoute.driverbottombar:
        return MaterialPageRoute(
          builder: (context) => DriverBottomBarScreen(),
          settings: settings,
        );
      case AppRoute.waitingDriver:
        return MaterialPageRoute(
          builder: (context) => WaitingDriver(),
          settings: settings,
        );
      case AppRoute.detailscreen:
        return MaterialPageRoute(
          builder: (context) => DetailScreen(),
          settings: settings,
        );

    }
    return MaterialPageRoute(
      builder: (context) => Container(child: Text("ERROR")),
    );
  }

}