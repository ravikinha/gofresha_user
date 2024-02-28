import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/popularBarbersModel.dart';
import 'package:app/screens/barberDetailScreen.dart';
import 'package:app/screens/searchScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class BarberListScreen extends StatefulWidget {
  BarberListScreen({a, o}) : super();
  @override
  _BarberListScreenState createState() => new _BarberListScreenState();
}

class _BarberListScreenState extends State<BarberListScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<PopularBarbers> _popularBarbersList = [];
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  APIHelper? apiHelper;
  late BusinessRule br;
  ScrollController _scrollController = ScrollController();
  int pageNumber = 0;

  _BarberListScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Popular Salons',
                style: AppBarTheme.of(context).titleTextStyle),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SearchScreen(
                                1,
                              )),
                    );
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          body: _isDataLoaded
              ? _popularBarbersList.length > 0
                  ? ListView.builder(
                      controller: _scrollController,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: global.baseUrlForImage +
                                              _popularBarbersList[index]
                                                  .staff_image!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage:
                                                          imageProvider),
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
                                                  '${_popularBarbersList[index].staff_name}',
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .subtitle2,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${_popularBarbersList[index].vendor_name}',
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .subtitle1,
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
                            ));
                      },
                    )
                  : Center(
                      child: Text(
                        "POPULAR BARBER'S WILL BE SHOWN HERE",
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

  _getPopularBarbers() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });

          if (_popularBarbersList.isEmpty) {
            pageNumber = 1;
          } else {
            pageNumber++;
          }
          await apiHelper!
              .getPopularBarbersList(global.lat, global.lng, pageNumber, '')
              .then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<PopularBarbers> _tList = result.recordList;

                if (_tList.isEmpty) {
                  _isRecordPending = false;
                }

                _popularBarbersList.addAll(_tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              } else {
                _popularBarbersList = [];
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print(
          "Exception - barberListScreen.dart - _getServices():" + e.toString());
    }
  }

  _init() async {
    try {
      await _getPopularBarbers();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getPopularBarbers();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - barberListScreen.dart - _initFinal():" + e.toString());
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
}
