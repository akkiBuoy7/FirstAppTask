import 'package:first_app/ui/bottom_nav_screens/favorites_screen.dart';
import 'package:first_app/ui/bottom_nav_screens/home_screen.dart';
import 'package:first_app/ui/bottom_nav_screens/profile_screen.dart';
import 'package:first_app/ui/bottom_nav_screens/watchlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({super.key});

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  int _screenIndex = 0;

  var _screens = [
    HomeScreen(),
    WatchlistScreen(),
    FavoritesScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index){
    setState(() {
      _screenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (MediaQuery.of(context).size.width>650)?
          Row(
            children: [
              NavigationRail(destinations:
                  [
                    NavigationRailDestination(icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),),
                    NavigationRailDestination(icon: Icon(Icons.watch_later_outlined),
                      selectedIcon: Icon(Icons.watch_later),
                      label: Text('Watchlist'),),
                    NavigationRailDestination(icon: Icon(Icons.favorite_border_outlined),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Favorites'),),
                    NavigationRailDestination(icon: Icon(Icons.account_box_outlined),
                      selectedIcon: Icon(Icons.account_box),
                      label: Text('Profile'),)
                  ],

                  selectedIndex: _screenIndex,
              onDestinationSelected: _onItemTapped,),
              Expanded(
                child: Builder(builder: (context){
                  return _getScreen(_screenIndex)!;
                }),
              ),
            ],
          ):
          Builder(builder: (context){
            return _getScreen(_screenIndex)!;
          }),

      // IndexedStack(
      //   // It will keep the nav screens alive
      //   children: _screens,
      //   index: _screenIndex,
      // ),
        bottomNavigationBar:(MediaQuery.of(context).size.width>650)?null
        :
        BottomNavigationBar(
          currentIndex: _screenIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.orange.shade100,
          selectedLabelStyle: TextStyle(color: Colors.orange),
          unselectedLabelStyle: TextStyle(color: Colors.white),
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.watch_later_outlined),
              activeIcon: Icon(Icons.watch_later),
              label: 'Watchlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box_outlined),
              activeIcon: Icon(Icons.account_box),
              label: 'Profile',
            ),
          ],
        ),
        );
  }

  Widget? _getScreen(int index){
    switch(index){
      case 0: return HomeScreen();
      case 1 : return WatchlistScreen();
      case 2 : return FavoritesScreen();
      case 3 : ProfileScreen();
    }
  }
}
