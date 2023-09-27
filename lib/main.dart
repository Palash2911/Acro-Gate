import 'package:acrogate/providers/auth_provider.dart';
import 'package:acrogate/providers/entry_provider.dart';
import 'package:acrogate/providers/firebasenotification.dart';
import 'package:acrogate/providers/user_provider.dart';
import 'package:acrogate/routes.dart';
import 'package:acrogate/views/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MyApp());
}

@pragma("vm:entry-point")
Future<void> backgroundHandler(RemoteMessage mssg) async {
  await Firebase.initializeApp();
  print(mssg);
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
        ChangeNotifierProvider(
          create: (BuildContext context) => EntryProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: acrogateTheme,
        navigatorKey: navigatorKey,
        routes: approutes,
      ),
    );
  }
}
