import 'dart:convert';
import 'dart:io';

import 'package:app/models/businessLayer/apiHelper.dart';
import 'package:app/models/businessLayer/businessRule.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/bottomNavigationWidget.dart';
import '../widgets/widgets.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  TextEditingController _cName = new TextEditingController();
  TextEditingController _cEmail = new TextEditingController();
  TextEditingController _cMobile = new TextEditingController();
  TextEditingController _cPassword = new TextEditingController();
  TextEditingController _cConfirmPassword = new TextEditingController();
  FocusNode _fName = new FocusNode();
  FocusNode _fEmail = new FocusNode();
  FocusNode _fMobile = new FocusNode();
  FocusNode _fPasword = new FocusNode();
  FocusNode _fConfirmPassword = new FocusNode();
  File? _tImage;
  late BusinessRule br;
  late APIHelper apiHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.lbl_account_settings),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.height * 0.19,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _tImage != null
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.17,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.17,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).cardTheme.color,
                                        borderRadius: new BorderRadius.all(
                                          new Radius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17),
                                        ),
                                        image: DecorationImage(
                                            image: FileImage(_tImage!),
                                            fit: BoxFit.cover),
                                        border: new Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 3.0,
                                        ),
                                      ),
                                    )
                                  : global.user!.image != ''
                                      ? CachedNetworkImage(
                                          imageUrl: global.baseUrlForImage +
                                              global.user!.image!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.17,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.17,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .cardTheme
                                                  .color,
                                              borderRadius:
                                                  new BorderRadius.all(
                                                new Radius.circular(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.17),
                                              ),
                                              image: DecorationImage(
                                                  image: imageProvider),
                                              border: new Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 3.0,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                                      : Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.17,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.17,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .cardTheme
                                                .color,
                                            borderRadius: new BorderRadius.all(
                                              new Radius.circular(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.17),
                                            ),
                                            border: new Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 3.0,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            size: 50,
                                          ),
                                        ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                          Positioned(
                              top: 86,
                              right: 15,
                              child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    _showCupertinoModalSheet();
                                    setState(() {});
                                  },
                                  icon: Container(
                                      padding: EdgeInsets.all(0),
                                      margin: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(34)),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 30,
                                      ))))
                        ],
                      ),
                    ),
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${global.user!.name}',
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                    ),
                  )),
                  Align(
                      alignment: global.isRTL
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          AppLocalizations.of(context)!.lbl_name,
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                      height: 50,
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        autofocus: false,
                        cursorColor: Colors.blue,
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                        controller: _cName,
                        focusNode: _fName,
                        onEditingComplete: () {
                          _fPasword.requestFocus();
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Fahim Khan'),
                      )),
                  Align(
                      alignment: global.isRTL
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          AppLocalizations.of(context)!.lbl_email,
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                      height: 50,
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        autofocus: false,
                        cursorColor: Colors.blue,
                        enabled: true,
                        readOnly: true,
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                        controller: _cEmail,
                        focusNode: _fEmail,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: AppLocalizations.of(context)!.hnt_email),
                      )),
                  Align(
                      alignment: global.isRTL
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          AppLocalizations.of(context)!.lbl_mobile,
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                      height: 50,
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        autofocus: false,
                        cursorColor: Colors.blue,
                        enabled: true,
                        readOnly: true,
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                        controller: _cMobile,
                        focusNode: _fMobile,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            hintText: AppLocalizations.of(context)!.hnt_phone),
                      )),
                  Align(
                      alignment: global.isRTL
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          AppLocalizations.of(context)!.lbl_change_password,
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                      height: 50,
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        autofocus: false,
                        cursorColor: Colors.blue,
                        enabled: true,
                        obscureText: true,
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                        controller: _cPassword,
                        focusNode: _fPasword,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            hintText:
                                AppLocalizations.of(context)!.hnt_password),
                        onEditingComplete: () {
                          _fConfirmPassword.requestFocus();
                        },
                      )),
                  Align(
                      alignment: global.isRTL
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          AppLocalizations.of(context)!.lbl_confirm_password,
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                      height: 50,
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        autofocus: false,
                        cursorColor: Colors.blue,
                        enabled: true,
                        obscureText: true,
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                        controller: _cConfirmPassword,
                        focusNode: _fConfirmPassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: AppLocalizations.of(context)!
                              .lbl_confirm_password,
                        ),
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                      )),
                ],
              ),
            ),
          ),
          MaterialButton(
              minWidth: 90.0.w,
              height: 45.0,
              color: Colors.blue,
              child: Text(
                (AppLocalizations.of(context)!.btn_save),
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _save();
              }),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
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
    _init();
  }

  _init() {
    try {
      _cName.text = global.user!.name!;
      _cEmail.text = global.user!.email!;
      _cMobile.text = global.user!.user_phone!;
      setState(() {});
    } catch (e) {
      print("Exception - accountSettingScreen.dart - _init():" + e.toString());
    }
  }

  _save() async {
    try {
      FocusScope.of(context).unfocus();
      global.user!.user_name = _cName.text;
      global.user!.user_password =
          _cPassword.text.isEmpty ? null : _cPassword.text;
      if (_cPassword.text.isNotEmpty &&
          _cPassword.text.trim().length >= 8 &&
          _cConfirmPassword.text.isNotEmpty &&
          _cPassword.text.trim() == _cConfirmPassword.text.trim()) {
      } else if (_cPassword.text.isNotEmpty &&
          _cPassword.text.trim().length < 8) {
        showSnackBar(
            context: context,
            key: _scaffoldKey,
            snackBarMessage: AppLocalizations.of(context)!
                .txt_password_should_be_of_minimum_8_character);
      } else if (_cConfirmPassword.text.isNotEmpty &&
          _cConfirmPassword.text.trim() != _cPassword.text.trim()) {
        showSnackBar(
            context: context,
            key: _scaffoldKey,
            snackBarMessage:
                AppLocalizations.of(context)!.txt_password_do_not_match);
      }

      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog(context);
        await apiHelper
            .updateProfile(
          global.user!.id,
          global.user!.user_name,
          _tImage,
          user_password: global.user!.user_password,
        )
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              hideLoader(context);
              setState(() {
                global.user = result.data;
                global.sp.setString(
                    'currentUser', json.encode(global.user!.toJson()));
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => BottomNavigationWidget()),
                );
              });
            } else {
              showSnackBar(
                  context: context,
                  key: _scaffoldKey,
                  snackBarMessage: '${result.message}');
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - accountSettingScreen.dart - _save():" + e.toString());
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
                // Navigator.pop(context);
                // showOnlyLoaderDialog(context);
                Navigator.pop(context);
                File? file = await br.openCamera();
                setState(() {
                  _tImage = file;
                });
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
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.lbl_cancel,
                style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      print(
          "Exception - accountSettingScreen.dart - _showCupertinoModalSheet():" +
              e.toString());
    }
  }
}
