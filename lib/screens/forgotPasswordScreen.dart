import 'package:app/screens/otpVerificationScreen.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({a, o}) : super();
  @override
  _ForgotPasswordScreenState createState() => new _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  APIHelper? apiHelper;
  late BusinessRule br;
  TextEditingController _cEmail = new TextEditingController();
  FocusNode _fEmail = new FocusNode();
  _ForgotPasswordScreenState() : super();

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
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.txt_forgot_password,
                      style: Theme.of(context).primaryTextTheme.caption),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                        AppLocalizations.of(context)!
                            .txt_please_enter_your_email_so_we_can_help_you_to_recover_your_password,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).primaryTextTheme.headline3),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 70),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        autofocus: false,
                        cursorColor: Colors.blue,
                        enabled: true,
                        style: Theme.of(context).primaryTextTheme.headline6,
                        controller: _cEmail,
                        focusNode: _fEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.lbl_email),
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                      )),
                  Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 20),
                      child: TextButton(
                          onPressed: () {
                            _forgotPassword();
                          },
                          child: Text(AppLocalizations.of(context)!.btn_send))),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
    super.initState();
  }

  _forgotPassword() async {
    try {
      if (_cEmail.text.isNotEmpty) {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog(context);
          await apiHelper!.forgotPassword(_cEmail.text.trim()).then((result) {
            if (result != null) {
              if (result.status == "1") {
                hideLoader(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => OTPVerificationScreen(
                            screenId: 2,
                            phoneNumberOrEmail: _cEmail.text.trim(),
                          )),
                );

                setState(() {});
              } else {
                hideLoader(context);
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
      } else if (_cEmail.text.isEmpty) {
        showSnackBar(
            context: context,
            key: _scaffoldKey,
            snackBarMessage:
                AppLocalizations.of(context)!.txt_please_enter_your_email);
      } else if (_cEmail.text.isNotEmpty &&
          !EmailValidator.validate(_cEmail.text)) {
        showSnackBar(
            context: context,
            key: _scaffoldKey,
            snackBarMessage: AppLocalizations.of(context)!
                .txt_please_enter_your_valid_email);
      }
    } catch (e) {
      print("Exception - forgotPasswordScreen.dart - _forgotPassword():" +
          e.toString());
    }
  }
}
