import 'dart:async';

import 'package:app/screens/cartScreen.dart';
import 'package:app/screens/productDetailScreen.dart';
import 'package:app/screens/signInScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../models/favoriteModel.dart';
import '../widgets/widgets.dart';

import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/screens/searchScreen.dart';

import 'package:badges/badges.dart' as badges;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  Favorites? _favoritesList;
  bool _isDataLoaded = false;
  APIHelper? apiHelper;
  late BusinessRule br;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.lbl_favourites,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => SearchScreen(
                              0,
                            )),
                  );
                },
                icon: Icon(Icons.search)),
            _isDataLoaded
                ? Container(
                    margin: EdgeInsets.only(top: 3),
                    padding: global.isRTL
                        ? EdgeInsets.only(
                            left: 20,
                          )
                        : EdgeInsets.only(
                            right: 20,
                          ),
                    child: badges.Badge(
                      badgeStyle: badges.BadgeStyle(
                        padding: EdgeInsets.all(5),
                        badgeColor: Theme.of(context).primaryColor,
                      ),
                      showBadge: true,
                      badgeContent: Text(
                        global.user!.cart_count == null
                            ? "0"
                            : '${global.user!.cart_count}',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CartScreen(
                                    screenId: 1,
                                  )));
                        },
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: _isDataLoaded
            ? _favoritesList != null && _favoritesList!.fav_items.length > 0
                ? _productListWidget()
                : Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .txt_nothing_is_yet_to_see_here,
                      style: Theme.of(context).primaryTextTheme.subtitle2,
                    ),
                  )
            : _shimmer());
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
    if (global.user!.id == null) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      });
    }
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
              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
      return _isSucessfullyAdded;
    } catch (e) {
      print("Exception - favoritesScreen.dart - _addToCart():" + e.toString());
      return _isSucessfullyAdded;
    }
  }

  Future<bool> _delFromCart(int? id) async {
    bool _isDeletedSuccessfully = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.delFromCart(global.user!.id, id).then((result) {
          if (result != null) {
            if (result.status == "1" && global.user?.cart_count != null) {
              _isDeletedSuccessfully = true;
              global.user!.cart_count = global.user!.cart_count! - 1;
              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
      return _isDeletedSuccessfully;
    } catch (e) {
      print(
          "Exception - favouritesScreen.dart - _delFromCart():" + e.toString());
      return _isDeletedSuccessfully;
    }
  }

  _getFavoriteList() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getFavoriteList(global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _favoritesList = result.recordList;
              _isDataLoaded = true;
            } else if (result.status == "0") {
              _favoritesList = null;
              _isDataLoaded = true;
            }
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - favoritesScreen.dart - _getFavoriteList():" +
          e.toString());
    }
  }

  _init() async {
    await _getFavoriteList();
  }

  List<Widget> _productList() {
    List<Widget> productList = [];
    for (int index = 0; index < _favoritesList!.fav_items.length; index++) {
      productList.add(InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                      _favoritesList!.fav_items[index].id,
                      isShowGoCartBtn:
                          _favoritesList!.fav_items[index].cart_qty != null &&
                                  _favoritesList!.fav_items[index].cart_qty! > 0
                              ? true
                              : false,
                    )),
          );
        },
        child: SizedBox(
          height: (MediaQuery.of(context).size.width / 1.93),
          width: (MediaQuery.of(context).size.width / 2) - 17,
          child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _favoritesList!.fav_items[index].product_image != null
                  ? CachedNetworkImage(
                      imageUrl: global.baseUrlForImage +
                          _favoritesList!.fav_items[index].product_image!,
                      imageBuilder: (context, imageProvider) => Container(
                        height:
                            (((MediaQuery.of(context).size.width / 2) - 15) *
                                    1.4) *
                                0.55,
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.cover, image: imageProvider)),
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () async {
                              bool? _isFav = await (_removeFromFavorites(
                                  _favoritesList!.fav_items[index].id));
                              if (_isFav!) {
                                _favoritesList!.fav_items.removeAt(index);
                              }
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.blue,
                            )),
                      ),
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  : Container(
                      height: (((MediaQuery.of(context).size.width / 2) - 15) *
                              1.4) *
                          0.72,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        AppLocalizations.of(context)!.lbl_no_image,
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      )),
              SizedBox(
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        child: Text(
                          '${_favoritesList!.fav_items[index].product_name}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      ),
                      Text(
                          '${global.currency.currency_sign}${_favoritesList!.fav_items[index].price}',
                          style: Theme.of(context).primaryTextTheme.subtitle1)
                    ],
                  ),
                ),
              ),
              _favoritesList!.fav_items[index].cart_qty == null ||
                      (_favoritesList!.fav_items[index].cart_qty != null &&
                          _favoritesList!.fav_items[index].cart_qty == 0)
                  ? GestureDetector(
                      onTap: () async {
                        showOnlyLoaderDialog(context);

                        int _qty = 1;
                        bool isSuccess = await _addToCart(
                            _qty, _favoritesList!.fav_items[index].id);
                        if (isSuccess && global.user?.cart_count != null) {
                          _favoritesList!.fav_items[index].cart_qty = 1;
                          global.user!.cart_count =
                              global.user!.cart_count! + 1;
                        }
                        hideLoader(context);
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: Theme.of(context)
                                  .floatingActionButtonTheme
                                  .backgroundColor,
                              size: 16,
                            ),
                            Text(AppLocalizations.of(context)!.lbl_add_to_cart,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1)
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              height: 20,
                              width: 20,
                              child: TextButton(
                                onPressed: () async {
                                  showOnlyLoaderDialog(context);
                                  if (_favoritesList!
                                          .fav_items[index].cart_qty ==
                                      1) {
                                    bool isSuccess = await _delFromCart(
                                        _favoritesList!.fav_items[index].id);
                                    if (isSuccess) {
                                      _favoritesList!
                                          .fav_items[index].cart_qty = 0;
                                    }
                                    _favoritesList!.fav_items[index].cart_qty =
                                        0;
                                  } else {
                                    int _qty = _favoritesList!
                                            .fav_items[index].cart_qty! -
                                        1;

                                    bool isSuccess = await _addToCart(_qty,
                                        _favoritesList!.fav_items[index].id);
                                    if (isSuccess &&
                                        _favoritesList
                                                ?.fav_items[index].cart_qty !=
                                            null) {
                                      _favoritesList!.fav_items[index]
                                          .cart_qty = _favoritesList!
                                              .fav_items[index].cart_qty! -
                                          1;
                                    }
                                  }
                                  hideLoader(context);
                                  setState(() {});
                                },
                                child:
                                    _favoritesList!.fav_items[index].cart_qty ==
                                            1
                                        ? Icon(
                                            Icons.delete,
                                            size: 11,
                                          )
                                        : Icon(
                                            FontAwesomeIcons.minus,
                                            size: 11,
                                          ),
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0,
                                  color: Theme.of(context).primaryColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Center(
                              child: Text(
                                "${_favoritesList!.fav_items[index].cart_qty}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              height: 20,
                              width: 20,
                              child: TextButton(
                                onPressed: () async {
                                  showOnlyLoaderDialog(context);
                                  int _qty = _favoritesList!
                                          .fav_items[index].cart_qty! +
                                      1;

                                  bool isSuccess = await _addToCart(_qty,
                                      _favoritesList!.fav_items[index].id);
                                  if (isSuccess &&
                                      _favoritesList
                                              ?.fav_items[index].cart_qty !=
                                          null) {
                                    _favoritesList!.fav_items[index].cart_qty =
                                        _favoritesList!
                                                .fav_items[index].cart_qty! +
                                            1;
                                  }
                                  hideLoader(context);

                                  setState(() {});
                                },
                                child: Icon(
                                  FontAwesomeIcons.plus,
                                  size: 10,
                                ),
                              ))
                        ],
                      ),
                    )
            ]),
          ),
        ),
      ));
    }
    return productList;
  }

  _productListWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: 10,
            left: _favoritesList!.fav_items.length == 1 ? 15 : 5,
            right: 5,
            top: 15),
        child: Align(
          alignment: _favoritesList!.fav_items.length == 1
              ? global.isRTL
                  ? Alignment.centerRight
                  : Alignment.centerLeft
              : Alignment.center,
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 12,
              children: _productList()),
        ),
      ),
    );
  }

  Future<bool?> _removeFromFavorites(int? id) async {
    bool _isFav = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.addToFavorite(global.user!.id, id).then((result) {
          if (result != null) {
            if (result.status == "0") {
              _isFav = true;

              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
      return _isFav;
    } catch (e) {
      print("Exception - favoritesScreen.dart - _removeFromFavorites():" +
          e.toString());
      return null;
    }
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: GridView.count(
            crossAxisSpacing: 8,
            crossAxisCount: 2,
            children: List.generate(
                8,
                (index) => SizedBox(
                      child: Card(
                          margin: EdgeInsets.only(top: 5, bottom: 5, left: 5)),
                    )),
          )),
    );
  }
}
