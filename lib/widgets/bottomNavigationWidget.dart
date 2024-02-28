// ignore_for_file: deprecated_member_use
import 'package:app/screens/barberShopListScreen.dart';
import 'package:app/screens/favouritesScreen.dart';
import 'package:app/screens/homeScreen.dart';
import 'package:app/screens/locationScreen.dart';
import 'package:app/screens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/businessLayer/global.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
 @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    LocationScreen(),
    BarberShopListScreen(),
    FavouritesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Are you sure?',
              textScaler: TextScaler.linear(kTextScaleFactor),
            ),
            content: Text(
              'Do you want to exit an App',
              textScaler: TextScaler.linear(kTextScaleFactor),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  textScaler: TextScaler.linear(kTextScaleFactor),
                ),
              ),
              MaterialButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  'Yes',
                  textScaler: TextScaler.linear(kTextScaleFactor),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: 'Location',
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded),
              label: 'Salons',
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_outlined),
              label: 'Favorites',
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Account',
              backgroundColor: Colors.transparent,
            ),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  // List<Widget> screens() => [
  //       HomeScreen(a: widget.analytics, o: widget.observer),
  //       LocationScreen(
  //         a: widget.analytics,
  //         o: widget.observer,
  //         screenId: locationIndex,
  //       ),
  //       FavouritesScreen(a: widget.analytics, o: widget.observer),
  //       ProfileScreen(a: widget.analytics, o: widget.observer)
  //     ];
}
