import 'package:app/models/businessLayer/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class ReferAndEarnScreen extends StatefulWidget {
  ReferAndEarnScreen({a, o}) : super();

  @override
  _ReferAndEarnScreenState createState() => new _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool _isDataLoaded = false;
  String? referMessage;
  APIHelper? apiHelper;
  late BusinessRule br;

  _ReferAndEarnScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.lbl_invite_earn),
        ),
        body: _isDataLoaded
            ? referMessage != null
                ? ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.18,
                            ),
                            Text(
                              referMessage!,
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).primaryTextTheme.titleSmall,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .txt_share_your_code_below_and_ask_them_to_enter_it,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Card(
                              child: InkWell(
                                customBorder: Theme.of(context).cardTheme.shape,
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: "${global.user!.referral_code}"));
                                },
                                child: Container(
                                  width: 180,
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${global.user!.referral_code}",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .txt_top_to_copy,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                    AppLocalizations.of(context)!
                        .txt_nothing_is_yet_to_see_here,
                    style: Theme.of(context).primaryTextTheme.titleSmall,
                  ))
            : _shimmer(),
        bottomNavigationBar: global.user!.referral_code != null && _isDataLoaded
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                          onPressed: () {
                            br.inviteFriendShareMessage();
                          },
                          child: Text(AppLocalizations.of(context)!
                              .btn_invite_friends)),
                    ],
                  ),
                ),
              )
            : null,
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

  _getReferandEarn() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getReferandEarn().then((result) {
          if (result != null) {
            if (result.status == "1") {
              referMessage = result.data;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey,context,br);
      }
    } catch (e) {
      print("Exception - referAndEarnScreen.dart - getReferandEarn():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getReferandEarn();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - referAndEarnScreen.dart - _init():" + e.toString());
    }
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
              ),
              SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: Card(),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width - 100,
                child: Card(),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: Card(),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width - 150,
                child: Card(),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width - 200,
                child: Card(),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 180,
                margin: EdgeInsets.all(10),
                height: 50,
                child: Card(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
