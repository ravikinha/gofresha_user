// ignore_for_file: deprecated_member_use

import 'package:app/widgets/bottomNavigationWidget.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class ExploreScreen extends StatefulWidget {
  ExploreScreen({a, o}) : super();
  @override
  _ExploreScreenState createState() => new _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  _ExploreScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return exitAppDialog(context).then((value) => value as bool);
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/exploreImg.png',
                height: 300,
                width: double.infinity,
              ),
              Text(
                'You are ready to go!',
                style: Theme.of(context).primaryTextTheme.caption,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                    'Thanks for taking your time to create an account with us. Now this is the fun part, let\'s experience this app.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.headline3),
              ),
              Container(
                  height: 50,
                  width: 250,
                  margin: EdgeInsets.only(top: 40),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => BottomNavigationWidget()),
                        );
                      },
                      child: Text('Let\'s explore'))),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
