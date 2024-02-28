// ignore_for_file: deprecated_member_use

import 'package:app/models/termsAndConditionModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class TermsOfServices extends StatefulWidget {
  TermsOfServices({a, o}) : super();

  @override
  _TermsOfServicesState createState() => new _TermsOfServicesState();
}

class _TermsOfServicesState extends State<TermsOfServices> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  TermsAndCondition? _termsAndCondition;
  bool _isDataLoaded = false;
  APIHelper? apiHelper;
  late BusinessRule br;

  _TermsOfServicesState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.lbl_terms_of_service),
        ),
        body: _isDataLoaded
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: _termsAndCondition!.termcondition,
                          style: {
                            'body': Style(textAlign: TextAlign.justify),
                          },
                        )),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()),
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

  _getTermsAndCondition() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getTermsAndCondition().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _termsAndCondition = result.data;
              _isDataLoaded = true;
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print(
          "Exception - termsOfServicesScreen.dart - _getTermsAndCondition():" +
              e.toString());
    }
  }

  _init() async {
    try {
      await _getTermsAndCondition();
    } catch (e) {
      print("Exception - termsOfServicesScreen.dart - _init():" + e.toString());
    }
  }
}
