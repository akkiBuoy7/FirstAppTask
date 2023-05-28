import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_app/bloc/internet_bloc/internet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' show Client;

import 'navigation/app_navigation.dart';
void main() {
  runApp(MyApp(
    connectivity: Connectivity(),
  ));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AppNavigation _appNavigation = AppNavigation(Client());
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
