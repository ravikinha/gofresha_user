import 'package:app/dialogs/openImageDialog.dart';
import 'package:app/models/barberShopDescModel.dart';
import 'package:app/models/businessLayer/apiHelper.dart';
import 'package:app/models/businessLayer/businessRule.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/screens/barberDetailScreen.dart';
import 'package:app/screens/bookAppointmentScreen.dart';
import 'package:app/screens/productDetailScreen.dart';
import 'package:app/screens/serviceDetailScreen.dart';
import 'package:app/screens/signInScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/widgets.dart';

class BarberShopDescriptionScreen extends StatefulWidget {
  final int? vendorId;
  const BarberShopDescriptionScreen({super.key, this.vendorId});

  @override
  State<BarberShopDescriptionScreen> createState() =>
      _BarberShopDescriptionScreenState(vendorId);
}

class _BarberShopDescriptionScreenState
    extends State<BarberShopDescriptionScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  BarberShopDesc? _barberShopDesc;
  late BusinessRule br;
  int? vendorId;
  TabController? _tabController;
  int _currentIndex = 0;
  bool _isDataLoaded = false;
  APIHelper? apiHelper;
  // late BusinessRule br;

  @override
  Widget build(BuildContext context) {
    return (_barberShopDesc != null)
        ? DefaultTabController(
            length: 5,
            initialIndex: _currentIndex,
            child: Scaffold(
                key: _scaffoldKey,
                body: SafeArea(
                  child: _isDataLoaded
                      ? _barberShopDesc != null
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: global.baseUrlForImage +
                                      _barberShopDesc!.vendor_logo!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.24,
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.24,
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
                                        global.isRTL
                                            ? Positioned(
                                                right: 8,
                                                top: 20,
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
                                                          MdiIcons.chevronRight,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Positioned(
                                                left: 8,
                                                top: 20,
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
                                                          MdiIcons.chevronLeft,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ListTile(
                                          title: Text(
                                            "${_barberShopDesc!.salon_name}",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .displayLarge,
                                          ),
                                          subtitle: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 15,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(
                                                width: 180,
                                                child: Text(
                                                  "${_barberShopDesc!.vendor_loc}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .displayMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                _barberShopDesc!.rating != null
                                                    ? "${_barberShopDesc!.rating}"
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .lbl_no_rating,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .displayMedium,
                                              ),
                                              _barberShopDesc!.rating != null
                                                  ? RatingBar.builder(
                                                      initialRating:
                                                          _barberShopDesc!
                                                              .rating!,
                                                      minRating: 0,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 15,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 1.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      ignoreGestures: true,
                                                      updateOnDrag: false,
                                                      onRatingUpdate:
                                                          (rating) {},
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.24,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/s1.jpg',
                                            ))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            BackButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                        ListTile(
                                          title: Text(
                                            "${_barberShopDesc!.salon_name}",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .displayLarge,
                                          ),
                                          subtitle: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 15,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  "${_barberShopDesc!.vendor_loc}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .displayMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                _barberShopDesc!.rating != null
                                                    ? "${_barberShopDesc!.rating}"
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .lbl_no_rating,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .displayMedium,
                                              ),
                                              _barberShopDesc!.rating != null
                                                  ? RatingBar.builder(
                                                      initialRating:
                                                          _barberShopDesc!
                                                              .rating!,
                                                      minRating: 0,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 15,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 1.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      ignoreGestures: true,
                                                      updateOnDrag: false,
                                                      onRatingUpdate:
                                                          (rating) {},
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50.0,
                                  color: Theme.of(context)
                                      .bottomNavigationBarTheme
                                      .backgroundColor,
                                  // height: 35,
                                  alignment: Alignment.center,
                                  child: TabBar(
                                    indicatorColor: Color(0xFF00547B),
                                    labelColor: Color(0xFF00547B),
                                    unselectedLabelColor: Colors.white,
                                    controller: _tabController,
                                    dividerColor: Colors.transparent,
                                    indicatorWeight: 0.1,
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    tabs: [
                                      Text(
                                        AppLocalizations.of(context)!.lbl_about,
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      ),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .lbl_services,
                                          style:
                                              TextStyle(fontFamily: 'Poppins')),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .lbl_barbers,
                                          style:
                                              TextStyle(fontFamily: 'Poppins')),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .lbl_Review,
                                          style:
                                              TextStyle(fontFamily: 'Poppins')),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .lbl_gallery,
                                          style:
                                              TextStyle(fontFamily: 'Poppins')),
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
                                    child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          _aboutWidget(),
                                          _serviceWidget(),
                                          _barberWidget(),
                                          _reviewWidget(),
                                          _galleryWidget()
                                        ]),
                                  ),
                                )
                              ],
                            )
                          : Center(
                              child: Text("BarberDescription not available"),
                            )
                      : _shimmer(),
                ),
                bottomNavigationBar: _isDataLoaded &&
                        (_currentIndex == 0 || _currentIndex == 1) &&
                        _barberShopDesc!.services.length > 0
                    ? Padding(
                        padding: EdgeInsets.only(
                            bottom: 1.5.h, left: 4.5.w, right: 4.5.w),
                        child: MaterialButton(
                          minWidth: 100.0.w,
                          color: Color(0xFF00547B),
                          onPressed: () {
                            global.user?.id == null
                                ? Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => SignInScreen()),
                                  )
                                : Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BookAppointmentScreen(
                                              vendorId,
                                            )),
                                  );
                          },
                          child: Text(
                            _currentIndex == 0
                                ? AppLocalizations.of(context)!
                                    .lbl_book_appointment
                                : AppLocalizations.of(context)!.lbl_book_now,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : null))
        : Scaffold(
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Loading...')
              ],
            )),
          );
  }

  _BarberShopDescriptionScreenState(this.vendorId) : super();

  dialogToOpenImage({int? index}) {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return OpenImageDialog(
              index: index,
              barberShopDesc: _barberShopDesc,
            );
          });
    } catch (e) {
      print("Exception - base.dart - dialogToOpenImage() " + e.toString());
    }
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
    _tabController =
        new TabController(initialIndex: _currentIndex, length: 5, vsync: this);
    _tabController!.addListener(_tabControllerListener);
    _init();
  }

  Widget _aboutWidget() {
    try {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.lbl_description,
                  style: Theme.of(context).primaryTextTheme.titleSmall),
              subtitle: Text(
                "${_barberShopDesc!.description}",
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(left: 15, right: 15),
            //   decoration: BoxDecoration(
            //       border: Border.all(width: 1),
            //       borderRadius: BorderRadius.all(Radius.circular(5))),
            //   padding: EdgeInsets.only(top: 10.0),
            //   child: ListTile(
            //     title: Row(
            //       children: [
            //         Expanded(
            //             child: Divider(
            //           color: Colors.black,
            //         )),
            //         Padding(
            //           padding: const EdgeInsets.only(right: 10, left: 10),
            //           child: Text(
            //               AppLocalizations.of(context)!.lbl_opening_hours,
            //               textAlign: TextAlign.center,
            //               style: Theme.of(context).primaryTextTheme.titleSmall),
            //         ),
            //         Expanded(
            //             child: Divider(
            //           color: Colors.black,
            //         ))
            //       ],
            //     ),
            //     subtitle: Padding(
            //       padding: EdgeInsets.only(top: 6.0),
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           _weekTimeSlotWidget(),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 1.0, left: 4.5.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context)!.lbl_contact_saloon,
                    style: Theme.of(context).primaryTextTheme.titleSmall),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 4.5.w, right: 4.5.w),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: _makePhoneCall,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4.5.w,
                          ),
                          Text("Call"),
                        ],
                      ),
                      height: 40.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 4.5.w,
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: _openWhatsApp,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4.5.w,
                          ),
                          Text("WhatsApp"),
                        ],
                      ),
                      height: 40.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.lbl_products,
                    style: Theme.of(context).primaryTextTheme.titleSmall),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: SizedBox(
                  height: 95,
                  child: Align(
                      alignment: global.isRTL
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: _products())),
            ),
            ListTile(
              title: Text(
                  AppLocalizations.of(context)!.txt_similar_barbershop_nearby,
                  style: Theme.of(context).primaryTextTheme.titleSmall),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0, left: 10),
              child: SizedBox(
                  height: 150,
                  child: Align(
                      alignment: global.isRTL
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: _similarBarberShop())),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.lbl_barbers,
                  style: Theme.of(context).primaryTextTheme.titleSmall),
              trailing: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () {
                    _tabController!.animateTo(2);
                  },
                  child: Text(AppLocalizations.of(context)!.lbl_view_all,
                      style: Theme.of(context).primaryTextTheme.headlineSmall)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: SizedBox(
                  height: 110,
                  child: Align(
                      alignment: global.isRTL
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: _popularBarbers())),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.lbl_gallery,
                  style: Theme.of(context).primaryTextTheme.titleSmall),
              trailing: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () {
                    _tabController!.animateTo(4);
                  },
                  child: Text(AppLocalizations.of(context)!.lbl_view_all,
                      style: Theme.of(context).primaryTextTheme.headlineSmall)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: SizedBox(
                  height: 100,
                  child: Align(
                      alignment: global.isRTL
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: _gallery())),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.lbl_Reviews,
                  style: Theme.of(context).primaryTextTheme.titleSmall),
              trailing: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () {
                    _tabController!.animateTo(3);
                  },
                  child: Text(AppLocalizations.of(context)!.lbl_view_all,
                      style: Theme.of(context).primaryTextTheme.headlineSmall)),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0, left: 10),
              child: SizedBox(
                  height: 130,
                  child: Align(
                      alignment: global.isRTL
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: _review())),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Exception - barberShopDescriptionScreen.dart - _aboutWidget(): " +
          e.toString());

      return SizedBox();
    }
  }

  Widget _barberWidget() {
    try {
      return _barberShopDesc!.barber.length > 0
          ? ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: _barberShopDesc!.barber.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 13, right: 13),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => BarberDetailScreen(
                                  _barberShopDesc!.barber[index].staff_id,
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
                                    _barberShopDesc!.barber[index].staff_image!,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                        radius: 30,
                                        backgroundImage: imageProvider),
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
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
                                        '${_barberShopDesc!.barber[index].staff_name}',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleSmall,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${_barberShopDesc!.barber[index].staff_description}',
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
            );
    } catch (e) {
      print(
          "Exception - barberShopDescriptionScreen.dart - _barberWidget() : " +
              e.toString());
      return SizedBox();
    }
  }

  Widget _gallery() {
    return _barberShopDesc!.gallery.length > 0
        ? ListView.builder(
            itemCount: _barberShopDesc!.gallery.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  dialogToOpenImage(index: index);
                },
                child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CachedNetworkImage(
                          imageUrl: global.baseUrlForImage +
                              _barberShopDesc!.gallery[index].image!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 90,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider)),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ],
                    )),
              );
            })
        : Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
          );
  }

  Widget _galleryWidget() {
    try {
      return _barberShopDesc!.gallery.length > 0
          ? GridView.count(
              padding: EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 1),
              crossAxisCount: 3,
              children: List.generate(
                _barberShopDesc!.gallery.length,
                (index) => GestureDetector(
                  onTap: () {
                    dialogToOpenImage(index: index);
                  },
                  child: CachedNetworkImage(
                    imageUrl: global.baseUrlForImage +
                        _barberShopDesc!.gallery[index].image!,
                    imageBuilder: (context, imageProvider) => Container(
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.cover, image: imageProvider)),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1, color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            );
    } catch (e) {
      print(
          "Exception - barberShopDescriptionScreen.dart - _galleryWidget() : " +
              e.toString());
      return SizedBox();
    }
  }

  _getBarberShopDescription() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!
            .getBarberShopDescription(vendorId, global.lat, global.lng)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              _barberShopDesc = result.recordList;
            } else {
              showSnackBar(
                  context: context,
                  key: _scaffoldKey,
                  snackBarMessage: '${result.message}');
            }
          } else {
            _barberShopDesc = null;
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print(
          "Exception - barberShopDescriptionScreen.dart - _getBarberShopDescription():" +
              e.toString());
    }
  }

  _init() async {
    try {
      await _getBarberShopDescription();

      _isDataLoaded = true;

      setState(() {});
    } catch (e) {
      print("Exception - barberShopDescriptionScreen.dart - _init():" +
          e.toString());
    }
  }

  Widget _popularBarbers() {
    return _barberShopDesc!.barber.length > 0
        ? Padding(
            padding: EdgeInsets.only(left: 7, right: 7),
            child: ListView.builder(
                itemCount: _barberShopDesc!.barber.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => BarberDetailScreen(
                                  _barberShopDesc!.barber[index].staff_id,
                                )),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: SizedBox(
                        width: 80,
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: global.baseUrlForImage +
                                  _barberShopDesc!.barber[index].staff_image!,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                      radius: 35,
                                      backgroundImage: imageProvider),
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                radius: 35,
                                child: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Text(
                                _barberShopDesc!.barber[index].staff_name!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
          );
  }

  Widget _products() {
    return _barberShopDesc!.products.length > 0
        ? ListView.builder(
            itemCount: _barberShopDesc!.products.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                              _barberShopDesc!.products[index].id,
                              isShowGoCartBtn:
                                  _barberShopDesc!.products[index].cart_qty !=
                                              null &&
                                          _barberShopDesc!
                                                  .products[index].cart_qty! >
                                              0
                                      ? true
                                      : false,
                            )),
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CachedNetworkImage(
                          imageUrl: global.baseUrlForImage +
                              _barberShopDesc!.products[index].product_image!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 90,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider)),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        SizedBox(
                            width: 80,
                            child: Text(
                              '${_barberShopDesc!.products[index].product_name}',
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            )),
                      ],
                    )),
              );
            })
        : Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
          );
  }

  Widget _review() {
    return _barberShopDesc!.review.length > 0
        ? Padding(
            padding: EdgeInsets.only(left: 7, right: 7),
            child: ListView.builder(
                itemCount: _barberShopDesc!.review.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: SizedBox(
                        width: 85,
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _barberShopDesc!.review[index].image != 'N/A'
                                ? CachedNetworkImage(
                                    imageUrl: global.baseUrlForImage +
                                        _barberShopDesc!.review[index].image!,
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                            radius: 35,
                                            backgroundImage: imageProvider),
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                      radius: 35,
                                      child: Icon(Icons.person),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 31,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person),
                                    ),
                                  ),
                            Text(
                              _barberShopDesc!.review[index].name!,
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyLarge,
                            ),
                            Padding(
                              padding: EdgeInsets.only(),
                              child: RatingBar.builder(
                                initialRating: _barberShopDesc!
                                    .review[index].rating
                                    .toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 15,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                ignoreGestures: true,
                                updateOnDrag: false,
                                onRatingUpdate: (rating) {},
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
          );
  }

  Widget _reviewWidget() {
    try {
      return _barberShopDesc!.review.length > 0
          ? ListView.builder(
              itemCount: _barberShopDesc!.review.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _barberShopDesc!.review[index].image != 'N/A'
                                    ? CachedNetworkImage(
                                        imageUrl: global.baseUrlForImage +
                                            _barberShopDesc!
                                                .review[index].image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 30,
                                          backgroundImage: imageProvider,
                                        ),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                          radius: 31,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 31,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.person),
                                        ),
                                      ),
                                Padding(
                                  padding: global.isRTL
                                      ? EdgeInsets.only(right: 15)
                                      : EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_barberShopDesc!.review[index].name}',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleSmall,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            br.calculateDurationDiff(
                                                _barberShopDesc!
                                                    .review[index].created_at)!,
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .titleMedium,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: RatingBar.builder(
                                              initialRating: _barberShopDesc!
                                                  .review[index].rating
                                                  .toDouble(),
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 1.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              ignoreGestures: true,
                                              updateOnDrag: false,
                                              onRatingUpdate: (rating) {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${_barberShopDesc!.review[index].description}',
                                        textAlign: TextAlign.justify,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
              })
          : Center(
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            );
    } catch (e) {
      print(
          "Exception - barberShopDescriptionScreen.dart - _reviewWidget() : " +
              e.toString());
      return SizedBox();
    }
  }

  Widget _serviceWidget() {
    try {
      return _barberShopDesc!.services.length > 0
          ? ListView.builder(
              itemCount: _barberShopDesc!.services.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ServiceDetailScreen(
                                serviceName: _barberShopDesc!
                                    .services[index].service_name,
                                serviceImage: _barberShopDesc!
                                    .services[index].service_image,
                              )),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 0, bottom: 0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: Colors.grey[400]!, width: 0.5),
                          borderRadius: BorderRadius.circular(3)),
                      color: Color(0xFFEEEEEE),
                      child: ExpansionTile(
                        onExpansionChanged: (val) {
                          setState(() {});
                        },
                        backgroundColor: Colors.transparent,
                        collapsedBackgroundColor: Colors.transparent,
                        tilePadding: EdgeInsets.only(left: 16, right: 27),
                        textColor: Color(0xFFFEDAA3A),
                        collapsedTextColor: Color(0xFFF543520),
                        iconColor: Color(0xFF565656),
                        collapsedIconColor: Color(0xFF565656),
                        title: Text(
                            _barberShopDesc!.services[index].service_name!,
                            style:
                                Theme.of(context).primaryTextTheme.titleSmall),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _barberShopDesc!
                                  .services[index].service_type.length,
                              itemBuilder: (BuildContext context, int i) {
                                int? hr;
                                hr = _barberShopDesc!
                                    .services[index].service_type[i].time;

                                return Column(
                                  children: [
                                    ListTile(
                                        visualDensity:
                                            VisualDensity(vertical: -3),
                                        tileColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.grey[100]!,
                                              width: 0.5),
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                              '${_barberShopDesc!.services[index].service_type[i].varient}',
                                              textAlign: TextAlign.justify,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .titleMedium),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: 70,
                                                child: Text('$hr m',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF898A8D),
                                                        fontWeight:
                                                            FontWeight.w400))),
                                            VerticalDivider(
                                              color: Color(0xFF898A8D),
                                              indent: 13,
                                              endIndent: 13,
                                              thickness: 1,
                                            ),
                                            Container(
                                                width: 60,
                                                child: Text(
                                                    ' ${global.currency.currency_sign} ${_barberShopDesc!.services[index].service_type[i].price}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w400)))
                                          ],
                                        )),
                                  ],
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            );
    } catch (e) {
      print(
          "Exception - barberShopDescriptionScreen.dart - _serviceWidget(): " +
              e.toString());
      return SizedBox();
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
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 5,
                                child: Card(),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 30,
                                child: Card(margin: EdgeInsets.all(8)),
                              )
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 30,
                            child: Card(margin: EdgeInsets.all(8)),
                          )
                        ],
                      );
                    }),
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

  Widget _similarBarberShop() {
    return _barberShopDesc!.similar_salons.length > 0
        ? ListView.builder(
            itemCount: _barberShopDesc!.similar_salons.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => BarberShopDescriptionScreen(
                              vendorId: _barberShopDesc!
                                  .similar_salons[index].vendor_id,
                            )),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 6, right: 6, bottom: 6),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: global.baseUrlForImage +
                              _barberShopDesc!
                                  .similar_salons[index].vendor_logo!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 180,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider)),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        SizedBox(
                          width: 180,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 7, right: 7, bottom: 5, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                      '${_barberShopDesc!.similar_salons[index].vendor_name}',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyLarge,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        '${_barberShopDesc!.similar_salons[index].rating}',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .bodyLarge),
                                    Icon(Icons.star,
                                        size: 13, color: Colors.yellow[600])
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    '${_barberShopDesc!.similar_salons[index].vendor_loc}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
        : Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
          );
  }

  void _tabControllerListener() {
    setState(() {
      _currentIndex = _tabController!.index;
    });
  }

  _weekTimeSlotWidget() {
    try {
      return ListView.builder(
          itemCount: _barberShopDesc!.weekly_time.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 6.0),
                          child: Text(
                            "${_barberShopDesc!.weekly_time[i].days}",
                            style:
                                Theme.of(context).primaryTextTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${_barberShopDesc!.weekly_time[i].open_hour} - ${_barberShopDesc!.weekly_time[i].close_hour}",
                      style: Theme.of(context).primaryTextTheme.titleMedium,
                    )
                  ],
                ),
              ],
            );
          });
    } catch (e) {
      print(
          "Exception - barberShopDescriptionScreen.dart - _weekTimeSlotWidget():" +
              e.toString());
    }
  }

  _makePhoneCall() async {
    final String phoneNumber = 'tel:${_barberShopDesc?.vendor_phone ?? ''}';

    if (await canLaunchUrlString(phoneNumber)) {
      await launchUrlString(phoneNumber);
    }
  }

  _openWhatsApp() async {
    final String whatsAppURL = _barberShopDesc?.vendor_whatsapp ?? '';

    if (await canLaunchUrlString(whatsAppURL)) {
      launchUrlString(whatsAppURL);
    }
  }
}
