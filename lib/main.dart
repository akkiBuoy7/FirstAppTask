import 'package:first_app/Utility/ProjectUtil.dart';
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
      initialRoute: ProjectUtil.HOME_SCREEN_ROUTE,
      routes: {
        ProjectUtil.HOME_SCREEN_ROUTE: (context) =>  SplashScreen(),
        ProjectUtil.SECOND_SCREEN_ROUTE: (context) =>  LoginScreen(),
      },
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
    );
  }
}


