import 'package:acrogate/providers/auth_provider.dart';
import 'package:acrogate/views/Screens/BottomNav/UserBottomNav.dart';
import 'package:acrogate/views/Screens/Onboarding/Login.dart';
import 'package:acrogate/views/constants.dart';
import 'package:flutter/material.dart';
import 'package:acrogate/views/Screens/SizeConfig.dart';
import 'package:provider/provider.dart';

import '../AdminSide.dart';

class SplashScreen extends StatefulWidget {
  static var routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadScreen(context);
  }

  Future loadScreen(BuildContext ctx) async {
    var authProvider = Provider.of<Auth>(context, listen: false);

    Future.delayed(const Duration(seconds: 2), () async {
      await authProvider.autoLogin().then((_) async {
        if (authProvider.token == "6RSj6M3qYAYLXkICEOYvNsIkAgE2") {
          Navigator.of(ctx).pushReplacementNamed(AdminSide.routeName);
        } else {
          if (authProvider.isAuth) {
            Navigator.of(ctx).pushReplacementNamed(UserBottomBar.routeName);
          } else {
            Navigator.of(ctx).pushReplacementNamed(LogIn.routeName);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: ksecondaryColor,
      body: Center(
        child: SizedBox(
          height: 350.0,
          child: Image.asset(
            'assets/animation/splash.gif',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
