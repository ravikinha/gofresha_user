import 'package:app/models/allBookingsModel.dart';
import 'package:app/models/businessLayer/businessRule.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/cancelReasonModel.dart';
import 'package:app/screens/addRatingScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/businessLayer/apiHelper.dart';
import '../widgets/widgets.dart';

class BookingManagementScreen extends StatefulWidget {
  BookingManagementScreen({a, o}) : super();

  @override
  _BookingManagementScreenState createState() =>
      new _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  APIHelper? apiHelper;
  late BusinessRule br;
  List<CancelReasons>? _cancelReasonsList = [];
  int isPending = -1;
  bool _isDataLoaded = false;
  String? selectedCancelReason;
  List<AllBookings>? _allBookingsList = [];

  _BookingManagementScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.lbl_booking_management),
        ),
        body: _isDataLoaded
            ? (_allBookingsList?.length ?? 0) > 0
                ? ListView.builder(
                    itemCount: _allBookingsList?.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: ExpansionTile(
                          backgroundColor: Colors.transparent,
                          collapsedBackgroundColor: Colors.transparent,
                          initiallyExpanded: false,
                          tilePadding:
                              const EdgeInsets.only(left: 10, right: 10),
                          trailing: Column(
                            children: [
                              Container(
                                height: 40,
                                width: 110,
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: _allBookingsList![index].status == 6
                                      ? Color(0xFF00547B)
                                      : _allBookingsList![index].status == 5
                                          ? Colors.grey
                                          : _allBookingsList![index].status == 4
                                              ? Colors.grey
                                              : _allBookingsList![index]
                                                          .status ==
                                                      3
                                                  ? Color(0xFF00547B)
                                                  : _allBookingsList![index]
                                                              .status ==
                                                          1
                                                      ? Colors.amber
                                                      : Colors.green[600],
                                  borderRadius: new BorderRadius.circular(7.0),
                                ),
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Center(
                                  child: Text(
                                    _allBookingsList![index].status == 6
                                        ? AppLocalizations.of(context)!
                                            .lbl_confirmed
                                        : _allBookingsList![index].status == 5
                                            ? AppLocalizations.of(context)!
                                                .lbl_vendor_cancelled
                                            : _allBookingsList![index].status ==
                                                    4
                                                ? AppLocalizations.of(context)!
                                                    .lbl_cancelled
                                                : _allBookingsList![index]
                                                            .status ==
                                                        3
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .lbl_failed
                                                    : _allBookingsList![index]
                                                                .status ==
                                                            1
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .lbl_pending
                                                        : AppLocalizations.of(
                                                                context)!
                                                            .lbl_completed,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: ListTile(
                            horizontalTitleGap: 10,
                            contentPadding: EdgeInsets.all(5),
                            leading: _allBookingsList![index].vendor_logo !=
                                    null
                                ? CachedNetworkImage(
                                    imageUrl: global.baseUrlForImage +
                                        _allBookingsList![index].vendor_logo!,
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                            radius: 28,
                                            backgroundColor: Colors.yellow,
                                            backgroundImage: imageProvider),
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                : CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.yellow,
                                    child: Icon(Icons.person)),
                            title: Text(
                              '${_allBookingsList![index].vendor_name}',
                              style:
                                  Theme.of(context).primaryTextTheme.titleSmall,
                            ),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_allBookingsList![index].staff_name}',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyMedium,
                                ),
                                Text(
                                  '${_allBookingsList![index].vendor_phone}',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyMedium,
                                ),
                                _allBookingsList![index].vendor_review != null
                                    ? Container(
                                        height: 22,
                                        width: 90,
                                        child: RatingBar.builder(
                                          initialRating:
                                              _allBookingsList![index]
                                                  .vendor_review!
                                                  .rating!,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 12,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          ignoreGestures: true,
                                          updateOnDrag: false,
                                          onRatingUpdate: (rating) {},
                                          tapOnlyMode: true,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          children: [
                            ListTile(
                              tileColor: Colors.grey[200],
                              title: Text(
                                AppLocalizations.of(context)!.lbl_total_price,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall,
                              ),
                              trailing: Text(
                                '${global.currency.currency_sign}${_allBookingsList![index].rem_price}',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall,
                              ),
                            ),
                            ListTile(
                              tileColor: Colors.grey[200],
                              title: Text(
                                AppLocalizations.of(context)!
                                    .lbl_appointment_date,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall,
                              ),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${DateFormat('dd MMM yy').format(DateTime.parse(_allBookingsList![index].service_date!))}',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .displaySmall,
                                  ),
                                  Text(
                                    '${_allBookingsList![index].service_time!.substring(0, 9)}',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .displaySmall,
                                  ),
                                ],
                              ),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  _allBookingsList![index].cart_services.length,
                              itemBuilder: (BuildContext context, int i) {
                                return ListTile(
                                  title: Text(
                                    '${_allBookingsList![index].cart_services[i].varient}',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleSmall,
                                  ),
                                  subtitle: Text(
                                    '${_allBookingsList![index].cart_services[i].service_name}',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 50,
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${global.currency.currency_sign} ${_allBookingsList![index].cart_services[i].price}',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int i) {
                                return Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  color: Colors.grey[300],
                                );
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      _allBookingsList![index].status == 2
                                          ? TextButton(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .lbl_rate),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddRatingScreen(
                                                            _allBookingsList![
                                                                index]),
                                                  ),
                                                );
                                              },
                                            )
                                          : SizedBox(),
                                      _allBookingsList![index].vendor_phone !=
                                              null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: TextButton(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10, left: 10),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .lbl_contact_saloon),
                                                ),
                                                onPressed: () {
                                                  _makingPhoneCall(
                                                      _allBookingsList![index]
                                                          .vendor_phone);
                                                },
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  _allBookingsList![index].status == 1
                                      ? TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.grey[600])),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .lbl_cancel),
                                          onPressed: () {
                                            _selectCancelReasons(
                                                _allBookingsList![index]
                                                    .cart_id,
                                                index);
                                          },
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    })
                : Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .txt_nothing_is_yet_to_see_here,
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                    ),
                  )
            : _shimmer(),
      ),
    );
  }

  @override
  void initState() {
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
    super.initState();
    _init();
  }

  _cancelBooking(String? cartId, String? reason, int index) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog(context);
        await apiHelper!.cancelBooking(cartId, reason).then((result) {
          if (result != null) {
            if (result.status == "1") {
              hideLoader(context);
              _allBookingsList![index].status = 4;
              Navigator.of(context).pop();
              showSnackBar(
                  context: context,
                  key: _scaffoldKey,
                  snackBarMessage: result.message.toString());
              setState(() {});
            } else if (result.status == "0") {
              hideLoader(context);
              Navigator.of(context).pop();
              showSnackBar(
                  context: context,
                  key: _scaffoldKey,
                  snackBarMessage: result.message.toString());
              setState(() {});
            }

            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - bookingManagementScreen.dart - _cancelBooking():" +
          e.toString());
    }
  }

  _getAllBookings() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getAllBookings(global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _allBookingsList = result.recordList;
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - bookingManagementScreen.dart - _getAllBookings():" +
          e.toString());
    }
  }

  _getCancelreasons() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getCancelReasons().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _cancelReasonsList = result.data;
              _isDataLoaded = true;
              setState(() {});
            } else if (result.status == "0") {
              _cancelReasonsList = null;
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - bookingManagementScreen.dart - _getCancelreasons():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getAllBookings();
      await _getCancelreasons();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print(
          "Exception - bookingManagementScreen.dart - _init():" + e.toString());
    }
  }

  _makingPhoneCall(String? number) async {
    try {
      String url = 'tel:' + '$number';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print("Exception - bookingManagementScreen.dart - _makingPhoneCall():" +
          e.toString());
    }
  }

  _selectCancelReasons(String? cartId, int index) {
    try {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(AppLocalizations.of(context)!.lbl_select_reason),
          actions: _cancelReasonsList!
              .map((e) => CupertinoActionSheetAction(
                    child: Text('${e.reason}'),
                    onPressed: () async {
                      setState(() {
                        selectedCancelReason = e.reason;
                      });
                      await _cancelBooking(cartId, selectedCancelReason, index);
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
      print(
          "Exception - bookingManagementScreen.dart - _selectCancelReasons():" +
              e.toString());
    }
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 60,
                        child: Card(margin: EdgeInsets.only(top: 5, bottom: 5)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 220,
                            height: 30,
                            child: Card(
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 5)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            height: 30,
                            child: Card(
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 5)),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              );
            }),
      ),
    );
  }
}
