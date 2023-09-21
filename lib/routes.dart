import 'package:acrogate/views/Screens/AdminSide.dart';
import 'package:acrogate/views/Screens/BottomNav/UserBottomNav.dart';
import 'package:acrogate/views/Screens/Onboarding/Login.dart';
import 'package:acrogate/views/Screens/Onboarding/OTP.dart';
import 'package:acrogate/views/Screens/Onboarding/Register.dart';
import 'package:acrogate/views/Screens/Onboarding/SplashScreen.dart';
import 'package:flutter/material.dart';

var approutes = <String, WidgetBuilder>{
  // Inital Route
  '/': (context) => const SplashScreen(),

  //Login Routes
  LogIn.routeName: (context) => LogIn(),
  OtpScreen.routeName: (context) => const OtpScreen(),

  //Registration Routes
  Register.routeName: (context) => const Register(),

  //User Routes
  UserBottomBar.routeName: (context) => const UserBottomBar(),

  //Admin Side
  AdminSide.routeName: (context) => const AdminSide(),
};
