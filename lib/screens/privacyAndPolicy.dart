import 'package:app/models/privacyPolicyModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class PrivacyAndPolicy extends StatefulWidget {
  PrivacyAndPolicy({a, o}) : super();
  @override
  _PrivacyAndPolicyState createState() => new _PrivacyAndPolicyState();
}

class _PrivacyAndPolicyState extends State<PrivacyAndPolicy> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  PrivacyPolicy? _privacyAndPolicy;
  APIHelper? apiHelper;
  late BusinessRule br;
  bool _isDataLoaded = false;
  _PrivacyAndPolicyState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Privacy And Policy'),
        ),
        body: _isDataLoaded
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: _privacyAndPolicy!.privacy_policy,
                          style: {
                            'body': Style(textAlign: TextAlign.justify),
                          },
                        )),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
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
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
    super.initState();
    _init();
  }

  _getPrivacyPolicy() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.privacyPolicy().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _privacyAndPolicy = result.data;
              _isDataLoaded = true;
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - privacyAndPolicy.dart - _getPrivacyPolicy():" +
          e.toString());
    }
  }

  _init() async {
    await _getPrivacyPolicy();
  }
}
