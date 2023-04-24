import 'package:first_app/Utility/project_util.dart';
import 'package:first_app/ui/DashScreen.dart';
import 'package:first_app/ui/LoginScreen.dart';
import 'package:first_app/ui/SplashScreen.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/home_screen_details.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/advance_player_screen.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/player_screen.dart';
import 'package:flutter/material.dart';

import 'navigation/app_navigation.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AppNavigation _appNavigation = AppNavigation();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _appNavigation.onGenerateRoute,
      // initialRoute: ProjectUtil.SPLASH_SCREEN_ROUTE,
      // routes: {
      //   ProjectUtil.SPLASH_SCREEN_ROUTE: (context) => SplashScreen(),
      //   ProjectUtil.LOGIN_SCREEN_ROUTE: (context) => LoginScreen(),
      //   ProjectUtil.DASH_SCREEN_ROUTE: (context) => DashScreen(),
      //   ProjectUtil.HOME_DETAILS_SCREEN_ROUTE: (context) => HomeDetailsScreen(),
      //   ProjectUtil.PLAYERS_SCREEN_ROUTE: (context) => PlayerScreen(),
      //   //ProjectUtil.ADVANCE_PLAYERS_SCREEN_ROUTE: (context) => AdvancePlayerScreen(),
      // },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
