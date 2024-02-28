import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/productOrderHistoryModel.dart';
import 'package:app/screens/productOrderHistoryDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class ProductOrderHistoryScreen extends StatefulWidget {
  ProductOrderHistoryScreen({a, o}) : super();

  @override
  _ProductOrderHistoryScreenState createState() =>
      new _ProductOrderHistoryScreenState();
}

class _ProductOrderHistoryScreenState extends State<ProductOrderHistoryScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<ProductOrderHistory>? _productOrderHistoryList = [];
  bool _isDataLoaded = false;
  APIHelper? apiHelper;
  late BusinessRule br;

  _ProductOrderHistoryScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: RichText(
              text: TextSpan(
                  text: AppLocalizations.of(context)!.lbl_my_orders,
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                  // children: [
                  //   TextSpan(
                  //       text: AppLocalizations.of(context)!
                  //           .txt_store_pick_up_only,
                  //       style: Theme.of(context).primaryTextTheme.titleMedium)
                  // ]
                  ),
            ),
          ),
          body: _isDataLoaded
              ? _productOrderHistoryList != null &&
                      _productOrderHistoryList!.length > 0
                  ? ListView.builder(
                      itemCount: _productOrderHistoryList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductOrderHistoryDetailScreen(
                                        _productOrderHistoryList![index],
                                      )),
                            );
                          },
                          child: Card(
                              margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              child: ListTile(
                                title: Text(
                                    '${_productOrderHistoryList![index].cart_id}',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleSmall),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Row(
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
                                                  .bodyMedium,
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
                                            "${_productOrderHistoryList![index].count}",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .bodyMedium,
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
                                                  topRight:
                                                      new Radius.circular(5.0),
                                                  bottomRight:
                                                      new Radius.circular(5.0),
                                                ),
                                          border: new Border.all(
                                            color: Colors.grey[200]!,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 22,
                                            width: 90,
                                            decoration: BoxDecoration(
                                              color: _productOrderHistoryList![
                                                              index]
                                                          .status ==
                                                      4
                                                  ? Colors.grey
                                                  : _productOrderHistoryList![
                                                                  index]
                                                              .status ==
                                                          3
                                                      ? Colors.blue
                                                      : _productOrderHistoryList![
                                                                      index]
                                                                  .status ==
                                                              1
                                                          ? Colors.amber
                                                          : Colors.green[600],
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      7.0),
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Center(
                                              child: Text(
                                                _productOrderHistoryList![index]
                                                            .status ==
                                                        4
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .lbl_cancelled
                                                    : _productOrderHistoryList![index]
                                                                .status ==
                                                            3
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .lbl_failed
                                                        : _productOrderHistoryList![
                                                                        index]
                                                                    .status ==
                                                                1
                                                            ? AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .lbl_pending
                                                            : AppLocalizations
                                                                    .of(context)!
                                                                .lbl_completed,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Container(
                                        width: 80,
                                        child: Column(
                                          crossAxisAlignment: global.isRTL
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 15,
                                              child: Text(
                                                '${DateFormat('hh:mm a').format(_productOrderHistoryList![index].created_at!)}',
                                                textAlign: TextAlign.right,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                            Container(
                                              height: 15,
                                              child: Text(
                                                '${DateFormat('dd/MM/yyyy').format(_productOrderHistoryList![index].created_at!)}',
                                                textAlign: TextAlign.right,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                            Container(
                                              height: 20,
                                              child: Text(
                                                '${global.currency.currency_sign! + ' ' + _productOrderHistoryList![index].total_price!}',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      })
                  : Center(
                      child: Text(
                        AppLocalizations.of(context)!.txt_no_order_yet,
                        style: Theme.of(context).primaryTextTheme.titleSmall,
                      ),
                    )
              : _shimmer()),
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

  _getProductOrderHistory() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getProductOrderHistory().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _productOrderHistoryList = result.recordList;
              _isDataLoaded = true;
              setState(() {});
            } else if (result.status == "0") {
              _productOrderHistoryList = null;
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
          "Exception - productOrderHistoryScreen.dart - _getProductOrderHistory():" +
              e.toString());
    }
  }

  _init() async {
    await _getProductOrderHistory();
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.all(8),
                height: 65,
                width: MediaQuery.of(context).size.width,
                child: Card(),
              );
            }),
      ),
    );
  }
}
