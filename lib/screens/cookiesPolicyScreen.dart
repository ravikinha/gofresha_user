// ignore_for_file: deprecated_member_use

import 'package:app/models/cookiesPolicyModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class CookiesPolicy extends StatefulWidget {
  CookiesPolicy({a, o}) : super();
  @override
  _CookiesPolicyState createState() => new _CookiesPolicyState();
}

class _CookiesPolicyState extends State<CookiesPolicy> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  Cookies? _cookiesPolicy;
  APIHelper? apiHelper;
  late BusinessRule br;
  bool _isDataLoaded = false;
  _CookiesPolicyState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cookies Policy'),
        ),
        body: _isDataLoaded
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: _cookiesPolicy!.cookies_policy,
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

  _getCookiesPolicy() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.cookiesPolicy().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _cookiesPolicy = result.data;
              _isDataLoaded = true;
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - cookiesPolicyScreen.dart - _getCookiesPolicy():" +
          e.toString());
    }
  }

  _init() async {
    await _getCookiesPolicy();
  }
}
