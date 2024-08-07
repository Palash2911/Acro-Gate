import 'package:acrogate/providers/auth_provider.dart';
import 'package:acrogate/views/Screens/AdminBottomNav/AdminBottomNav.dart';
import 'package:acrogate/views/Screens/UserBottomNav/UserBottomNav.dart';
import 'package:acrogate/views/Screens/Onboarding/Login.dart';
import 'package:acrogate/views/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:acrogate/views/Screens/SizeConfig.dart';
import 'package:provider/provider.dart';

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
          Navigator.of(ctx).pushReplacementNamed(AdminBottomBar.routeName);
        } else {
          if (authProvider.isAuth) {
            const initin = 1;
            Navigator.of(ctx).pushReplacementNamed(UserBottomBar.routeName,
                arguments: initin);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 450.0,
              child: Image.asset(
                'assets/animation/splash.gif',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: AutoSizeText(
              "By ChairPerson - Jubin Jain",
              style: kTextPopB14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
