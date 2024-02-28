// ignore_for_file: deprecated_member_use

import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/cartModel.dart';
import 'package:app/screens/paymentGatewaysScreen.dart';
import 'package:app/screens/productListScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class CartScreen extends StatefulWidget {
  final int? screenId;

  CartScreen({a, o, this.screenId}) : super();

  @override
  _CartScreenState createState() => new _CartScreenState(screenId: screenId);
}

class _CartScreenState extends State<CartScreen> {
  int? screenId;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  Cart? _cartList;
  Cart? _cartItems;
  bool _isDataLoaded = false;
  APIHelper? apiHelper;
  late BusinessRule br;

  _CartScreenState({this.screenId}) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: RichText(
                text: TextSpan(
                    text: AppLocalizations.of(context)!.lbl_my_cart,
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                    children: [
                      TextSpan(
                          text: AppLocalizations.of(context)!
                              .txt_store_pick_up_only,
                          style: Theme.of(context).primaryTextTheme.subtitle1)
                    ]),
              ),
              actions: [
                _isDataLoaded
                    ? _cartList != null && _cartList!.cart_items.length > 0
                        ? IconButton(
                            onPressed: () {
                              _delConfirmationDialog();
                            },
                            icon: Icon(Icons.delete_outline))
                        : SizedBox()
                    : SizedBox()
              ],
            ),
            body: _isDataLoaded
                ? _cartList != null && _cartList!.cart_items.length > 0
                    ? SafeArea(
                        child: ListView.builder(
                          itemCount: _cartList!.cart_items.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 13, right: 13),
                              child: Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _cartList!.cart_items[index]
                                                .product_image !=
                                            null
                                        ? CachedNetworkImage(
                                            imageUrl: global.baseUrlForImage +
                                                _cartList!.cart_items[index]
                                                    .product_image!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Card(
                                              child: Container(
                                                height: 85,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            ),
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )
                                        : Card(
                                            child: Container(
                                              height: 85,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .lbl_no_image,
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .subtitle1,
                                                ),
                                              ),
                                            ),
                                          ),
                                    Expanded(
                                      child: Padding(
                                        padding: global.isRTL
                                            ? EdgeInsets.only(
                                                right: 18, top: 10)
                                            : EdgeInsets.only(
                                                left: 18, top: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${_cartList!.cart_items[index].product_name}',
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .bodyText1,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${global.currency.currency_sign}${_cartList!.cart_items[index].price}  ',
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline6,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: global.isRTL
                                          ? EdgeInsets.only(left: 8)
                                          : EdgeInsets.only(right: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              height: 25,
                                              width: 25,
                                              child: TextButton(
                                                onPressed: () async {
                                                  if (_cartList!
                                                          .cart_items[index]
                                                          .qty ==
                                                      1) {
                                                    _delConfirmationDialog(
                                                        index: index,
                                                        callId: 1);
                                                  } else {
                                                    showOnlyLoaderDialog(
                                                        context);
                                                    int _qty = _cartList!
                                                            .cart_items[index]
                                                            .qty! -
                                                        1;
                                                    bool isSuccess =
                                                        await _addToCart(
                                                            _qty,
                                                            _cartList!
                                                                .cart_items[
                                                                    index]
                                                                .product_id);
                                                    if (isSuccess &&
                                                        _cartList
                                                                ?.cart_items[
                                                                    index]
                                                                .qty !=
                                                            null) {
                                                      _cartList!
                                                          .cart_items[index]
                                                          .qty = _cartList!
                                                              .cart_items[index]
                                                              .qty! -
                                                          1;
                                                    }
                                                    hideLoader(context);
                                                  }

                                                  setState(() {});
                                                },
                                                child: _cartList!
                                                            .cart_items[index]
                                                            .qty ==
                                                        1
                                                    ? Icon(
                                                        Icons.delete,
                                                        size: 15,
                                                      )
                                                    : Icon(
                                                        FontAwesomeIcons.minus,
                                                        size: 13,
                                                      ),
                                              )),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      Colors.blue),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${_cartList!.cart_items[index].qty}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Container(
                                              height: 25,
                                              width: 25,
                                              child: TextButton(
                                                onPressed: () async {
                                                  showOnlyLoaderDialog(context);
                                                  int _qty = _cartList!
                                                          .cart_items[index]
                                                          .qty! +
                                                      1;
                                                  bool isSuccess =
                                                      await _addToCart(
                                                          _qty,
                                                          _cartList!
                                                              .cart_items[index]
                                                              .product_id);
                                                  if (isSuccess &&
                                                      _cartList
                                                              ?.cart_items[
                                                                  index]
                                                              .qty !=
                                                          null) {
                                                    _cartList!.cart_items[index]
                                                        .qty = _cartList!
                                                            .cart_items[index]
                                                            .qty! +
                                                        1;
                                                  }
                                                  hideLoader(context);
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  FontAwesomeIcons.plus,
                                                  size: 15,
                                                ),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Theme.of(context)
                                    .floatingActionButtonTheme
                                    .backgroundColor,
                                size: 150,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .txt_your_cart_is_empty,
                                  style: Theme.of(context)
                                      .appBarTheme
                                      .titleTextStyle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .txt_shop_for_some_product_in_order_to_purchase_them,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                : _shimmer(),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: BottomAppBar(
                  color: Color(0xFF171D2C),
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: _isDataLoaded
                        ? _cartList != null && _cartList!.cart_items.length > 0
                            ? ListTile(
                                tileColor: Colors.transparent,
                                title: RichText(
                                    text: TextSpan(
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1,
                                        children: [
                                      TextSpan(text: 'Total Amount  '),
                                      TextSpan(
                                          text:
                                              '${global.currency.currency_sign}${_cartList!.total_price}',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline5!
                                              .copyWith(color: Colors.white))
                                    ])),
                                trailing: MaterialButton(
                                  color: Colors.blue,
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentGatewayScreen(
                                                  cartList: _cartList)),
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.lbl_checkout,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    color: Colors.blue,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductListScreen()),
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .lbl_shop_now,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                        : SizedBox(),
                  )),
            )));
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

  Future<bool> _addToCart(int quantity, int? id) async {
    bool _isSucessfullyAdded = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!
            .addToCart(global.user!.id, id, quantity)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              _isSucessfullyAdded = true;
              _cartItems = result.recordList;
              _cartList!.total_price = _cartItems!.total_price;
              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
      return _isSucessfullyAdded;
    } catch (e) {
      print("Exception - cartScreen.dart - _addToCart():" + e.toString());
      return _isSucessfullyAdded;
    }
  }

  Future<bool> _clearCart() async {
    bool _isCartCleared = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.clearCart(global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _isCartCleared = true;
              showSnackBar(
                  context: context,
                  key: _scaffoldKey,
                  snackBarMessage: '${result.message}');

              setState(() {});
            } else {
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
      return _isCartCleared;
    } catch (e) {
      print("Exception - cartScreen.dart - _clearCart():" + e.toString());
      return _isCartCleared;
    }
  }

  _delConfirmationDialog({int? index, int? callId}) async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  callId == 1
                      ? AppLocalizations.of(context)!
                          .txt_remove_product_from_cart
                      : AppLocalizations.of(context)!.lbl_clear_cart,
                ),
                content: Text(
                  callId == 1
                      ? AppLocalizations.of(context)!
                          .txt_are_you_sure_you_want_to_remove_this_product
                      : AppLocalizations.of(context)!
                          .txt_are_you_sure_you_want_to_clear_this_product_from_cart,
                ),
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
                      if (callId == 1) {
                        bool isSuccess = await _delFromCart(
                            _cartList!.cart_items[index!].product_id);

                        if (isSuccess && global.user?.cart_count != null) {
                          _cartList!.cart_items[index].qty = 0;
                          _cartList!.cart_items.removeAt(index);
                          global.user?.cart_count =
                              global.user!.cart_count! - 1;
                        }
                      } else {
                        bool isSuccess = await _clearCart();
                        if (isSuccess) {
                          _cartList!.cart_items.clear();
                        }
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
      print('Exception - cartScreen.dart - _delConfirmationDialog(): ' +
          e.toString());
    }
  }

  Future<bool> _delFromCart(int? id) async {
    bool _isDeletedSuccessfully = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.delFromCart(global.user!.id, id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _isDeletedSuccessfully = true;
              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
      return _isDeletedSuccessfully;
    } catch (e) {
      print("Exception - cartScreen.dart - _delFromCart():" + e.toString());
      return _isDeletedSuccessfully;
    }
  }

  _getCartItems() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getCartItems(global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _cartList = result.recordList;
            } else if (result.status == "0") {
              _cartList = null;
            }
            _isDataLoaded = true;
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - cartScreen.dart - _getCartItems():" + e.toString());
    }
  }

  _init() async {
    await _getCartItems();
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
