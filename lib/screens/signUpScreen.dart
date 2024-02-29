// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/screens/otpVerificationScreen.dart';
import 'package:app/screens/signInScreen.dart';
import 'package:app/screens/termsOfServicesScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  final String? appleId;
  final String? email;
  final String? fbId;
  final String? name;
  SignUpScreen({a, o, this.email, this.fbId, this.name, this.appleId})
      : super();
  @override
  _SignUpScreenState createState() => new _SignUpScreenState(
      email: email, fbId: fbId, name: name, appleId: appleId);
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? appleId;
  String? email;
  String? fbId;
  String? name;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  final key = GlobalKey<FormState>();
  TextEditingController _cName = new TextEditingController();
  TextEditingController _cEmail = new TextEditingController();
  TextEditingController _cMobile = new TextEditingController();
  TextEditingController _cPassword = new TextEditingController();
  TextEditingController _cConfirmPassword = new TextEditingController();
  TextEditingController _cReferralCode = new TextEditingController();
  FocusNode _fReferralCode = new FocusNode();
  FocusNode _fName = new FocusNode();
  FocusNode _fEmail = new FocusNode();
  FocusNode _fMobile = new FocusNode();
  FocusNode _fPassword = new FocusNode();
  FocusNode _fConfirmPassword = new FocusNode();
  bool _isAgree = false;
  File? _tImage;
  bool _isPasswordVisible = false;
  final int _phoneNumberLength = 10;
  APIHelper? apiHelper;
  late BusinessRule br;

  bool _isConfirmPasswordVisible = false;
  _SignUpScreenState({this.email, this.fbId, this.name, this.appleId})
      : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 4.5.w, right: 4.5.w, top: 1.5.h),
            child: Form(
                key: key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 10.0.w,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.lbl_warm_welcome,
                              style:
                                  Theme.of(context).primaryTextTheme.headline4,
                            ),
                            Text(
                              AppLocalizations.of(context)!.txt_sign_up_to_join,
                              style:
                                  Theme.of(context).primaryTextTheme.headline3,
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            _tImage != null
                                ? CircleAvatar(
                                    radius: 32,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(32),
                                        child: Image.file(_tImage!)),
                                  )
                                : global.user!.image != null
                                    ? CachedNetworkImage(
                                        imageUrl: global.baseUrlForImage +
                                            global.user!.image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 32,
                                          backgroundImage: imageProvider,
                                        ),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )
                                    : CircleAvatar(
                                        radius: 24,
                                        child: Icon(Icons.person),
                                        backgroundColor: Colors.white,
                                      ),
                            CircleAvatar(
                              radius: 32,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: _tImage == null
                                      ? CircleAvatar(
                                          radius: 30,
                                          child: Icon(Icons.person),
                                          backgroundColor: Colors.white,
                                        )
                                      : Image.file(_tImage!)),
                            ),
                            Positioned(
                                top: 30,
                                left: 30,
                                child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      _showCupertinoModalSheet();
                                    },
                                    icon: Container(
                                        padding: EdgeInsets.all(0),
                                        margin: EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                            color: Color(0xFF00547B),
                                            borderRadius:
                                                BorderRadius.circular(34)),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
                                        ))))
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                      textAlign: TextAlign.start,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name Required';
                        } else {
                          return null;
                        }
                      },
                      autofocus: false,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))
                      ],
                      textCapitalization: TextCapitalization.words,
                      cursorColor: Color(0xFF00547B),
                      enabled: true,
                      style: Theme.of(context).primaryTextTheme.headline6,
                      controller: _cName,
                      focusNode: _fName,
                      onEditingComplete: () {
                        _fEmail.requestFocus();
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.lbl_name),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email Address Required';
                        } else if (!EmailValidator.validate(_cEmail.text)) {
                          return 'Enter Vaid Email Address';
                        } else {
                          return null;
                        }
                      },
                      cursorColor: Color(0xFF00547B),
                      enabled: true,
                      readOnly: email != null ? true : false,
                      keyboardType: TextInputType.emailAddress,
                      style: Theme.of(context).primaryTextTheme.headline6,
                      controller: _cEmail,
                      focusNode: _fEmail,
                      decoration: InputDecoration(
                          hintText: email != null
                              ? email
                              : AppLocalizations.of(context)!.lbl_email),
                      onEditingComplete: () {
                        _fMobile.requestFocus();
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Phone Number Required';
                        } else {
                          return null;
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(_phoneNumberLength),
                      ],
                      keyboardType: TextInputType.number,
                      cursorColor: Color(0xFF00547B),
                      enabled: true,
                      style: Theme.of(context).primaryTextTheme.headline6,
                      controller: _cMobile,
                      focusNode: _fMobile,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.lbl_mobile),
                      onEditingComplete: () {
                        _fPassword.requestFocus();
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: Color(0xFF00547B),
                      enabled: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password Required';
                        } else if (value.length < 8) {
                          return 'Password must be 8 character long';
                        } else {
                          return null;
                        }
                      },
                      obscureText: !_isPasswordVisible,
                      style: Theme.of(context).primaryTextTheme.headline6,
                      controller: _cPassword,
                      focusNode: _fPassword,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: IconTheme.of(context).color),
                            onPressed: () {
                              _isPasswordVisible = !_isPasswordVisible;
                              setState(() {});
                            },
                          ),
                          hintText: AppLocalizations.of(context)!.hnt_password),
                      onEditingComplete: () {
                        _fConfirmPassword.requestFocus();
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      obscureText: !_isConfirmPasswordVisible,
                      cursorColor: Color(0xFF00547B),
                      enabled: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Confirm Password Required';
                        } else if (value != _cPassword.text) {
                          return 'Password Not Matched';
                        } else {
                          return null;
                        }
                      },
                      style: Theme.of(context).primaryTextTheme.headline6,
                      controller: _cConfirmPassword,
                      focusNode: _fConfirmPassword,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: IconTheme.of(context).color),
                            onPressed: () {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                              setState(() {});
                            },
                          ),
                          hintText: AppLocalizations.of(context)!
                              .lbl_confirm_password),
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_fReferralCode);
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      validator: (value) {
                        return null;
                      },
                      cursorColor: Color(0xFF00547B),
                      enabled: true,
                      style: Theme.of(context).primaryTextTheme.headline6,
                      controller: _cReferralCode,
                      focusNode: _fReferralCode,
                      decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.lbl_referral_code),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: GestureDetector(
                          onTap: () {
                            _isAgree = !_isAgree;
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: _isAgree
                                    ? Color(0xFF00547B)
                                    : Color(0xFF898A8D),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Wrap(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .txt_i_agree_to_the,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1,
                                      ),
                                      InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TermsOfServices()),
                                            );
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .txt_term_of_services,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .subtitle2))
                                    ],
                                  ))
                            ],
                          )),
                    ),
                    SizedBox(height: 10.0),
                    MaterialButton(
                      height: 50,
                      minWidth: double.infinity,
                      color: Color(0xFF00547B),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (key.currentState!.validate()) {
                          _signUp();
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.btn_sign_up,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )),
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      AppLocalizations.of(context)!
                          .txt_you_already_have_account,
                      style: Theme.of(context).primaryTextTheme.subtitle1),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.lbl_sign_in,
                          style: Theme.of(context).primaryTextTheme.headline5))
                ],
              )),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
    super.initState();
    _fillData();
  }

  _fillData() {
    _cEmail.text = email != null ? email! : '';
    _cName.text = name != null ? name! : '';
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
                      verificationId: verificationId,
                      phoneNumberOrEmail: phoneNumber,
                    )),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Exception - signUpScreen.dart - _sendOTP():" + e.toString());
    }
  }

  _showCupertinoModalSheet() {
    try {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(AppLocalizations.of(context)!.lbl_actions),
          actions: [
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.lbl_take_picture,
                  style: TextStyle(color: Color(0xFF171D2C))),
              onPressed: () async {
                Navigator.pop(context);
                // Navigator.pop(context);
                // showOnlyLoaderDialog(context);
                File? file = await br.openCamera();
                setState(() {
                  _tImage = file;
                });
                // hideLoader(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.lbl_choose_from_library,
                  style: TextStyle(color: Color(0xFF171D2C))),
              onPressed: () async {
                Navigator.pop(context);
                // showOnlyLoaderDialog(context);
                File? file = await br.selectImageFromGallery();
                setState(() {
                  _tImage = file;
                });
                // hideLoader(context);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.lbl_cancel,
                style: TextStyle(color: Color(0xFF00547B))),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      print("Exception - signUpScreen.dart - _showCupertinoModalSheet():" +
          e.toString());
    }
  }

  _signUp() async {
    if (_isAgree) {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog(context);
        var getData = await apiHelper!.signUp(
            deviceID: global.appDeviceId!,
            userName: _cName.text.trim(),
            email: _cEmail.text.trim(),
            password: _cPassword.text.trim(),
            phoneNumber: _cMobile.text.trim());
        if (getData['status'] == true) {
          await _sendOTP(_cMobile.text.trim());
        } else {
          hideLoader(context);
          showSnackBar(
              context: context,
              key: _scaffoldKey,
              snackBarMessage: getData['message'].toString());
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } else {
      showSnackBar(
          context: context,
          key: _scaffoldKey,
          snackBarMessage: AppLocalizations.of(context)!
              .txt_please_agree_term_condition_to_complete_your_registeration);
    }
  }
}
