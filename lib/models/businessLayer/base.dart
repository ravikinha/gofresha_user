// import 'dart:core';
// import 'dart:io';

// import 'package:app/models/businessLayer/apiHelper.dart';
// import 'package:app/models/businessLayer/businessRule.dart';
// import 'package:app/models/businessLayer/global.dart' as global;
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class Base extends StatefulWidget {
//   final FirebaseAnalytics? analytics;
//   final FirebaseAnalyticsObserver? observer;
//   final String? routeName;

//   Base({this.analytics, this.observer, this.routeName});

//   @override
//   BaseState createState() => BaseState();
// }

// class BaseState extends State<Base>
//     with TickerProviderStateMixin, WidgetsBindingObserver {
//   bool bannerAdLoaded = false;
//   late Position _currentPosition;

//   APIHelper? apiHelper;
//   late BusinessRule br;

//   BaseState() {
//     apiHelper = new APIHelper();
//     br = new BusinessRule(apiHelper);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.shrink();
//   }

//   void closeDialog() {
//     Navigator.of(context).pop();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     super.didChangeAppLifecycleState(state);
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future<bool> dontCloseDialog() async {
//     return false;
//   }

//   Future exitAppDialog() async {
//     try {
//       showCupertinoDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return Theme(
//               data: ThemeData(dialogBackgroundColor: Colors.white),
//               child: CupertinoAlertDialog(
//                 title: Text(
//                   "Exit app",
//                 ),
//                 content: Text(
//                   "Are you sure you want to exit app?",
//                 ),
//                 actions: <Widget>[
//                   CupertinoDialogAction(
//                     child: Text(
//                       'Cancel',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                     onPressed: () {
//                       // Dismiss the dialog but don't
//                       // dismiss the swiped item
//                       return Navigator.of(context).pop(false);
//                     },
//                   ),
//                   CupertinoDialogAction(
//                     child: Text("Exit"),
//                     onPressed: () async {
//                       exit(0);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           });
//     } catch (e) {
//       print('Exception - base.dart - exitAppDialog(): ' + e.toString());
//     }
//   }

//   getAddressFromLatLng() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition.latitude, _currentPosition.longitude);

//       Placemark place = placemarks[0];

//       setState(() {
//         global.currentLocation = "${place.name}, ${place.locality} ";
//       });
//     } catch (e) {
//       print("Exception -  base.dart - getAddressFromLatLng():" + e.toString());
//     }
//   }

//   getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.best);

//       global.lat = position.latitude.toString();
//       global.lng = position.longitude.toString();
//       _currentPosition = position;
//       await getAddressFromLatLng();
//       setState(() {});
//     } catch (e) {
//       print("Exception -  base.dart - getCurrentLocation():" + e.toString());
//     }
//   }

//   getCurrentPosition() async {
//     try {
//       if (Platform.isIOS) {
//         LocationPermission s = await Geolocator.checkPermission();
//         if (s == LocationPermission.denied ||
//             s == LocationPermission.deniedForever) {
//           s = await Geolocator.requestPermission();
//         }
//         if (s != LocationPermission.denied ||
//             s != LocationPermission.deniedForever) {
//           await getCurrentLocation();
//         }
//       } else {
//         PermissionStatus permissionStatus = await Permission.location.status;
//         if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
//           permissionStatus = await Permission.location.request();
//         }
//         if (permissionStatus.isGranted) {
//           await getCurrentLocation();
//         }
//       }
//     } catch (e) {
//       print("Exception -  base.dart - getCurrentPosition():" + e.toString());
//     }
//   }

//   void hideLoader() {
//     Navigator.pop(context);
//   }

//   @override
//   void initState() async {
//     super.initState();
//   }

//   Widget sc(Widget body) {
//     return SafeArea(child: body);
//   }

//   @override
//   void setState(fn) {
//     if (mounted) {
//       super.setState(fn);
//     }
//   }

//   showNetworkErrorSnackBar(GlobalKey<ScaffoldState>? scaffoldKey) {
//     try {
//       bool isConnected;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         duration: Duration(days: 1),
//         content: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Icon(
//               Icons.signal_wifi_off,
//               color: Colors.white,
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                   left: 16.0,
//                 ),
//                 child: Text(
//                   'No internet available',
//                   textAlign: TextAlign.start,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         action: SnackBarAction(
//             textColor: Colors.white,
//             label: 'RETRY',
//             onPressed: () async {
//               isConnected = await br.checkConnectivity();
//               if (isConnected) {
//                 ScaffoldMessenger.of(context).removeCurrentSnackBar();
//               } else {
//                 showNetworkErrorSnackBar(scaffoldKey);
//               }
//             }),
//         backgroundColor: Colors.grey,
//       ));
//     } catch (e) {
//       print("Exception -  base.dart - showNetworkErrorSnackBar():" +
//           e.toString());
//     }
//   }

//   showOnlyLoaderDialog() {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Center(child: new CircularProgressIndicator()),
//         );
//       },
//     );
//   }

//   void showSnackBar({required String snackBarMessage, Key? key}) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       key: key,
//       content: Text(
//         snackBarMessage,
//         textAlign: TextAlign.center,
//       ),
//       duration: Duration(seconds: 2),
//     ));
//   }
// }
