// ignore_for_file: deprecated_member_use

import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/popularBarbersModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class BarberDetailScreen extends StatefulWidget {
  final int? staffId;

  BarberDetailScreen(this.staffId, {a, o}) : super();

  @override
  _BarberDetailScreenState createState() =>
      new _BarberDetailScreenState(this.staffId);
}

class _BarberDetailScreenState extends State<BarberDetailScreen> {
  String? vendorType;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  int? staffId;
  PopularBarbers? _barberDetails;
  bool _isDataLoaded = false;
  APIHelper? apiHelper;
  late BusinessRule br;
  _BarberDetailScreenState(this.staffId) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: _isDataLoaded
              ? SingleChildScrollView(
                  child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: global.baseUrlForImage +
                                      _barberDetails!.vendor_logo!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 130,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: imageProvider)),
                                  ),
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                SizedBox(
                                  height: 70,
                                )
                              ],
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
                                        backgroundColor: Colors.black26,
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
                                        backgroundColor: Colors.black26,
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
                          Positioned(
                            top: 70,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.blue,
                              child: CachedNetworkImage(
                                imageUrl: global.baseUrlForImage +
                                    _barberDetails!.staff_image!,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 57,
                                  backgroundImage: imageProvider,
                                ),
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          )
                        ],
                      ),
                      Text('${_barberDetails!.staff_name}',
                          style: Theme.of(context).primaryTextTheme.titleSmall),
                      Text(
                        '${_barberDetails!.salon_name}',
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      ),
                      RatingBar.builder(
                        initialRating: _barberDetails!.rating.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 15,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        ignoreGestures: true,
                        updateOnDrag: false,
                        onRatingUpdate: (rating) {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.lbl_about_me,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleSmall),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_barberDetails!.staff_description}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.lbl_opening_hours,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleSmall),
                          subtitle: Padding(
                              padding: EdgeInsets.only(top: 6.0),
                              child: _weekTimeSlotWidget()),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(),
                        child: ListTile(
                            title: Text('Type',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleSmall),
                            subtitle: Text(
                              '$vendorType',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: ListTile(
                          title: Text(AppLocalizations.of(context)!.lbl_address,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleSmall),
                          subtitle: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 6.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.location_on,
                                    size: 20,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${_barberDetails!.vendor_loc}",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      _barberDetails!.review.length > 0
                          ? Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: ListTile(
                                title: Text(
                                    AppLocalizations.of(context)!.lbl_Reviews,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleSmall),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 6.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            _barberDetails!.review.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                              margin: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 1),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl: global
                                                                    .baseUrlForImage +
                                                                _barberDetails!
                                                                    .review[
                                                                        index]
                                                                    .image!,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                CircleAvatar(
                                                              radius: 30,
                                                              backgroundColor:
                                                                  Colors.yellow,
                                                              backgroundImage:
                                                                  imageProvider,
                                                            ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                Center(
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                CircleAvatar(
                                                                    radius: 30,
                                                                    child: Icon(
                                                                        Icons
                                                                            .people)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 15),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${_barberDetails!.review[index].name}',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .primaryTextTheme
                                                                      .titleSmall,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      br.calculateDurationDiff(_barberDetails!
                                                                          .review[
                                                                              index]
                                                                          .created_at)!,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .primaryTextTheme
                                                                          .titleMedium,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10),
                                                                      child: RatingBar
                                                                          .builder(
                                                                        initialRating: _barberDetails!
                                                                            .review[index]
                                                                            .rating
                                                                            .toDouble(),
                                                                        minRating:
                                                                            1,
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        allowHalfRating:
                                                                            true,
                                                                        itemCount:
                                                                            5,
                                                                        itemSize:
                                                                            15,
                                                                        itemPadding:
                                                                            EdgeInsets.symmetric(horizontal: 1.0),
                                                                        itemBuilder:
                                                                            (context, _) =>
                                                                                Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              Colors.amber,
                                                                        ),
                                                                        ignoreGestures:
                                                                            true,
                                                                        updateOnDrag:
                                                                            false,
                                                                        onRatingUpdate:
                                                                            (rating) {},
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      _barberDetails!
                                                                  .review[index]
                                                                  .description ==
                                                              null
                                                          ? ''
                                                          : '${_barberDetails!.review[index].description}',
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .titleMedium,
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        }),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                      Row(
                        children: [
                          Padding(
                            padding: global.isRTL
                                ? EdgeInsets.only(right: 10)
                                : EdgeInsets.only(left: 10),
                            child: Text(
                              '${_barberDetails!.rating}',
                              style:
                                  Theme.of(context).primaryTextTheme.bodySmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    left: 15,
                                  ),
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .lbl_overall_rating,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleLarge),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                            _barberDetails!.rating.toDouble(),
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
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Text(
                                          'Good(${_barberDetails!.review.length})',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .titleMedium,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ))
              : _shimmer(),
        ),
      ),
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

  _getBarbersDescription() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getBarbersDescription(staffId).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _barberDetails = result.recordList;
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
      print("Exception - barberDetailScreen.dart - _getBarbersDescription():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getBarbersDescription();
      _isDataLoaded = true;
      setState(() {});
      if (_barberDetails!.type == 1) {
        vendorType = 'Male';
      }
      if (_barberDetails!.type == 2) {
        vendorType = 'Female';
      }
      if (_barberDetails!.type == 3) {
        vendorType = 'Unisex';
      }
    } catch (e) {
      print("Exception - barberDetailScreen.dart - _init():" + e.toString());
    }
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 100,
                    child: Card(
                      margin: EdgeInsets.all(8),
                    ),
                  ),
                  CircleAvatar(
                    radius: 40,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 30,
                    child: Card(
                      margin: EdgeInsets.all(4),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 30,
                    child: Card(margin: EdgeInsets.all(4)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 30,
                    child: Card(margin: EdgeInsets.all(4)),
                  ),
                  ListTile(
                    title: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 45,
                        child: Card()),
                    subtitle: Padding(
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
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height: 30,
                                      child: Card(margin: EdgeInsets.all(8)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height: 30,
                                  child: Card(margin: EdgeInsets.all(8)),
                                )
                              ],
                            );
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 40,
                          child: Card()),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  _weekTimeSlotWidget() {
    try {
      return ListView.builder(
          itemCount: _barberDetails!.weekly_time.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Text(
                        "${_barberDetails!.weekly_time[i].days}",
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${_barberDetails!.weekly_time[i].open_hour} - ${_barberDetails!.weekly_time[i].close_hour}",
                  style: Theme.of(context).primaryTextTheme.titleMedium,
                )
              ],
            );
          });
    } catch (e) {
      print("Exception - barberDetailScreen.dart - _weekTimeSlotWidget():" +
          e.toString());
    }
  }
}
