import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/notificationModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({a, o}) : super();
  @override
  _NotificationScreenState createState() => new _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool _isDataLoaded = false;
  List<NotificationList>? _notificationList = [];
  APIHelper? apiHelper;
  late BusinessRule br;
  _NotificationScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            actions: [
              _notificationList != null && _notificationList!.length > 0
                  ? IconButton(
                      onPressed: () {
                        _delConfirmationDialog();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.delete,
                      ),
                    )
                  : SizedBox()
            ],
            title: Text(
              AppLocalizations.of(context)!.lbl_notification,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          body: _isDataLoaded
              ? _notificationList != null && _notificationList!.length > 0
                  ? ListView.builder(
                      itemCount: _notificationList!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Card(
                              elevation: 5,
                              child: ExpansionTile(
                                children: [
                                  Text(
                                    '${_notificationList![index].noti_message}',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleMedium,
                                  ),
                                ],
                                childrenPadding: EdgeInsets.all(15),
                                leading: _notificationList![index].image != ''
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            _notificationList![index].image!,
                                        imageBuilder: (context,
                                                imageProvider) =>
                                            CircleAvatar(
                                                radius: 30,
                                                backgroundImage: imageProvider),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )
                                    : CircleAvatar(
                                        radius: 30,
                                        child: Icon(Icons.notifications),
                                      ),
                                title: Text(
                                  '${_notificationList![index].noti_title}',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .titleSmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .txt_nothing_is_yet_to_see_here,
                        style: Theme.of(context).primaryTextTheme.titleSmall,
                      ),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _delConfirmationDialog() async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.lbl_delete_notification,
                ),
                content: Text(AppLocalizations.of(context)!
                    .txt_are_you_sure_you_want_to_delete_all_notification),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      AppLocalizations.of(context)!.lbl_no,
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      // Dismiss the dialog but don't
                      // dismiss the swiped item
                      return Navigator.of(context).pop(false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context)!.lbl_yes),
                    onPressed: () async {
                      showOnlyLoaderDialog(context);
                      bool _isSuccess = await _deleteAllNotifications();
                      if (_isSuccess) {
                        _notificationList!.clear();
                      }
                      hideLoader(context);
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print('Exception - notificationScreen.dart - _delConfirmationDialog(): ' +
          e.toString());
    }
  }

  Future<bool> _deleteAllNotifications() async {
    bool _isdeletedSuccessfully = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.deleteAllNotifications(global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _isdeletedSuccessfully = true;
              showSnackBar(
                  context: context,
                  key: _scaffoldKey,
                  snackBarMessage: "${result.message.toString()}");
            } else if (result.status == "0") {
              showSnackBar(
                  context: context,
                  key: _scaffoldKey,
                  snackBarMessage: "${result.message.toString()}");
            }
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
      return _isdeletedSuccessfully;
    } catch (e) {
      print("Exception - notificationScreen.dart - _deleteAllNotifications():" +
          e.toString());
      return _isdeletedSuccessfully;
    }
  }

  _getNotifications() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getNotifications(global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _notificationList = result.recordList;
              _isDataLoaded = true;

              setState(() {});
            } else if (result.status == "0") {
              _isDataLoaded = true;
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - notificationScreen.dart - _getNotifications():" +
          e.toString());
    }
  }

  _init() async {
    await _getNotifications();
  }
}
