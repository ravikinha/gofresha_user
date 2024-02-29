import 'package:app/models/barberShopModel.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/popularBarbersModel.dart';
import 'package:app/models/productModel.dart';
import 'package:app/models/serviceModel.dart';
import 'package:app/screens/barberDetailScreen.dart';
import 'package:app/screens/barberShopDescriptionScreen.dart';
import 'package:app/screens/productDetailScreen.dart';
import 'package:app/screens/serviceDetailScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  final int index;
  SearchScreen(this.index, {a, o}) : super();
  @override
  _SearchScreenState createState() => new _SearchScreenState(this.index);
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<Service> _serviceList = [];
  List<BarberShop> _barberShopList = [];
  List<PopularBarbers> _popularBarbersList = [];
  List<Product> _productList = [];
  TextEditingController _cSearch = new TextEditingController();
  String searchString = '';
  FocusNode _fSearch = new FocusNode();
  TabController? _tabController;
  int _currentIndex = 0;
  int index;
  int pageNumberBarberShop = 0;
  int pageNumberBarbers = 0;
  int pageNumberProducts = 0;
  int pageNumberServices = 0;

  ScrollController _scrollControllerBarberShop = ScrollController();
  ScrollController _scrollControllerBarbers = ScrollController();
  ScrollController _scrollControllerProducts = ScrollController();
  ScrollController _scrollControllerServices = ScrollController();
  bool _isBarberShopDataLoaded = false;
  bool _isBarbersDataLoaded = false;
  bool _isProductsDataLoaded = false;
  bool _isServicesDataLoaded = false;

  bool _isBarberShopRecordPending = true;
  bool _isBarbersRecordPending = true;
  bool _isProductsRecordPending = true;
  bool _isServicesRecordPending = true;

  bool _isBarberShopMoreDataLoaded = false;
  bool _isBarbersMoreDataLoaded = false;
  bool _isProductsMoreDataLoaded = false;
  bool _isServicesMoreDataLoaded = false;

  int pageNumber = 0;

  APIHelper? apiHelper;
  late BusinessRule br;

  _SearchScreenState(this.index) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: DefaultTabController(
        length: 4,
        initialIndex: _currentIndex,
        child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.lbl_search,
                  style: AppBarTheme.of(context).titleTextStyle),
            ),
            body: Column(
              children: [
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 13, right: 13),
                  child: Card(
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: Color(0xFF00547B),
                      enabled: true,
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                      controller: _cSearch,
                      focusNode: _fSearch,
                      onFieldSubmitted: (text) async {
                        searchString = text;

                        await _searchData();
                        setState(() {});
                      },
                      onChanged: (text) async {
                        if (text == "" || text.isEmpty) {
                          searchString = "";

                          await _searchData();
                        }

                        setState(() {});
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context)
                              .floatingActionButtonTheme
                              .backgroundColor,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            searchString = _cSearch.text;
                            await _searchData();
                            setState(() {});
                          },
                          child: Container(
                            width: 50,
                            decoration: BoxDecoration(
                                color: Color(0xFF00547B),
                                borderRadius: BorderRadius.circular(5)),
                            child: Icon(
                              Icons.arrow_circle_down_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        hintText: AppLocalizations.of(context)!.hnt_search,
                      ),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 13, right: 13),
                  child: TabBar(
                    indicatorColor: Color(0xFF00547B),
                    controller: _tabController,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    tabs: [
                      Text(AppLocalizations.of(context)!.lbl_barbershops),
                      Text(AppLocalizations.of(context)!.lbl_barbers),
                      Text(AppLocalizations.of(context)!.lbl_products),
                      Text(AppLocalizations.of(context)!.lbl_services),
                    ],
                    onTap: (index) {
                      _currentIndex = index;
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TabBarView(controller: _tabController, children: [
                      _barberShopView(),
                      _barbersList(),
                      _productListWidget(),
                      _servicesList()
                    ]),
                  ),
                )
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    _tabController!.removeListener(_tabControllerListener);
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
    super.initState();
    _currentIndex = index;
    _tabController =
        new TabController(initialIndex: _currentIndex, length: 4, vsync: this);
    _tabController!.addListener(_tabControllerListener);
    _init();
  }

  Widget _barberShopView() {
    return _isBarberShopDataLoaded
        ? _barberShopList.length > 0
            ? ListView.builder(
                controller: _scrollControllerBarberShop,
                itemCount: _barberShopList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => BarberShopDescriptionScreen(
                                  vendorId: _barberShopList[index].vendor_id,
                                )),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 13, right: 13),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: global.baseUrlForImage +
                                      _barberShopList[index].vendor_logo!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 85,
                                    width: 125,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: imageProvider)),
                                  ),
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: global.isRTL
                                        ? EdgeInsets.only(right: 8)
                                        : EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_barberShopList[index].vendor_name}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyLarge,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${_barberShopList[index].vendor_loc}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                  style: Theme.of(context).primaryTextTheme.titleMedium,
                ),
              )
        : _shimmer();
  }

  Widget _barbersList() {
    return _isBarbersDataLoaded
        ? _popularBarbersList.length > 0
            ? ListView.builder(
                controller: _scrollControllerBarbers,
                itemCount: _popularBarbersList.length,
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => BarberDetailScreen(
                                    _popularBarbersList[index].staff_id,
                                  )),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: global.isRTL
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  topRight: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                )
                              : BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  topRight: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: global.baseUrlForImage +
                                      _popularBarbersList[index].staff_image!,
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                          radius: 30,
                                          backgroundImage: imageProvider),
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: global.isRTL
                                        ? EdgeInsets.only(right: 18)
                                        : EdgeInsets.only(left: 18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_popularBarbersList[index].staff_name}',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .titleSmall,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .txt_specialist_in_hair_style,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                  style: Theme.of(context).primaryTextTheme.titleMedium,
                ),
              )
        : _shimmerBarberList();
  }

  _getNearByBarberShops() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isBarberShopRecordPending) {
          setState(() {
            _isBarberShopMoreDataLoaded = true;
          });

          if (_barberShopList.isEmpty) {
            pageNumberBarberShop = 1;
          } else {
            pageNumberBarberShop++;
          }
          await apiHelper!
              .getNearByBarberShops(
                  global.lat, global.lng, pageNumberBarberShop,
                  searchstring: searchString)
              .then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<BarberShop> _tList = result.recordList;
                if (_tList.isEmpty) {
                  _isBarberShopRecordPending = false;
                }

                _barberShopList.addAll(_tList);
                setState(() {
                  _isBarberShopMoreDataLoaded = false;
                });
              } else {}
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - searchScreen.dart - _getNearByBarberShops():" +
          e.toString());
    }
  }

  _getPopularBarbers() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isBarbersRecordPending) {
          setState(() {
            _isBarbersMoreDataLoaded = true;
          });

          if (_popularBarbersList.isEmpty) {
            pageNumberBarbers = 1;
          } else {
            pageNumberBarbers++;
          }
          await apiHelper!
              .getPopularBarbersList(
                  global.lat, global.lng, pageNumberBarbers, searchString)
              .then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<PopularBarbers> _tList = result.recordList;
                if (_tList.isEmpty) {
                  _isBarbersRecordPending = false;
                }

                _popularBarbersList.addAll(_tList);
                setState(() {
                  _isBarbersMoreDataLoaded = false;
                });
              } else {}
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - searchScreen.dart - _getPopularBarbers():" +
          e.toString());
    }
  }

  _getProducts() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isProductsRecordPending) {
          setState(() {
            _isProductsMoreDataLoaded = true;
          });

          if (_productList.isEmpty) {
            pageNumberProducts = 1;
          } else {
            pageNumberProducts++;
          }
          await apiHelper!
              .getProducts(
                  global.lat, global.lng, pageNumberProducts, searchString)
              .then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<Product> _tList = result.recordList;
                if (_tList.isEmpty) {
                  _isProductsRecordPending = false;
                }

                _productList.addAll(_tList);
                setState(() {
                  _isProductsMoreDataLoaded = false;
                });
              } else {}
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - searchScreen.dart - _getProducts():" + e.toString());
    }
  }

  _getServices() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isServicesRecordPending) {
          setState(() {
            _isServicesMoreDataLoaded = true;
          });

          if (_serviceList.isEmpty) {
            pageNumberServices = 1;
          } else {
            pageNumberServices++;
          }
          await apiHelper!
              .getServices(global.lat, global.lng, pageNumberServices,
                  searchstring: searchString)
              .then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<Service> _tList = result.recordList;
                if (_tList.isEmpty) {
                  _isServicesRecordPending = false;
                }

                _serviceList.addAll(_tList);
                setState(() {
                  _isServicesMoreDataLoaded = false;
                });
              } else {}
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - searchScreen.dart - _getServices():" + e.toString());
    }
  }

  _init() async {
    try {
      await _searchData();

      _scrollControllerBarberShop.addListener(() async {
        if (_scrollControllerBarberShop.position.pixels ==
                _scrollControllerBarberShop.position.maxScrollExtent &&
            !_isBarberShopMoreDataLoaded) {
          setState(() {
            _isBarberShopMoreDataLoaded = true;
          });
          await _getNearByBarberShops();
          setState(() {
            _isBarberShopMoreDataLoaded = false;
          });
        }
      });
      _isBarberShopDataLoaded = true;
      setState(() {});

      _scrollControllerBarbers.addListener(() async {
        if (_scrollControllerBarbers.position.pixels ==
                _scrollControllerBarbers.position.maxScrollExtent &&
            !_isBarbersMoreDataLoaded) {
          setState(() {
            _isBarbersMoreDataLoaded = true;
          });
          await _getPopularBarbers();
          setState(() {
            _isBarbersMoreDataLoaded = false;
          });
        }
      });
      _isBarbersDataLoaded = true;
      setState(() {});

      _scrollControllerProducts.addListener(() async {
        if (_scrollControllerProducts.position.pixels ==
                _scrollControllerProducts.position.maxScrollExtent &&
            !_isProductsMoreDataLoaded) {
          setState(() {
            _isProductsMoreDataLoaded = true;
          });
          await _getProducts();
          setState(() {
            _isProductsMoreDataLoaded = false;
          });
        }
      });
      _isProductsDataLoaded = true;
      setState(() {});

      _scrollControllerServices.addListener(() async {
        if (_scrollControllerServices.position.pixels ==
                _scrollControllerServices.position.maxScrollExtent &&
            !_isServicesMoreDataLoaded) {
          setState(() {
            _isServicesMoreDataLoaded = true;
          });
          await _getServices();
          setState(() {
            _isServicesMoreDataLoaded = false;
          });
        }
      });
      _isServicesDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - searchScreen.dart - _init():" + e.toString());
    }
  }

  Widget _productListWidget() {
    return _isProductsDataLoaded
        ? _productList.length > 0
            ? ListView.builder(
                itemCount: _productList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                                  _productList[index].id,
                                  isShowGoCartBtn:
                                      _productList[index].cart_qty != null &&
                                              _productList[index].cart_qty! > 0
                                          ? true
                                          : false,
                                )),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 13, right: 13),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: global.baseUrlForImage +
                                      _productList[index].product_image!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 85,
                                    width: 125,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: imageProvider)),
                                  ),
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: global.isRTL
                                        ? EdgeInsets.only(right: 18)
                                        : EdgeInsets.only(left: 18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_productList[index].product_name}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyLarge,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${_productList[index].description}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                  style: Theme.of(context).primaryTextTheme.titleMedium,
                ),
              )
        : _shimmer();
  }

  _searchData() async {
    try {
      _isBarberShopDataLoaded = false;
      _isServicesDataLoaded = false;
      _isBarbersDataLoaded = false;
      _isProductsDataLoaded = false;
      setState(() {});
      _barberShopList.clear();
      _popularBarbersList.clear();
      _productList.clear();
      _serviceList.clear();

      pageNumberBarberShop = 1;
      pageNumberBarbers = 1;
      pageNumberProducts = 1;
      pageNumberServices = 1;

      _isBarberShopRecordPending = true;
      _isBarbersRecordPending = true;
      _isProductsRecordPending = true;
      _isServicesRecordPending = true;
      await _getNearByBarberShops();
      _isBarberShopDataLoaded = true;
      await _getPopularBarbers();
      _isBarbersDataLoaded = true;
      await _getProducts();
      _isProductsDataLoaded = true;
      await _getServices();
      _isServicesDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - searchScreen.dart - _searchData():" + e.toString());
    }
  }

  Widget _servicesList() {
    return _isServicesDataLoaded
        ? _serviceList.length > 0
            ? ListView.builder(
                controller: _scrollControllerServices,
                itemCount: _serviceList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ServiceDetailScreen(
                                serviceName: _serviceList[index].service_name,
                                serviceImage:
                                    _serviceList[index].service_image)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 13, right: 13),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: global.baseUrlForImage +
                                      _serviceList[index].service_image!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 85,
                                    width: 125,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: imageProvider)),
                                  ),
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: global.isRTL
                                        ? EdgeInsets.only(right: 18)
                                        : EdgeInsets.only(left: 18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_serviceList[index].service_name}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyLarge,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                  style: Theme.of(context).primaryTextTheme.titleMedium,
                ),
              )
        : _shimmer();
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

  Widget _shimmerBarberList() {
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
                      CircleAvatar(
                        radius: 40,
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

  void _tabControllerListener() {
    try {
      setState(() {
        _currentIndex = _tabController!.index;
      });
    } catch (e) {
      print("Exception - searchScreen.dart - _tabControllerListener():" +
          e.toString());
    }
  }
}
