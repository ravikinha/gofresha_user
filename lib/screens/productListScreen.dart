import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/productModel.dart';
import 'package:app/screens/cartScreen.dart';
import 'package:app/screens/productDetailScreen.dart';
import 'package:app/screens/searchScreen.dart';
import 'package:app/screens/signInScreen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class ProductListScreen extends StatefulWidget {
  ProductListScreen({a, o}) : super();

  @override
  _ProductListScreenState createState() => new _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _productList = [];
  bool _isDataLoaded = false;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool? _isFav;
  int? selectedProductId;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  ScrollController _scrollController = ScrollController();
  int pageNumber = 0;
  APIHelper? apiHelper;
  late BusinessRule br;

  _ProductListScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();

        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.lbl_products,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SearchScreen(
                                2,
                              )),
                    );
                  },
                  icon: Icon(Icons.search)),
              global.user?.id == null
                  ? SizedBox()
                  : _isDataLoaded
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
                              padding: EdgeInsets.all(7),
                              badgeColor: Theme.of(context).primaryColor,
                            ),
                            showBadge: true,
                            badgeContent: Text(
                              '${global.user?.cart_count}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
              ? _productList.length > 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: _productListWidget(),
                    )
                  : Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .txt_product_will_shown_here,
                        style: Theme.of(context).primaryTextTheme.subtitle2,
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

  List<Widget> _addProductList() {
    List<Widget> productList = [];
    for (int index = 0; index < _productList.length; index++) {
      productList.add(InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                      _productList[index].id,
                      isShowGoCartBtn: _productList[index].cart_qty != null &&
                              (_productList[index].cart_qty ?? 0) > 0
                          ? true
                          : false,
                    )),
          );
        },
        child: SizedBox(
          height: (MediaQuery.of(context).size.width / 1.77),
          width: (MediaQuery.of(context).size.width / 2) - 17,
          child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _productList[index].product_image != null
                  ? CachedNetworkImage(
                      imageUrl: global.baseUrlForImage +
                          _productList[index].product_image!,
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
                              if (global.user?.id == null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()),
                                );
                              } else {
                                _isFav = await _addToFavorite(
                                    _productList[index].id);
                                if (_isFav ?? false) {
                                  _productList[index].isFavourite =
                                      !_productList[index].isFavourite!;
                                }
                              }
                              setState(() {});
                            },
                            icon: Icon(
                              _productList[index].isFavourite!
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: _productList[index].isFavourite!
                                  ? Colors.blue
                                  : Colors.white,
                            )),
                      ),
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  : Container(
                      width: 110,
                      height: 110,
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_productList[index].product_name}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_productList[index].quantity}',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                      Text(
                          '${global.currency.currency_sign} ${_productList[index].price}',
                          style: Theme.of(context).primaryTextTheme.subtitle1)
                    ],
                  ),
                ),
              ),
              _productList[index].cart_qty == null ||
                      (_productList[index].cart_qty != null &&
                          _productList[index].cart_qty == 0)
                  ? GestureDetector(
                      onTap: () async {
                        if (global.user!.id == null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()),
                          );
                        } else {
                          showOnlyLoaderDialog(context);

                          int _qty = 1;

                          bool isSuccess =
                              await _addToCart(_qty, _productList[index].id);
                          if (isSuccess) {
                            _productList[index].cart_qty = 1;
                            if (global.user != null &&
                                global.user?.cart_count != null) {
                              global.user?.cart_count =
                                  global.user!.cart_count! + 1;
                            }
                          }
                          hideLoader(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
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
                                  if (_productList[index].cart_qty == 1) {
                                    bool isSuccess = await _delFromCart(
                                        _productList[index].id);
                                    if (isSuccess) {
                                      _productList[index].cart_qty = 0;
                                    }
                                    _productList[index].cart_qty = 0;
                                  } else {
                                    int _qty =
                                        _productList[index].cart_qty! - 1;

                                    bool isSuccess = await _addToCart(
                                        _qty, _productList[index].id);
                                    if (isSuccess &&
                                        _productList[index].cart_qty != null) {
                                      _productList[index].cart_qty =
                                          _productList[index].cart_qty! - 1;
                                    }
                                  }
                                  hideLoader(context);
                                  setState(() {});
                                },
                                child: _productList[index].cart_qty == 1
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
                                  width: 1.0, color: Colors.blue),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Center(
                              child: Text(
                                "${_productList[index].cart_qty}",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blue),
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
                                  if (_productList[index].cart_qty != null) {
                                    int _qty =
                                        _productList[index].cart_qty! + 1;

                                    bool isSuccess = await _addToCart(
                                        _qty, _productList[index].id);
                                    if (isSuccess) {
                                      _productList[index].cart_qty =
                                          _productList[index].cart_qty! + 1;
                                    }
                                    hideLoader(context);
                                  }
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
      print(
          "Exception - productListScreen.dart - _addToCart():" + e.toString());
      return _isSucessfullyAdded;
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
      print("Exception - productListScreen.dart - _addToFavorite():" +
          e.toString());
      return null;
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
              if (global.user?.cart_count != null) {
                global.user?.cart_count = global.user!.cart_count! - 1;
                setState(() {});
              }
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
      return _isDeletedSuccessfully;
    } catch (e) {
      print("Exception - productListScreen.dart - _delFromCart():" +
          e.toString());
      return _isDeletedSuccessfully;
    }
  }

  _getProducts() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });

          if (_productList.isEmpty) {
            pageNumber = 1;
          } else {
            pageNumber++;
          }
          await apiHelper!
              .getProducts(global.lat, global.lng, pageNumber, '')
              .then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<Product> _tList = result.recordList;

                if (_tList.isEmpty) {
                  _isRecordPending = false;
                }

                _productList.addAll(_tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - productListScreen.dart - _getProducts():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getProducts();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getProducts();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - productListScreen.dart - _init():" + e.toString());
    }
  }

  _productListWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Wrap(spacing: 12, runSpacing: 12, children: _addProductList()),
      ),
    );
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
