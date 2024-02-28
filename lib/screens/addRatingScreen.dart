import 'package:app/models/allBookingsModel.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/businessLayer/apiHelper.dart';
import '../models/businessLayer/businessRule.dart';
import '../widgets/widgets.dart';

class AddRatingScreen extends StatefulWidget {
  final AllBookings bookings;
  AddRatingScreen(this.bookings, {a, o}) : super();
  @override
  _AddRatingScreenState createState() =>
      new _AddRatingScreenState(this.bookings);
}

class _AddRatingScreenState extends State<AddRatingScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  AllBookings bookings;
  APIHelper? apiHelper;
  late BusinessRule br;
  var _cCommentShop = new TextEditingController();
  var _fCommentShop = new FocusNode();
  var _cCommentStaff = new TextEditingController();
  var _fCommentStaff = new FocusNode();
  double _shopRating = 0;
  double _staffRating = 0;
  _AddRatingScreenState(this.bookings) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Your Experience'),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Salon Name',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                    Text(
                      '${bookings.vendor_name}',
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Barber Name',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                    Text(
                      '${bookings.staff_name}',
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cart Id',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                    Text(
                      '${bookings.cart_id}',
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total amount',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                    Text(
                      '${global.currency.currency_sign} ${bookings.rem_price}',
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text("Rate Your Salon",
                  style: Theme.of(context).primaryTextTheme.headline6),
              SizedBox(
                height: 10,
              ),
              RatingBar.builder(
                initialRating: bookings.vendor_review != null
                    ? bookings.vendor_review!.rating!
                    : 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 25,
                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                updateOnDrag: false,
                onRatingUpdate: (rating) {
                  _shopRating = rating;
                  setState(() {});
                },
                tapOnlyMode: true,
              ),
              Container(
                height: 80,
                margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: TextFormField(
                  validator: (text) {
                    if (text!.isEmpty || text == '') {
                      return 'Write review';
                    }
                    return null;
                  },
                  maxLines: 5,
                  controller: _cCommentShop,
                  focusNode: _fCommentShop,
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: 'Comment',
                    contentPadding:
                        EdgeInsets.only(top: 10, left: 10, right: 10),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text("Rate Your Barber",
                  style: Theme.of(context).primaryTextTheme.headline6),
              SizedBox(
                height: 10,
              ),
              RatingBar.builder(
                initialRating: bookings.staff_review != null
                    ? bookings.staff_review!.rating!
                    : 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 25,
                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                updateOnDrag: false,
                onRatingUpdate: (rating) {
                  _staffRating = rating;
                  setState(() {});
                },
                tapOnlyMode: true,
              ),
              Container(
                height: 80,
                margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: TextFormField(
                  validator: (text) {
                    if (text!.isEmpty || text == '') {
                      return 'Write review';
                    }
                    return null;
                  },
                  maxLines: 5,
                  controller: _cCommentStaff,
                  textInputAction: TextInputAction.done,
                  focusNode: _fCommentStaff,
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: 'Comment',
                    contentPadding:
                        EdgeInsets.only(top: 10, left: 10, right: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if (_cCommentShop.text.isEmpty) {
                  _cCommentShop.text = "";
                }
                if (_cCommentStaff.text.isEmpty) {
                  _cCommentStaff.text = "";
                }

                if (_cCommentShop.text.isNotEmpty &&
                    _cCommentStaff.text.isNotEmpty) {
                  await _addSalonRating();
                  await _addStaffRating();
                  Navigator.of(context).pop();
                } else if (_cCommentShop.text.isNotEmpty) {
                  await _addSalonRating();
                  Navigator.of(context).pop();
                } else if (_cCommentStaff.text.isNotEmpty) {
                  await _addStaffRating();
                  Navigator.of(context).pop();
                } else if (_cCommentShop.text.isEmpty) {
                  showSnackBar(
                      context: context,
                      snackBarMessage: 'Please write your review for salon');
                } else if (_cCommentStaff.text.isEmpty) {
                  showSnackBar(
                      context: context,
                      snackBarMessage:
                          'Please write your review for salon staff');
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Submit Rating'),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _addSalonRating() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!
            .addSalonRating(global.user!.id, bookings.vendor_id, _shopRating,
                _cCommentShop.text)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              if (bookings.vendor_review == null) {
                bookings.vendor_review = new ReviewRating();
              }
              bookings.vendor_review!.rating = _shopRating;
              bookings.vendor_review!.description = _cCommentShop.text;
              setState(() {});
            } else if (result.status == "0") {
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - addRatingScreen.dart - _addSalonRating():" +
          e.toString());
    }
  }

  _addStaffRating() async {
    try {
      bool isConnected = await br.checkConnectivity();
      br = new BusinessRule(apiHelper);
      if (isConnected) {
        await apiHelper!
            .addStaffRating(global.user!.id, bookings.staff_id, _staffRating,
                _cCommentStaff.text)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              if (bookings.staff_review == null) {
                bookings.staff_review = new ReviewRating();
              }
              bookings.staff_review!.rating = _staffRating;
              bookings.staff_review!.description = _cCommentStaff.text;
              setState(() {});
            } else if (result.status == "0") {
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print("Exception - addRatingScreen.dart - _addStaffRating():" +
          e.toString());
    }
  }

  _init() {
    if (bookings.vendor_review != null) {
      _cCommentShop.text = bookings.vendor_review!.description!;
    } else {
      _cCommentShop.text = "";
    }
    if (bookings.staff_review != null) {
      _cCommentStaff.text = bookings.staff_review!.review_description!;
    } else {
      _cCommentStaff.text = "";
    }
  }
}
