import 'package:first_app/Utility/project_util.dart';
import 'package:first_app/bloc/internet_bloc/internet_bloc.dart';
import 'package:first_app/ui/DashScreen.dart';
import 'package:first_app/ui/LoginScreen.dart';
import 'package:first_app/ui/SplashScreen.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/home_screen_details.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/advance_player_screen.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'navigation/app_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp(
    connectivity: Connectivity(),
  ));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AppNavigation _appNavigation = AppNavigation();
  final Connectivity connectivity;

  MyApp({
    super.key,
    required this.connectivity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetBloc(connectivity),
      child: MaterialApp(
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
      ),
    );
  }
}
