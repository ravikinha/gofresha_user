import 'dart:io';

import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/productDetailModel.dart';
import 'package:app/screens/cartScreen.dart';
import 'package:app/screens/signInScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  final bool? isShowGoCartBtn;
  final int? productId;

  ProductDetailScreen(this.productId, {a, o, this.isShowGoCartBtn}) : super();

  @override
  _ProductDetailScreenState createState() =>
      new _ProductDetailScreenState(this.productId, this.isShowGoCartBtn);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  int? productId;
  bool? isShowGoCartBtn;
  ProductDetail? _productDetail;
  bool _isDataLoaded = false;
  APIHelper? apiHelper;
  late BusinessRule br;

  _ProductDetailScreenState(this.productId, this.isShowGoCartBtn) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(),
          body: _isDataLoaded
              ? SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CachedNetworkImage(
                          imageUrl: global.baseUrlForImage +
                              _productDetail!.product_image!,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: MediaQuery.of(context).size.height * 0.24,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          if (global.user!.id == null) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignInScreen()),
                                            );
                                          } else {
                                            bool? _isFav;
                                            _isFav = await _addToFavorite(
                                                _productDetail!.id);
                                            if (_isFav!) {
                                              _productDetail!.isFavourite =
                                                  !_productDetail!.isFavourite;
                                            }
                                          }
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          _productDetail!.isFavourite
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: _productDetail!.isFavourite
                                              ? Colors.blue
                                              : Colors.white,
                                        ))
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 8, bottom: 4, top: 4),
                                  color: Colors.black.withOpacity(0.5),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${_productDetail?.product_name}",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .displayLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(),
                            height: MediaQuery.of(context).size.height * 0.24,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    BackButton(
                                      color: Colors.white,
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          if (global.user!.id == null) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignInScreen()),
                                            );
                                          } else {
                                            bool? _isFav;
                                            _isFav = await _addToFavorite(
                                                _productDetail!.id);
                                            if (_isFav!) {
                                              _productDetail!.isFavourite =
                                                  !_productDetail!.isFavourite;
                                            }
                                          }
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          _productDetail!.isFavourite
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: _productDetail!.isFavourite
                                              ? Colors.blue
                                              : Colors.white,
                                        ))
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 8, bottom: 4, top: 4),
                                  color: Colors.black.withOpacity(0.5),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${_productDetail!.product_name}",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .displayLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Text(
                              AppLocalizations.of(context)!.lbl_description,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleLarge),
                        ),
                        Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, right: 10),
                            child: Html(
                              data: _productDetail?.description ??
                                  '<p>No Data Available</p>',
                              style: {
                                'body': Style(textAlign: TextAlign.justify),
                              },
                            )),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Text(AppLocalizations.of(context)!.lbl_price,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleLarge),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 2, right: 10),
                          child: Text(
                            '${global.currency.currency_sign}${_productDetail!.price}',
                            style:
                                Theme.of(context).primaryTextTheme.titleMedium,
                          ),
                        ),
                      ]),
                )
              : _shimmer(),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(top: 5, bottom: Platform.isIOS ? 20 : 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                    color: Colors.blue,
                    onPressed: () async {
                      global.user!.id == null
                          ? Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                            )
                          : isShowGoCartBtn!
                              ? Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => CartScreen()),
                                )
                              : await _addToCart(1, _productDetail!.id);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            isShowGoCartBtn!
                                ? AppLocalizations.of(context)!.lbl_go_to_cart
                                : AppLocalizations.of(context)!.lbl_add_to_cart,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          )),
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

  _addToCart(int quantity, int? id) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog(context);
        await apiHelper!
            .addToCart(global.user!.id, id, quantity)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              hideLoader(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print(
          "Exception - ProductListScreen.dart - _addToCart():" + e.toString());
    }
  }

  Future<bool?> _addToFavorite(int? id) async {
    bool _isFav = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.addToFavorite(global.user!.id, id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _isFav = true;

              setState(() {});
            } else if (result.status == "0") {
              _isFav = true;
            }
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
      return _isFav;
    } catch (e) {
      print("Exception - ProductListScreen.dart - _addToFavorite():" +
          e.toString());
      return null;
    }
  }

  _getProductDetails() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getProductDetails(productId).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _productDetail = result.recordList;
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
    } catch (e) {
      print("Exception - productDetailScreen.dart - _getProductDetails():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getProductDetails();
      _isDataLoaded = true;

      setState(() {});
    } catch (e) {
      print("Exception - productDetailScreen.dart - _init():" + e.toString());
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.24,
                width: MediaQuery.of(context).size.width,
                child: Card(),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.55,
                child: Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
