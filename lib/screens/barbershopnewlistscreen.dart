// ignore_for_file: deprecated_member_use

import 'package:app/models/barberShopModel.dart';
import 'package:app/models/businessLayer/apiHelper.dart';
import 'package:app/models/businessLayer/businessRule.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/barber_list_item.dart';
import '../widgets/widgets.dart';

class BarberShopNewListScreen extends StatefulWidget {
  const BarberShopNewListScreen({super.key});

  @override
  State<BarberShopNewListScreen> createState() => _BarberShopNewListScreenState();
}

class _BarberShopNewListScreenState extends State<BarberShopNewListScreen> {
  APIHelper? apiHelper;
  late BusinessRule br;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<BarberShop> _barberShopList = [];
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  ScrollController _scrollController = ScrollController();
  int pageNumber = 0;
  _BarberShopNewListScreenState() : super();

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

  _getNearByBarberShops() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });

          if (_barberShopList.isEmpty) {
            pageNumber = 1;
          } else {
            pageNumber++;
          }
          await apiHelper!
              .getNearByBarberShops(global.lat, global.lng, pageNumber)
              .then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<BarberShop> _tList = result.recordList;

                if (_tList.isEmpty) {
                  _isRecordPending = false;
                }

                _barberShopList.addAll(_tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              } else {
                _barberShopList = [];
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - barberShopListScreen.dart - _getNearByBarberShops():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getNearByBarberShops();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getNearByBarberShops();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - barberShopListScreen.dart - _init():" + e.toString());
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
            itemCount: 12,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          AppLocalizations.of(context)!.lbl_barber_shop,
        ),
      ),
      body: SafeArea(
        child: _isDataLoaded
            ? _barberShopList.length > 0
                ? ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 2.0.h,
                      );
                    },
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w),
                    itemCount: _barberShopList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return BarberListItem(
                        barberShop: _barberShopList[index],
                      );
                    },
                  )
                : Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .txt_near_by_barbershop_list_will_shown_here,
                      style: Theme.of(context).primaryTextTheme.subtitle2,
                      textAlign: TextAlign.center,
                    ),
                  )
            : _shimmer(),
      ),
    );
  }
}
