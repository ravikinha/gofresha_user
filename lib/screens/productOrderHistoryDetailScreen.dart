import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/productOrderHistoryModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class ProductOrderHistoryDetailScreen extends StatefulWidget {
  final ProductOrderHistory productOrderHistory;
  ProductOrderHistoryDetailScreen(this.productOrderHistory, {a, o}) : super();
  @override
  _ProductOrderHistoryDetailScreenState createState() =>
      new _ProductOrderHistoryDetailScreenState(this.productOrderHistory);
}

class _ProductOrderHistoryDetailScreenState
    extends State<ProductOrderHistoryDetailScreen> {
  TextEditingController _cCancelReason = new TextEditingController();
  FocusNode _fCancelReason = new FocusNode();

  ProductOrderHistory productOrderHistory;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool _isExpanded = false;
  APIHelper? apiHelper;
  late BusinessRule br;

  _ProductOrderHistoryDetailScreenState(this.productOrderHistory) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.lbl_order_detail),
            actions: [],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Card(
                          child: ListTile(
                            title: Text(
                                AppLocalizations.of(context)!.lbl_cart_id,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle2),
                            subtitle: Text("${productOrderHistory.cart_id}",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText2),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Card(
                          child: ListTile(
                            title: Text(
                                AppLocalizations.of(context)!.lbl_order_on,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle2),
                            subtitle: Text(
                                "${DateFormat('dd/MM/yyyy').format(productOrderHistory.created_at!)}  ${DateFormat('hh:mm a').format(productOrderHistory.created_at!)}",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 15, right: 15),
                  child: Card(
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)!.lbl_order_total,
                          style: Theme.of(context).primaryTextTheme.subtitle2),
                      trailing: Text(
                          "${global.currency.currency_sign} ${productOrderHistory.total_price}",
                          style: Theme.of(context).primaryTextTheme.subtitle1),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 15, right: 15),
                  child: Card(
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: CircleAvatar(
                          backgroundColor: productOrderHistory.status == 4
                              ? Colors.grey
                              : productOrderHistory.status == 3
                                  ? Color(0xFF00547B)
                                  : productOrderHistory.status == 1
                                      ? Colors.amber
                                      : Colors.green[600],
                          radius: 15,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      title: Text(
                          productOrderHistory.status == 4
                              ? AppLocalizations.of(context)!.lbl_cancelled
                              : productOrderHistory.status == 3
                                  ? AppLocalizations.of(context)!.lbl_failed
                                  : productOrderHistory.status == 1
                                      ? AppLocalizations.of(context)!
                                          .lbl_pending
                                      : AppLocalizations.of(context)!
                                          .lbl_completed,
                          style: Theme.of(context).primaryTextTheme.subtitle2),
                      subtitle: Text(
                        "${DateFormat('dd/MM/yyyy').format(productOrderHistory.created_at!)}  ${DateFormat('hh:mm a').format(productOrderHistory.created_at!)}",
                        style: Theme.of(context).primaryTextTheme.bodyText2,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                    itemCount: productOrderHistory.vendor.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                            EdgeInsets.only(bottom: 8, left: 15, right: 15),
                        child: Card(
                          child: ExpansionTile(
                              title: Text(
                                '${productOrderHistory.vendor[index].vendor_name}',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle2,
                              ),
                              onExpansionChanged: (val) {
                                _isExpanded = val;
                                setState(() {});
                              },
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${productOrderHistory.vendor[index].vendor_loc}",
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .subtitle1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${productOrderHistory.vendor[index].vendor_phone}",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Icon(
                                    _isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        child: Container(
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: global.isRTL
                                                ? new BorderRadius.only(
                                                    topRight:
                                                        new Radius.circular(
                                                            5.0),
                                                    bottomRight:
                                                        new Radius.circular(
                                                            5.0),
                                                  )
                                                : new BorderRadius.only(
                                                    topLeft:
                                                        new Radius.circular(
                                                            5.0),
                                                    bottomLeft:
                                                        new Radius.circular(
                                                            5.0),
                                                  ),
                                            color: Colors.grey[200],
                                            border: new Border.all(
                                              color: Colors.grey[200]!,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(4),
                                          height: 25,
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .lbl_items,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .bodyText2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 25,
                                        width: 40,
                                        padding: EdgeInsets.all(4),
                                        child: Center(
                                          child: Text(
                                            "${productOrderHistory.count}",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .bodyText2,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: global.isRTL
                                              ? new BorderRadius.only(
                                                  topLeft:
                                                      new Radius.circular(5.0),
                                                  bottomLeft:
                                                      new Radius.circular(5.0),
                                                )
                                              : new BorderRadius.only(
                                                  topLeft:
                                                      new Radius.circular(5.0),
                                                  bottomLeft:
                                                      new Radius.circular(5.0),
                                                ),
                                          border: new Border.all(
                                            color: Colors.grey[200]!,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              children: [
                                ListTile(
                                  tileColor: Colors.grey[200],
                                  title: Text(AppLocalizations.of(context)!
                                      .lbl_total_price),
                                  trailing: Text(
                                      '${global.currency.currency_sign}' +
                                          '${productOrderHistory.total_price}'),
                                ),
                                productOrderHistory.status == 1
                                    ? ListTile(
                                        tileColor: Colors.grey[200],
                                        title: Text('Go to location'),
                                        trailing:
                                            productOrderHistory.status == 1
                                                ? IconButton(
                                                    onPressed: () async {
                                                      await _openMap(
                                                          productOrderHistory
                                                              .vendor[0].lat,
                                                          productOrderHistory
                                                              .vendor[0].lng);
                                                    },
                                                    icon: Icon(Icons.map))
                                                : SizedBox())
                                    : SizedBox(),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 4),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: productOrderHistory
                                          .vendor[index].products.length,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              tileColor: Colors.transparent,
                                              title: Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl:
                                                        global.baseUrlForImage +
                                                            productOrderHistory
                                                                .vendor[index]
                                                                .products[i]
                                                                .product_image!,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  imageProvider)),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                  Padding(
                                                    padding: global.isRTL
                                                        ? const EdgeInsets.only(
                                                            right: 10)
                                                        : const EdgeInsets.only(
                                                            left: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            '${productOrderHistory.vendor[index].products[i].product_name}',
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .subtitle2),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              child: Container(
                                                                width: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius: global
                                                                          .isRTL
                                                                      ? new BorderRadius
                                                                          .only(
                                                                          topRight: new Radius
                                                                              .circular(
                                                                              5.0),
                                                                          bottomRight: new Radius
                                                                              .circular(
                                                                              5.0),
                                                                        )
                                                                      : new BorderRadius
                                                                          .only(
                                                                          topLeft: new Radius
                                                                              .circular(
                                                                              5.0),
                                                                          bottomLeft: new Radius
                                                                              .circular(
                                                                              5.0),
                                                                        ),
                                                                  color: Colors
                                                                          .grey[
                                                                      200],
                                                                  border:
                                                                      new Border
                                                                          .all(
                                                                    color: Colors
                                                                            .grey[
                                                                        200]!,
                                                                  ),
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                height: 25,
                                                                child: Center(
                                                                  child: Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .lbl_qty,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .primaryTextTheme
                                                                        .bodyText2,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 25,
                                                              width: 40,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4),
                                                              child: Center(
                                                                child: Text(
                                                                  "${productOrderHistory.vendor[index].products[i].qty}",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .primaryTextTheme
                                                                      .bodyText2,
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: global
                                                                        .isRTL
                                                                    ? new BorderRadius
                                                                        .only(
                                                                        topLeft: new Radius
                                                                            .circular(
                                                                            5.0),
                                                                        bottomLeft: new Radius
                                                                            .circular(
                                                                            5.0),
                                                                      )
                                                                    : new BorderRadius
                                                                        .only(
                                                                        topLeft: new Radius
                                                                            .circular(
                                                                            5.0),
                                                                        bottomLeft: new Radius
                                                                            .circular(
                                                                            5.0),
                                                                      ),
                                                                border:
                                                                    new Border
                                                                        .all(
                                                                  color: Colors
                                                                          .grey[
                                                                      200]!,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: Text(
                                                ' ${global.currency.currency_sign} ${productOrderHistory.vendor[index].products[i].price}',
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .headline5,
                                              ),
                                            ),
                                            i ==
                                                    productOrderHistory
                                                            .vendor[index]
                                                            .products
                                                            .length -
                                                        1
                                                ? SizedBox()
                                                : Divider(
                                                    endIndent: 10,
                                                    indent: 10,
                                                    color: Colors.grey[300],
                                                  )
                                          ],
                                        );
                                      }),
                                )
                              ]),
                        ),
                      );
                    }),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(),
                productOrderHistory.status == 1
                    ? SizedBox(
                        width: 150,
                        height: 43,
                        child: TextButton(
                            onPressed: () async {
                              _cancelReasonDialog();
                              setState(() {});
                            },
                            child: Text(AppLocalizations.of(context)!
                                .lbl_cancel_order)),
                      )
                    : SizedBox(),
                SizedBox(),
              ],
            ),
          ),
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
  }

  _cancelOrder(String? cart_id, String reason) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog(context);
        await apiHelper!.cancelOrder(cart_id, reason).then((result) {
          if (result != null) {
            if (result.status == "1") {
              hideLoader(context);
              productOrderHistory.status = 4;
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
      print("Exception - productOrderHistoryScreen.dart - _cancelOrder():" +
          e.toString());
    }
  }

  _cancelReasonDialog() async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: AlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.lbl_cancellation_reason,
                ),
                content: Container(
                    margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                    height: 70,
                    child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        autofocus: false,
                        cursorColor: Color(0xFF00547B),
                        enabled: true,
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                        controller: _cCancelReason,
                        focusNode: _fCancelReason,
                        validator: (text) {
                          if (_cCancelReason.text.isEmpty &&
                              _cCancelReason.text == "") {
                            return AppLocalizations.of(context)!
                                .txt_provide_cancel_reason;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintStyle: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle,
                            enabledBorder: Theme.of(context)
                                .inputDecorationTheme
                                .enabledBorder,
                            focusedBorder: Theme.of(context)
                                .inputDecorationTheme
                                .focusedBorder,
                            border:
                                Theme.of(context).inputDecorationTheme.border,
                            prefixIcon: Icon(
                              Icons.remove_circle_outline,
                              size: 20,
                              color: Theme.of(context).primaryIconTheme.color,
                            ),
                            hintText: AppLocalizations.of(context)!
                                .lbl_cancel_reason),
                        onFieldSubmitted: (text) async {
                          _cCancelReason.text = text;

                          FocusScope.of(context).unfocus();
                          setState(() {});
                        },
                      ),
                    )),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      AppLocalizations.of(context)!.lbl_cancel,
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF171D2C),
                          fontWeight: FontWeight.w400),
                    ),
                    onPressed: () {
                      return Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text(AppLocalizations.of(context)!.lbl_confirm,
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF00547B),
                            fontWeight: FontWeight.w400)),
                    onPressed: () async {
                      if (_cCancelReason.text.isNotEmpty &&
                          _cCancelReason.text != "") {
                        await _cancelOrder(
                            productOrderHistory.cart_id, _cCancelReason.text);
                        _cCancelReason.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print(
          'Exception - productOrderHistoryScreen.dart - _cancelReasonDialog(): ' +
              e.toString());
    }
  }

  _openMap(String? latitude, String? longitude) async {
    try {
      Uri googleUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl);
      } else {
        throw 'Could not open the map.';
      }
    } catch (e) {
      print("Exception - productOrderHistoryDetailScreen.dart - _openMap(): " +
          e.toString());
    }
  }
}
