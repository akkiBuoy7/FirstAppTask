import 'package:first_app/Utility/ProjectUtil.dart';
import 'package:first_app/ui/DashScreen.dart';
import 'package:first_app/ui/LoginScreen.dart';
import 'package:first_app/ui/SplashScreen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: ProjectUtil.SPLASH_SCREEN_ROUTE,
      routes: {
        ProjectUtil.SPLASH_SCREEN_ROUTE: (context) =>  SplashScreen(),
        ProjectUtil.LOGIN_SCREEN_ROUTE: (context) =>  LoginScreen(),
        ProjectUtil.DASH_SCREEN_ROUTE: (context) =>  DashScreen(),
      },
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
    );
  }
}


