import 'package:first_app/bloc/home_movies_bloc.dart';
import 'package:first_app/bloc/watchlist_bloc/tvguide_bloc.dart';
import 'package:first_app/bloc/watchlist_bloc/tvguide_options_bloc/tv_guide_options_bloc.dart';
import 'package:first_app/repository/home_repository.dart';
import 'package:first_app/repository/tv_guide_repository.dart';
import 'package:first_app/ui/DashScreen.dart';
import 'package:first_app/ui/LoginScreen.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/tv_guide_screen.dart';
import 'package:first_app/ui/bottom_nav_screens/home_screen.dart';
import 'package:first_app/ui/bottom_nav_screens/watchlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/src/client.dart';
import '../Utility/project_util.dart';
import '../model/movie_items.dart';
import '../ui/SplashScreen.dart';
import '../ui/bottom_nav_screens/bottom_nav_detail_screens/home_screen_details.dart';

class AppNavigation {

  Client client;

  AppNavigation(this.client);

  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case ProjectUtil.SPLASH_SCREEN_ROUTE:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case ProjectUtil.LOGIN_SCREEN_ROUTE:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case ProjectUtil.DASH_SCREEN_ROUTE:
        return MaterialPageRoute(
            builder: (_) =>
                MultiRepositoryProvider(
                  providers: [
                    RepositoryProvider<HomeRepository>(
                        create: (context) => HomeRepository()),
                    RepositoryProvider<TvGuideRepository>(
                        create: (context) => TvGuideRepository()),
                  ],
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<TvGuideBloc>(
                        create: (BuildContext context) => TvGuideBloc(
                          context.read<TvGuideRepository>(),
                        ),
                      ),
                      BlocProvider<HomeMoviesBloc>(
                        create: (BuildContext context) => HomeMoviesBloc(
                          context.read<HomeRepository>(),
                        ),
                      ),
                      BlocProvider<TvGuideOptionsBloc>(
                        create: (BuildContext context) => TvGuideOptionsBloc(
                        ),
                      ),
                    ],
                    child: DashScreen(),
                  ),
                ));

      case ProjectUtil.HOME_SCREEN_ROUTE:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case ProjectUtil.TVGUIDE_SCREEN_ROUTE:
        return MaterialPageRoute(builder: (_) => TvGuideScreen());
      case ProjectUtil.WATCHLIST_SCREEN_ROUTE:
        return MaterialPageRoute(builder: (_) => WatchlistScreen());
        //     MultiRepositoryProvider(
        //   providers: [
        //     RepositoryProvider<TvGuideRepository>(
        //         create: (context) => TvGuideRepository()),
        //   ],
        //   child: MultiBlocProvider(
        //     providers: [
        //       BlocProvider<TvGuideBloc>(
        //         create: (BuildContext context) => TvGuideBloc(
        //           context.read<TvGuideRepository>(),
        //         ),
        //       ),
        //       BlocProvider<TvGuideOptionsBloc>(
        //         create: (BuildContext context) => TvGuideOptionsBloc(
        //         ),
        //       ),
        //     ],
        //     child: WatchlistScreen(),
        //   ),
        // ));
      case ProjectUtil.HOME_DETAILS_SCREEN_ROUTE:
        MovieDetail movieDetail = routeSettings.arguments as MovieDetail;
        return MaterialPageRoute(
            builder: (_) => HomeDetailsScreen(movieDetail));
      default:
        return null;
    }
  }
}

// MaterialPageRoute(
// builder: (_) => RepositoryProvider(
// create: (context) => HomeRepository(),
// child: BlocProvider(
// create: (context) => HomeMoviesBloc(
// context.read<HomeRepository>(),
// ),
// child: DashScreen()
// ),
// ));
