// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/userModel.dart';
import 'package:app/screens/otpVerificationScreen.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class AddPhoneScreen extends StatefulWidget {
  AddPhoneScreen({a, o}) : super();

  @override
  _AddPhoneScreenState createState() => new _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  TextEditingController _cPhoneNumber = new TextEditingController();
  var _fPhoneNumber = FocusNode();
  GlobalKey<ScaffoldState>? _scaffoldKey;
  APIHelper? apiHelper;
  late BusinessRule br;
  bool showOtpTextBox = false;
  List<SimCard> _simCard = <SimCard>[];
  _AddPhoneScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.txt_connect_with_phone,
                  style: Theme.of(context).primaryTextTheme.caption,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                      AppLocalizations.of(context)!
                          .txt_you_will_receive_otp_on_this_number,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.headline3),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    autofocus: false,
                    cursorColor: Color(0xFF00547B),
                    enabled: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).primaryTextTheme.headline6,
                    controller: _cPhoneNumber,
                    focusNode: _fPhoneNumber,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.lbl_phone_number,
                      counterText: '',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: MaterialButton(
                      color: Color(0xFF00547B),
                      onPressed: () {
                        _loginWithPhone();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.btn_send_otp,
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> initMobileNumberState() async {
    String mobileNumber = '';
    try {
      _simCard = (await MobileNumber.getSimCards!);
      _simCard.removeWhere((e) =>
          e.number == '' ||
          e.number == null ||
          e.number!.contains(RegExp(r'[A-Z]')));
      if (_simCard.length > 1) {
        await _selectPhoneNumber();
      } else if (_simCard.length > 0) {
        mobileNumber =
            _simCard[0].number!.substring(_simCard[0].number!.length - 10);
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    if (!mounted) return;

    setState(() {
      _cPhoneNumber.text = mobileNumber;
    });
  }

  @override
  void initState() {
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
    super.initState();
    _init();
  }

  _init() async {
    try {
      PermissionStatus permissionStatus = await Permission.phone.status;
      if (Platform.isAndroid && permissionStatus.isGranted) {
        await initMobileNumberState();
      }
    } catch (e) {
      print("Exception - addPhoneScreen.dart - _init():" + e.toString());
    }
  }

  _loginWithPhone() async {
    try {
      CurrentUser _tUser = new CurrentUser();
      print(_cPhoneNumber.text.trim());
      print(global.appDeviceId);
      _tUser.user_phone = _cPhoneNumber.text.trim();
      _tUser.device_id = global.appDeviceId;

      if (_cPhoneNumber.text.isNotEmpty &&
          _cPhoneNumber.text.trim().length == 10) {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog(context);
          await apiHelper!.loginWithPhone(_tUser).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                await _sendOTP(_cPhoneNumber.text.trim());
              } else {
                hideLoader(context);
                showSnackBar(
                    context: context,
                    key: _scaffoldKey,
                    snackBarMessage: '${result.message}');
              }
            }
          });

          setState(() {});
        } else {
          showNetworkErrorSnackBar(_scaffoldKey, context, br);
        }
      } else if (_cPhoneNumber.text.isEmpty ||
          _cPhoneNumber.text.trim().length < 10) {
        showSnackBar(
            context: context,
            key: _scaffoldKey,
            snackBarMessage: AppLocalizations.of(context)!
                .txt_please_enter_valid_contact_no);
      }
    } catch (e) {
      print("Exception - addPhoneScreen.dart - _loginWithPhone():" +
          e.toString());
    }
  }

  _selectPhoneNumber() {
    try {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(AppLocalizations.of(context)!.txt_select_phonenumber),
          actions: _simCard
              .map((e) => CupertinoActionSheetAction(
                    child:
                        Text('${e.number!.substring(e.number!.length - 10)}'),
                    onPressed: () async {
                      setState(() {
                        _cPhoneNumber.text =
                            e.number!.substring(e.number!.length - 10);
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.lbl_cancel),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      print("Exception - addPhoneScreen.dart - _showCupertinoModalSheet():" +
          e.toString());
    }
  }

  _sendOTP(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print(e.toString());
          hideLoader(context);
          showSnackBar(
              context: context,
              key: _scaffoldKey,
              snackBarMessage: AppLocalizations.of(context)!
                  .txt_please_try_again_after_sometime);
        },
        codeSent: (String verificationId, int? resendToken) async {
          hideLoader(context);
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => OTPVerificationScreen(
                      screenId: 1,
                      verificationId: verificationId,
                      phoneNumberOrEmail: phoneNumber,
                    )),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Exception - addPhoneScreen.dart - _sendOTP():" + e.toString());
    }
  }
}
