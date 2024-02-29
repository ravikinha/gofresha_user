import 'package:app/models/barberShopModel.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/screens/barberShopDescriptionScreen.dart';
import 'package:app/screens/bookAppointmentScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String? serviceName;
  final String? serviceImage;
  const ServiceDetailScreen({super.key, this.serviceName, this.serviceImage});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  // String? serviceName;
  // String? serviceImage;
  bool _isDataLoaded = false;
  int? selectedVendorId;
  List<BarberShop>? _barberShopList = [];
  APIHelper? apiHelper;
  late BusinessRule br;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (_barberShopList?.isEmpty ?? false) ? AppBar() : null,
        body: SafeArea(
          child: _isDataLoaded
              ? _barberShopList!.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          CachedNetworkImage(
                            imageUrl:
                                global.baseUrlForImage + widget.serviceImage!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                              height: MediaQuery.of(context).size.height * 0.24,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.transparent
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: global.isRTL
                                                ? EdgeInsets.only(
                                                    right: 8, top: 20)
                                                : EdgeInsets.only(
                                                    left: 8, top: 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.black26,
                                                  child: Center(
                                                    child: Icon(
                                                      global.isRTL
                                                          ? MdiIcons
                                                              .chevronRight
                                                          : MdiIcons
                                                              .chevronLeft,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ListTile(
                                        title: Text(
                                          widget.serviceName!,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .displayLarge,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(),
                              height: MediaQuery.of(context).size.height * 0.24,
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                  AppLocalizations.of(context)!.lbl_no_image),
                            ),
                          ),
                          Expanded(
                              child: ListView.separated(
                                  padding: EdgeInsets.only(
                                      left: 3.5.w, right: 3.5.w, top: 2.5.h),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 2.5.h);
                                  },
                                  itemCount: _barberShopList!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      shape: selectedVendorId != null &&
                                              selectedVendorId ==
                                                  _barberShopList![index]
                                                      .vendor_id
                                          ? RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 2))
                                          : null,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (selectedVendorId ==
                                                        _barberShopList![index]
                                                            .vendor_id) {
                                                      selectedVendorId = null;
                                                    } else {
                                                      selectedVendorId =
                                                          _barberShopList![
                                                                  index]
                                                              .vendor_id;
                                                    }

                                                    setState(() {});
                                                  },
                                                  child: CachedNetworkImage(
                                                    imageUrl: global
                                                            .baseUrlForImage +
                                                        _barberShopList![index]
                                                            .vendor_logo!,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 80,
                                                      width: 90,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  imageProvider)),
                                                      child: selectedVendorId !=
                                                                  null &&
                                                              selectedVendorId ==
                                                                  _barberShopList![
                                                                          index]
                                                                      .vendor_id
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Icon(
                                                                Icons.check,
                                                                color: Color(
                                                                    0xFF171D2C),
                                                                size: 45,
                                                              ),
                                                            )
                                                          : null,
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
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BarberShopDescriptionScreen(
                                                                  vendorId: _barberShopList![
                                                                          index]
                                                                      .vendor_id)),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: global.isRTL
                                                        ? EdgeInsets.only(
                                                            right: 5)
                                                        : EdgeInsets.only(
                                                            left: 5),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 6),
                                                          child: Text(
                                                            '${_barberShopList![index].vendor_name}',
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .titleSmall,
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              size: 20,
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  150,
                                                              child: Text(
                                                                '${_barberShopList![index].vendor_loc}',
                                                                style: Theme.of(
                                                                        context)
                                                                    .primaryTextTheme
                                                                    .titleMedium,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })),
                        ])
                  : Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .txt_nearby_shopw_will_shown_here,
                        style: Theme.of(context).primaryTextTheme.titleSmall,
                      ),
                    )
              : _shimmer(),
        ),
        bottomNavigationBar: _barberShopList!.length > 0 &&
                selectedVendorId != null
            ? SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                          color: Color(0xFF00547B),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => BookAppointmentScreen(
                                        selectedVendorId,
                                      )),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.lbl_book_now,
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              )
            : null);
  }

  @override
  void initState() {
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
    super.initState();
    _init();
  }

  _getSalonListForServices() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!
            .getSalonListForServices(global.lat, global.lng, widget.serviceName)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              _barberShopList = result.recordList;
            } else {
              showSnackBar(
                  context: context,
                  key: _scaffoldKey,
                  snackBarMessage: result.message.toString());
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print(
          "Exception - serviceDetailScreen.dart - _getSalonListForServices():" +
              e.toString());
    }
  }

  _init() async {
    try {
      await _getSalonListForServices();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - serviceDetailScreen.dart - _init():" + e.toString());
    }
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 140,
              child: Card(margin: EdgeInsets.only(top: 5, bottom: 15)),
            ),
            ListView.builder(
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
                            child: Card(
                                margin: EdgeInsets.only(top: 5, bottom: 5)),
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
          ],
        ),
      ),
    );
  }
}
