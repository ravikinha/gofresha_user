import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/userModel.dart';
import 'package:app/provider/local_provider.dart';
import 'package:app/screens/introScreen.dart';
import 'package:app/widgets/bottomNavigationWidget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({a, o}) : super();
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool isloading = true;
  APIHelper? apiHelper;
  late BusinessRule br;
  _SplashScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return exitAppDialog(context).then((value) => value as bool);
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/splash.jpg',
            //   width: double.infinity,
            //   height: double.infinity,
            //   fit: BoxFit.cover,
            //   filterQuality: FilterQuality.high,
            // ),
            // BackdropFilter(
            //   filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            //   child: Container(
            //     width: double.infinity,
            //     height: double.infinity,
            //     color: Colors.black.withOpacity(0.5),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage(
                        'assets/logo_splash.png',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        AppLocalizations.of(context)!.lbl_gofresha,
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 70, left: 10, right: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        children: [
                          TextSpan(
                              text:
                                  AppLocalizations.of(context)!.txt_welcome_to,
                              style: TextStyle(fontFamily: 'Poppins',
                              color: Colors.black)),
                          TextSpan(
                            text: AppLocalizations.of(context)!.lbl_gofresha,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Poppins',
                                fontSize: 18),
                          ),
                          TextSpan(
                              text: AppLocalizations.of(context)!.txt_app,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Poppins'))
                        ])),
              ),
            )
          ],
        ),
      ),
    );
  }

  void init() async {
    try {
      await br.getSharedPreferences();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<LocaleProvider>(context, listen: false);
        if (global.sp.getString("selectedLanguage") == null) {
          var locale = provider.locale ?? Locale('en');
          global.languageCode = locale.languageCode;
        } else {
          global.languageCode = global.sp.getString("selectedLanguage");
          provider.setLocale(Locale(global.languageCode!));
        }
        if (global.rtlLanguageCodeLList.contains(global.languageCode)) {
          global.isRTL = true;
        } else {
          global.isRTL = false;
        }
      });

      // We execute this functions in parallel and store the results into configResults
      final List<dynamic> configResults = await Future.wait([
        _getMapBox(),
        FirebaseMessaging.instance.getToken(),
        _getCurrency(),
        br.checkConnectivity()
      ]);

      global.appDeviceId = configResults[1];
      bool isConnected = configResults[3];

      if (isConnected) {
        if (global.sp.getString('currentUser') != null) {
          global.user = CurrentUser.fromJson(
              json.decode(global.sp.getString("currentUser")!));
          await getCurrentPosition().then((_) async {
            if (global.lat != null && global.lng != null) {
              setState(() {});
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BottomNavigationWidget()));
            } else {
              hideLoader(context);
              showSnackBar(
                  context: context,
                  key: _scaffoldKey,
                  snackBarMessage:
                      'Please enable location permission to use this App');
            }
          });
        } else {
          await getCurrentPosition();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => IntroScreen()));
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - splashScreen.dart - init():" + e.toString());
    }
  }

  @override
  void initState() {
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
    super.initState();
    init();
  }

  _getCurrency() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getCurrency().then((result) {
          if (result != null) {
            if (result.status == "1") {
              global.currency = result.recordList;

              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - splashScreen.dart - _getCurrency(): " + e.toString());
    }
  }

  _getMapBox() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getMapGateway().then((result) {
          if (result != null) {
            if ('${result.status}' == '1') {
              if ('${result.recordList.data.googleMap}' == '1') {
                global.isGoogleMap = true;
                apiHelper!.getGoogleMap().then((valRes) {
                  global.mapGBoxModel = valRes.recordList;
                });
              } else if ('${result.recordList.data.mapbox}' == '1') {
                global.isGoogleMap = false;
                apiHelper!.getMapBox().then((valRes) {
                  global.mapBoxModel = valRes.recordList;
                });
              }
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - splashScreen.dart - _getMapBox():" + e.toString());
    } finally {
      setState(() {});
    }
  }
}
