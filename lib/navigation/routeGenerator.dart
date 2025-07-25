import 'package:driver_hire/bottom_bar.dart';
import 'package:driver_hire/choose_driverORuser.dart';
import 'package:driver_hire/create_newPwd.dart';
import 'package:driver_hire/driver/Home/driver_ride_detail_screen.dart';
import 'package:driver_hire/driver/Home/ride_request_detail_screen.dart';
import 'package:driver_hire/driver/Profile/driver_personal_data.dart';
import 'package:driver_hire/driver/driver_bottom_bar.dart';
import 'package:driver_hire/forgotPwd.dart';
import 'package:driver_hire/login_screen.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:driver_hire/otp.dart';
import 'package:driver_hire/pwd_changed.dart';
import 'package:driver_hire/register_screen.dart';
import 'package:driver_hire/splash_screen.dart';
import 'package:driver_hire/user/Home/book_driver.dart';
import 'package:driver_hire/user/Profile/personal_data.dart';
import 'package:driver_hire/user/Profile/privacy_screen.dart';
import 'package:driver_hire/user/Profile/setting_screen.dart';
import 'package:driver_hire/user/Profile/terms_con_screen.dart';
import 'package:flutter/material.dart';
import '../user/Home/detail_screen.dart';
import '../user/Home/waiting_driver.dart';

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
        final role = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(),
        );

      case AppRoute.forgotPassword:
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
      case AppRoute.pwdChanged:
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
      case AppRoute.driverBottombar:
        return MaterialPageRoute(
          builder: (context) => DriverBottomBarScreen(),
          settings: settings,
        );
      case AppRoute.waitingDriver:
        return MaterialPageRoute(
          builder: (context) => WaitingDriver(),
          settings: settings,
        );
      case AppRoute.personalData:
        return MaterialPageRoute(
          builder: (context) => PersonalDataScreen(),
          settings: settings,
        );
      case AppRoute.driverPersonalData:
        return MaterialPageRoute(
          builder: (context) => DriverPersonalDataScreen(),
          settings: settings,
        );

      case AppRoute.userRideDetailScreen:
        final args = settings.arguments;
        if (args == null || args is! Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text("Missing or invalid arguments.")),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (context) => UserRideDetailScreen(
            pickupAddress: args['pickupAddress'] ?? '',
            dropAddress: args['dropAddress'] ?? '',
            date: args['date'] ?? '',
            time: args['time'] ?? '',
            carType: args['carType'] ?? '',
            rideType: args['rideType'] ?? '',
            userEmail: args['userEmail'] ?? '',
            bookingId: args['bookingId'] ?? '',
          ),
          settings: settings,
        );



      case AppRoute.rideRequestDetailScreen:
        return MaterialPageRoute(
          builder: (context) => RideRequestDetailScreen(),
          settings: settings,
        );
      case AppRoute.driverRideDetailScreen:
        return MaterialPageRoute(
          builder: (context) => DriverRideDetailScreen(),
          settings: settings,
        );
      case AppRoute.setting:
        return MaterialPageRoute(
          builder: (context) => SettingsScreen(),
          settings: settings,
        );
      case AppRoute.privacyPolicy:
        return MaterialPageRoute(
          builder: (context) => PrivacyPolicyScreen(),
          settings: settings,
        );
      case AppRoute.termsAndCondition:
        return MaterialPageRoute(
          builder: (context) => TermsScreen(),
          settings: settings,
        );


    }
    return MaterialPageRoute(
      builder: (context) => Container(child: Text("ERROR")),
    );
  }

}