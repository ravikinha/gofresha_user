import 'package:app/models/couponsModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class PricingAndOffers extends StatefulWidget {
  PricingAndOffers({a, o}) : super();

  @override
  _PricingAndOffersState createState() => new _PricingAndOffersState();
}

class _PricingAndOffersState extends State<PricingAndOffers> {
  GlobalKey<ScaffoldState>? _scaffoldKey;

  List<Coupons>? _nearByCouponsList = [];
  bool _isDataLoaded = false;
  APIHelper? apiHelper;
  late BusinessRule br;

  _PricingAndOffersState() : super();

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.lbl_pricing_offers),
          ),
          body: _isDataLoaded
              ? _nearByCouponsList!.length > 0
                  ? ListView.builder(
                      physics: ClampingScrollPhysics(),
                      itemCount: _nearByCouponsList!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 13, right: 13),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () {},
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Card(
                                              child: _nearByCouponsList![index]
                                                          .vendor_logo !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      imageUrl: global
                                                              .baseUrlForImage +
                                                          _nearByCouponsList![
                                                                  index]
                                                              .vendor_logo!,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        height: 70,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image:
                                                                    imageProvider)),
                                                      ),
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    )
                                                  : Container(
                                                      height: 70,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                'assets/s1.jpg',
                                                              ))),
                                                    ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: global.isRTL
                                                    ? EdgeInsets.only(
                                                        right: 18.0)
                                                    : EdgeInsets.only(left: 18),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      '${_nearByCouponsList![index].coupon_name}',
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .titleSmall,
                                                    ),
                                                    Text(
                                                      '${_nearByCouponsList![index].amount}OFF',
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .titleMedium,
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: global.isRTL
                                                  ? EdgeInsets.only(left: 8.0)
                                                  : EdgeInsets.only(right: 8.0),
                                              child: SizedBox(
                                                height: 40,
                                                child: FDottedLine(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  dottedLength: 4,
                                                  space: 2,
                                                  corner:
                                                      FDottedLineCorner.all(5),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Text(
                                                      '${_nearByCouponsList![index].coupon_code}',
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .titleSmall,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Text(
                                            '${_nearByCouponsList![index].coupon_description}',
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .titleMedium,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Text(
                                            'Validity : ${DateFormat('dd MMM yy').format(_nearByCouponsList![index].start_date!)} - ${DateFormat('dd MMM yy').format(_nearByCouponsList![index].end_date!)}',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    global.isRTL
                                        ? Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  8, 2, 8, 2),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColorLight
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Text(
                                                '${_nearByCouponsList![index].vendor_name}',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF898A8D),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          )
                                        : Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  8, 2, 8, 2),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColorLight
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10))),
                                              child: Text(
                                                '${_nearByCouponsList![index].vendor_name}',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF898A8D),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
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
              : _shimmer()),
    );
  }

  _init() async {
    try {
      await _getNearByCouponsList();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print(
          "Exception - pricingAndOffersScreen.dart - _init():" + e.toString());
    }
  }

  _getNearByCouponsList() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!
            .getNearByCouponsList(global.lat, global.lng)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              _nearByCouponsList = result.recordList;
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
          "Exception - pricingAndOffersScreen.dart - _getNearByCouponsList():" +
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
                        width: 80,
                        height: 80,
                        child: Card(margin: EdgeInsets.only(top: 5, bottom: 5)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 220,
                            height: 40,
                            child: Card(
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 5)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            height: 40,
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
