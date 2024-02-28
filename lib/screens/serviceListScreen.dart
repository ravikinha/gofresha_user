// ignore_for_file: deprecated_member_use

import 'package:app/models/businessLayer/apiHelper.dart';
import 'package:app/models/businessLayer/businessRule.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/serviceModel.dart';
import 'package:app/screens/searchScreen.dart';
import 'package:app/screens/serviceDetailScreen.dart';
import 'package:app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class ServiceListScreen extends StatefulWidget {
  ServiceListScreen({a, o}) : super();
  @override
  _ServiceListScreenState createState() => new _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<Service> _serviceList = [];
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  ScrollController _scrollController = ScrollController();
  int pageNumber = 0;
  APIHelper? apiHelper;
  late BusinessRule br;
  _ServiceListScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.lbl_services,
                style: AppBarTheme.of(context).titleTextStyle),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchScreen(3)),
                    );
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          body: _isDataLoaded
              ? _serviceList.length > 0
                  ? ListView.builder(
                      controller: _scrollController,
                      physics: ClampingScrollPhysics(),
                      itemCount: _serviceList.length,
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
                                      builder: (context) => ServiceDetailScreen(
                                            serviceName: _serviceList[index]
                                                .service_name,
                                            serviceImage: _serviceList[index]
                                                .service_image,
                                          )),
                                );
                              },
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: global.baseUrlForImage +
                                              _serviceList[index]
                                                  .service_image!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: 85,
                                            width: 125,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: imageProvider)),
                                          ),
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
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
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .subtitle2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              Icon(Icons.keyboard_arrow_right),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    )
                  : Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .txt_service_will_shown_here,
                        style: Theme.of(context).primaryTextTheme.subtitle2,
                      ),
                    )
              : _shimmer()),
    );
  }

  @override
  void initState() {
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
    super.initState();
    _init();
  }

  _getServices() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });

          if (_serviceList.isEmpty) {
            pageNumber = 1;
          } else {
            pageNumber++;
          }
          await apiHelper!
              .getServices(global.lat, global.lng, pageNumber)
              .then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<Service> _tList = result.recordList;

                if (_tList.isEmpty) {
                  _isRecordPending = false;
                }

                _serviceList.addAll(_tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              } else {
                _serviceList = [];
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - serviceListScreen.dart - _getServices():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getServices();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getServices();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - serviceListScreen.dart - _init():" + e.toString());
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
            itemCount: 8,
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
