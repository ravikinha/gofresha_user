// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/widgets/bottomNavigationWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final int? screenId;
  BookingConfirmationScreen({a, o, this.screenId}) : super();
  @override
  _BookingConfirmationScreenState createState() =>
      new _BookingConfirmationScreenState(this.screenId);
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  int? screenId;
  _BookingConfirmationScreenState(this.screenId) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context)
            .push(
              MaterialPageRoute(builder: (context) => BottomNavigationWidget()),
            )
            .then((value) => value as bool);
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Color(0xFF171D2C),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          height: Platform.isIOS ? 68 : 60,
          padding: EdgeInsets.only(
            left: 100,
            right: 100,
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 8.0, bottom: Platform.isIOS ? 16.0 : 8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => BottomNavigationWidget()),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.lbl_finish),
                ),
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/greatekan3.png'))),
                  width: 200,
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Great' + ' ' + '${global.user!.name}',
                      style: Theme.of(context).primaryTextTheme.caption,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: screenId == 1
                    ? Text(
                        'Your order has been placed successfully, please pick your items from store ASAP',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).primaryTextTheme.subtitle1)
                    : Text(
                        'Your booking has been placed successfully, you will receive a notification/sms about your booking status',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).primaryTextTheme.subtitle1),
              ),
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
