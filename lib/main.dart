import 'package:acrogate/providers/auth_provider.dart';
import 'package:acrogate/providers/user_provider.dart';
import 'package:acrogate/routes.dart';
import 'package:acrogate/views/Screens/Onboarding/Register.dart';
import 'package:acrogate/views/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: acrogateTheme,
        routes: approutes,
      ),
    );
  }
}
