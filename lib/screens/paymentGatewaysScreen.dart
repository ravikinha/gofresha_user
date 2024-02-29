import 'dart:async';
import 'dart:io';

import 'package:app/models/bookNowModel.dart';
import 'package:app/models/businessLayer/businessRule.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/cardModel.dart';
import 'package:app/models/cartModel.dart';
import 'package:app/models/paymentGatewayModel.dart';
import 'package:app/screens/bookingConfirmationScreen.dart';
import 'package:app/screens/stripePaymentScreen.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../models/businessLayer/apiHelper.dart';
import '../widgets/widgets.dart';

class PaymentGatewayScreen extends StatefulWidget {
  final int? screenId;
  final Cart? cartList;
  final BookNow? bookNowDetails;

  PaymentGatewayScreen(
      {a, o, this.screenId, this.cartList, this.bookNowDetails})
      : super();

  @override
  _PaymentGatewayScreenState createState() => new _PaymentGatewayScreenState(
      cartList: cartList, screenId: screenId, bookNowDetails: bookNowDetails);
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  BookNow? bookNowDetails;
  int? screenId;
  Cart? cartList;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  PaymentGateway? _paymentGatewayList;
  late Razorpay _razorpay;
  bool _isDataLoaded = false;
  bool _isCOD = false;
  var payPlugin = PaystackPlugin();
  TextEditingController _cCardNumber = new TextEditingController();
  TextEditingController _cExpiry = new TextEditingController();
  TextEditingController _cCvv = new TextEditingController();
  TextEditingController _cName = new TextEditingController();

  APIHelper? apiHelper;
  late BusinessRule br;

  int? _month;
  int? _year;
  String? number;
  CardType? cardType;
  final _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;

  bool isLoading = false;

  _PaymentGatewayScreenState(
      {this.screenId, this.cartList, this.bookNowDetails})
      : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.lbl_payment_method,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          body: _isDataLoaded
              ? Column(
                  children: [
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.txt_pay_on_delivery,
                        style: Theme.of(context).primaryTextTheme.headlineSmall,
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    GestureDetector(
                      onTap: () {
                        _isCOD = true;
                        setState(() {});
                      },
                      child: ListTile(
                        tileColor: _isCOD
                            ? Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.3)
                            : Colors.transparent,
                        leading: Icon(
                          MdiIcons.cash,
                          color: Colors.green[500],
                        ),
                        title: Text(AppLocalizations.of(context)!.lbl_cash),
                        subtitle: Text(AppLocalizations.of(context)!
                            .txt_pay_through_cash_at_the_salon),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    ListTile(
                      title: Text(
                          AppLocalizations.of(context)!.lbl_other_methods,
                          style:
                              Theme.of(context).primaryTextTheme.headlineSmall),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    _paymentGatewayList!.razorpay!.razorpay_status == 'Yes'
                        ? GestureDetector(
                            onTap: () {
                              showOnlyLoaderDialog(context);
                              openCheckout();
                            },
                            child: ListTile(
                              leading: Icon(MdiIcons.creditCard),
                              title: Text(
                                  AppLocalizations.of(context)!.lbl_rezorpay),
                            ),
                          )
                        : SizedBox(),
                    _paymentGatewayList!.stripe!.stripe_status == 'Yes'
                        ? GestureDetector(
                            onTap: () {
                              _cardDialog();
                            },
                            child: ListTile(
                              leading: Icon(FontAwesomeIcons.stripe),
                              title: Text(
                                  AppLocalizations.of(context)!.lbl_stripe),
                            ),
                          )
                        : SizedBox(),
                    _paymentGatewayList!.paystack!.paystack_status == 'Yes'
                        ? GestureDetector(
                            onTap: () {
                              _cardDialog(paymentCallId: 1);
                            },
                            child: ListTile(
                              leading: Icon(MdiIcons.creditCard),
                              title: Text(
                                  AppLocalizations.of(context)!.lbl_paystack),
                            ),
                          )
                        : SizedBox()
                  ],
                )
              : _shimmer(),
          bottomNavigationBar: BottomAppBar(
              color: Color(0xFF171D2C),
              child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ListTile(
                    title: RichText(
                        text: TextSpan(
                            style:
                                Theme.of(context).primaryTextTheme.titleMedium,
                            children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .lbl_total_amount),
                          TextSpan(
                            text: screenId == 1
                                ? '${global.currency.currency_sign} ${bookNowDetails?.rem_price ?? '0.00'}'
                                : '${global.currency.currency_sign} ${cartList?.total_price ?? '0.00'}',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headlineSmall!
                                .copyWith(color: Colors.white),
                          )
                        ])),
                    trailing: _isCOD
                        ? MaterialButton(
                            color: Color(0xFF00547B),
                            onPressed: () {
                              screenId == 1
                                  ? _checkOut()
                                  : _productCartCheckout();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.lbl_checkout,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : SizedBox(),
                  )))),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void openCheckout() async {
    var options;

    options = {
      'key': _paymentGatewayList!.razorpay!.razorpay_key,
      'amount':
          screenId == 1 ? bookNowDetails!.rem_price : cartList!.total_price,
      'name': screenId == 1
          ? bookNowDetails!.cart_id
          : cartList!.cart_items[0].order_cart_id,
      'prefill': {
        'contact': global.user!.user_phone,
        'email': global.user!.email
      },
      'currency': 'INR'
    };

    try {
      hideLoader(context);
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void payStatck(String? key) async {
    try {
      payPlugin
          .initialize(
              publicKey: _paymentGatewayList!.paystack!.paystack_public_key!)
          .then((value) {
        _startAfreshCharge((int.parse('${cartList!.total_price}') * 100));
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      print("Exception - paymentGatewaysScreen.dart - payStatck(): " +
          e.toString());
    }
  }

  Future<StripeTransactionResponse> payWithNewCard({
    String? amount,
    required CardModel card,
    String? currency,
  }) async {
    var customers;
    try {
      showOnlyLoaderDialog(context);
      customers = await StripeService.createCustomer(email: global.user!.email);

      var paymentMethodsObject =
          await (StripeService.createPaymentMethod(card));

      var paymentIntent = await (StripeService.createPaymentIntent(
          amount, currency,
          customerId: customers["id"]));
      var response = await (StripeService.confirmPaymentIntent(
          paymentIntent!["id"], paymentMethodsObject!["id"]));
      if (response!["status"] == 'succeeded') {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          if (screenId == 1) {
            BookNow _bookNow = new BookNow();
            _bookNow.payment_status = "success";
            _bookNow.payment_method = "Stripe";
            _bookNow.cart_id = bookNowDetails!.cart_id;
            _bookNow.payment_id = paymentIntent["id"];
            _bookNow.payment_gateway = "Stripe";
            await apiHelper!.checkOut(_bookNow).then((result) async {
              if (result != null) {
                if (result.status == "1") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => BookingConfirmationScreen()),
                  );
                }
              }
            });
          } else {
            await apiHelper!
                .productCartCheckout(global.user!.id, "success", "stripe",
                    payment_id: paymentIntent["id"])
                .then((result) {
              if (result != null) {
                if (result.status == "1") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => BookingConfirmationScreen()),
                  );
                }
              }
            });
          }
          hideLoader(context);
        } else {
          showNetworkErrorSnackBar(_scaffoldKey, context, br);
        }

        return new StripeTransactionResponse(
            message: AppLocalizations.of(context)!.lbl_transaction_successful,
            success: true);
      } else {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog(context);
          if (screenId == 1) {
            BookNow _bookNow = new BookNow();
            _bookNow.payment_status = "failed";
            _bookNow.payment_method = "Stripe";
            _bookNow.cart_id = bookNowDetails!.cart_id;
            _bookNow.payment_gateway = "Stripe";

            await apiHelper!.checkOut(_bookNow).then((result) async {
              if (result != null) {
                if (result.status == "0") {
                  showSnackBar(
                      context: context,
                      key: _scaffoldKey,
                      snackBarMessage: result.message.toString());
                  setState(() {});
                } else {}
              }
            });
          } else {
            await apiHelper!
                .productCartCheckout(global.user!.id, "failed", "stripe")
                .then((result) {
              if (result != null) {
                if (result.status == "2") {
                  Navigator.of(context).pop();
                  showSnackBar(
                      context: context,
                      key: _scaffoldKey,
                      snackBarMessage: result.message.toString());
                }
              }
            });
          }
          hideLoader(context);
          _tryAgainDialog();
          setState(() {});
        } else {
          showNetworkErrorSnackBar(_scaffoldKey, context, br);
        }
        return new StripeTransactionResponse(
            message: AppLocalizations.of(context)!.lbl_transaction_failed,
            success: false);
      }
    } on PlatformException catch (err) {
      print(
          'Platfrom Exception: paymentGatewaysScreen.dart -  payWithNewCard() : ${err.toString()}');
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      print(
          'Exception: paymentGatewaysScreen.dart -  payWithNewCard() : ${err.toString()}');
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  _cardDialog({int? paymentCallId}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Theme(
                  data: ThemeData(dialogBackgroundColor: Colors.white),
                  child: AlertDialog(
                    contentPadding: EdgeInsets.all(0),
                    elevation: 0.5,
                    scrollable: true,
                    title: Text(
                      AppLocalizations.of(context)!.lbl_card_Details,
                      style: Theme.of(context).primaryTextTheme.displaySmall,
                    ),
                    actions: [
                      Row(
                        children: [
                          TextButton(
                            style: Theme.of(context).textButtonTheme.style,
                            child:
                                Text(AppLocalizations.of(context)!.lbl_cancel),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextButton(
                              style: Theme.of(context).textButtonTheme.style,
                              child:
                                  Text(AppLocalizations.of(context)!.lbl_pay),
                              onPressed: () {
                                _save(paymentCallId);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                    content: Form(
                      key: _formKey,
                      autovalidateMode: _autovalidate
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _cCardNumber,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(16),
                                new CardNumberInputFormatter(),
                              ],
                              textInputAction: TextInputAction.next,
                              decoration: new InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .lbl_card_number,
                                hintStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle,
                                prefixIcon: Icon(Icons.credit_card),
                              ),
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.number,
                              onSaved: (String? value) {
                                number = BusinessRule.getCleanedNumber(value!);
                              },
                              // ignore: missing_return
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .txt_enter_card_number;
                                }

                                input = BusinessRule.getCleanedNumber(input);

                                if (input.length < 8) {
                                  return AppLocalizations.of(context)!
                                      .txt_enter_valid_card_number;
                                }

                                int sum = 0;
                                int length = input.length;
                                for (var i = 0; i < length; i++) {
                                  // get digits in reverse order
                                  int digit = int.parse(input[length - i - 1]);

                                  // every 2nd number multiply with 2
                                  if (i % 2 == 1) {
                                    digit *= 2;
                                  }
                                  sum += digit > 9 ? (digit - 9) : digit;
                                }

                                if (sum % 10 == 0) {
                                  return null;
                                }

                                return AppLocalizations.of(context)!
                                    .txt_enter_valid_card_number;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      // ignore: deprecated_member_use
                                      FilteringTextInputFormatter.digitsOnly,
                                      new LengthLimitingTextInputFormatter(4),
                                      new CardMonthInputFormatter(),
                                    ],
                                    controller: _cExpiry,
                                    textInputAction: TextInputAction.next,
                                    decoration: new InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.date_range,
                                        ),
                                        hintText: 'MM/YY',
                                        hintStyle: Theme.of(context)
                                            .inputDecorationTheme
                                            .hintStyle),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.number,
                                    onFieldSubmitted: (value) {
                                      List<int> expiryDate =
                                          BusinessRule.getExpiryDate(value);
                                      _month = expiryDate[0];
                                      _year = expiryDate[1];
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .txt_enter_expiry_date;
                                      }

                                      int year;
                                      int month;
                                      // The value contains a forward slash if the month and year has been
                                      // entered.
                                      if (value.contains(new RegExp(r'(/)'))) {
                                        var split =
                                            value.split(new RegExp(r'(/)'));
                                        // The value before the slash is the month while the value to right of
                                        // it is the year.
                                        month = int.parse(split[0]);
                                        year = int.parse(split[1]);
                                      } else {
                                        // Only the month was entered
                                        month = int.parse(
                                            value.substring(0, (value.length)));
                                        year =
                                            -1; // Lets use an invalid year intentionally
                                      }

                                      if ((month < 1) || (month > 12)) {
                                        // A valid month is between 1 (January) and 12 (December)
                                        return AppLocalizations.of(context)!
                                            .txt_expiry_month_is_invalid;
                                      }

                                      var fourDigitsYear =
                                          BusinessRule.convertYearTo4Digits(
                                              year);
                                      if ((fourDigitsYear < 1) ||
                                          (fourDigitsYear > 2099)) {
                                        // We are assuming a valid should be between 1 and 2099.
                                        // Note that, it's valid doesn't mean that it has not expired.
                                        return AppLocalizations.of(context)!
                                            .txt_expiry_year_is_invalid;
                                      }

                                      if (!BusinessRule.hasDateExpired(
                                          month, year)) {
                                        return AppLocalizations.of(context)!
                                            .txt_card_has_expired;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      // ignore: deprecated_member_use
                                      FilteringTextInputFormatter.digitsOnly,
                                      new LengthLimitingTextInputFormatter(3),
                                    ],
                                    controller: _cCvv,
                                    obscureText: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: new InputDecoration(
                                        prefixIcon: Icon(
                                          MdiIcons.creditCard,
                                        ),
                                        hintText: AppLocalizations.of(context)!
                                            .lbl_cvv,
                                        hintStyle: Theme.of(context)
                                            .inputDecorationTheme
                                            .hintStyle),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .txt_enter_cvv;
                                      } else if (value.length < 3 ||
                                          value.length > 4) {
                                        return AppLocalizations.of(context)!
                                            .txt_cvv_is_invalid;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _cName,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z ]')),
                              ],
                              decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                  ),
                                  hintText: AppLocalizations.of(context)!
                                      .txt_card_holder_name,
                                  hintStyle: Theme.of(context)
                                      .inputDecorationTheme
                                      .hintStyle),
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return null;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )));
        });
  }

  _chargeCard(Charge charge) async {
    try {
      payPlugin.chargeCard(context, charge: charge).then((value) {
        if (value.status && value.message == "Success") {}
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      print("Exception - paymentGatewaysScreen.dart - _chargeCard(): " +
          e.toString());
    }
  }

  _checkOut() async {
    try {
      await EasyLoading.show(status: "Processing");
      BookNow _bookNow = new BookNow();
      _bookNow.payment_method = "COD";
      _bookNow.cart_id = bookNowDetails!.cart_id;
      _bookNow.user_id = bookNowDetails!.user_id;
      _bookNow.payment_gateway = "COD";

      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.checkOut(_bookNow).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              await EasyLoading.showSuccess('Booking Processed Successfully');
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => BookingConfirmationScreen(
                          screenId: 2,
                        )),
              );
            } else {
              await EasyLoading.showError(result.message.toString());
              showSnackBar(
                  context: context,
                  key: _scaffoldKey,
                  snackBarMessage: result.message.toString());
            }
          }
        });
      } else {
        await EasyLoading.dismiss();
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      await EasyLoading.dismiss();
      print("Exception - paymentGatewaysScreen.dart - _checkOut():" +
          e.toString());
    }
  }

  PaymentCard _getCardFromUI() {
    return PaymentCard(
      number: _cCardNumber.text,
      cvc: _cCvv.text,
      expiryMonth: 11,
      expiryYear: 25,
    );
  }

  _getPaymentGateways() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getPaymentGateways().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _paymentGatewayList = result.recordList;
              _isDataLoaded = true;
              setState(() {});
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
          "Exception - paymentGatewaysScreen.dart.dart - _getPaymentGateways():" +
              e.toString());
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog(context);

        if (screenId == 1) {
          BookNow _bookNow = new BookNow();
          _bookNow.payment_status = "failed";
          _bookNow.payment_method = "Razorpay";
          _bookNow.cart_id = bookNowDetails!.cart_id;
          _bookNow.payment_gateway = "Razorpay";

          await apiHelper!.checkOut(_bookNow).then((result) async {
            if (result != null) {
              if (result.status == "0") {
                showSnackBar(
                    context: context,
                    key: _scaffoldKey,
                    snackBarMessage: result.message.toString());
                setState(() {});
              } else {}
            }
          });
        } else {
          await apiHelper!
              .productCartCheckout(global.user!.id, "failed", " razorpay")
              .then((result) {
            if (result != null) {
              if (result.status == "2") {
                Navigator.of(context).pop();
                showSnackBar(
                    context: context,
                    key: _scaffoldKey,
                    snackBarMessage: result.message.toString());
              }
            }
          });
        }
        hideLoader(context);
        _tryAgainDialog();
        setState(() {});
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
      showSnackBar(
          context: context,
          key: _scaffoldKey,
          snackBarMessage:
              AppLocalizations.of(context)!.lbl_transaction_failed);
    } catch (e) {
      print("Exception - paymentGatewaysScreen.dart -  _handlePaymentError" +
          e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      showOnlyLoaderDialog(context);

      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog(context);
        if (screenId == 1) {
          BookNow _bookNow = new BookNow();
          _bookNow.payment_status = "success";
          _bookNow.payment_method = "Razorpay";
          _bookNow.cart_id = bookNowDetails!.cart_id;
          _bookNow.payment_id = response.paymentId;
          _bookNow.payment_gateway = "Razorpay";
          await apiHelper!.checkOut(_bookNow).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => BookingConfirmationScreen()),
                );
              }
            }
          });
        } else {
          await apiHelper!
              .productCartCheckout(global.user!.id, "success", "razorpay",
                  payment_id: response.paymentId)
              .then((result) {
            if (result != null) {
              if (result.status == "1") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => BookingConfirmationScreen()),
                );
              }
            }
          });
        }
        hideLoader(context);
        setState(() {});
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }

      showSnackBar(
          context: context,
          key: _scaffoldKey,
          snackBarMessage:
              AppLocalizations.of(context)!.lbl_transaction_successful);
    } catch (e) {
      print("Exception - paymentGatewaysScreen.dart - _handlePaymentSuccess" +
          e.toString());
    }
  }

  _init() async {
    apiHelper = new APIHelper();
    br = new BusinessRule(apiHelper);
    try {
      await _getPaymentGateways();
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    } catch (e) {
      print("Exception - paymentGatewaysScreen.dart.dart - _init():" +
          e.toString());
    }
  }

  _productCartCheckout() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog(context);
        await apiHelper!
            .productCartCheckout(
          global.user!.id,
          "COD",
          "COD",
        )
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              hideLoader(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => BookingConfirmationScreen(
                          screenId: 1,
                        )),
              );
            }

            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey, context, br);
      }
    } catch (e) {
      print(
          "Exception - paymentGatewaysScreen.dart.dart - _productCartCheckout():" +
              e.toString());
    }
  }

  Future _save(int? callId) async {
    try {
      showOnlyLoaderDialog(context);
      if (_cCardNumber.text.trim().isEmpty) {
        hideLoader(context);
        showSnackBar(
            context: context,
            key: _scaffoldKey,
            snackBarMessage:
                AppLocalizations.of(context)!.txt_enter_your_card_number);
      } else if (_cExpiry.text.trim().isEmpty) {
        hideLoader(context);
        showSnackBar(
            context: context,
            key: _scaffoldKey,
            snackBarMessage:
                AppLocalizations.of(context)!.txt_enter_your_expiry_date);
      } else if (_cName.text.trim().isEmpty) {
        hideLoader(context);
        showSnackBar(
            context: context,
            key: _scaffoldKey,
            snackBarMessage:
                AppLocalizations.of(context)!.txt_enter_your_card_name);
      } else {
        if (_formKey.currentState!.validate()) {
          bool isConnected = await br.checkConnectivity();
          if (isConnected) {
            CardModel stripeCard = CardModel(
              number: _cCardNumber.text,
              expiryMonth: _month,
              expiryYear: _year,
              cvv: _cCvv.text,
            );
            Navigator.of(context).pop();
            if (screenId == 1) {
              callId == 1
                  ? payStatck(
                      _paymentGatewayList!.paystack!.paystack_secret_key)
                  : await payWithNewCard(
                      card: stripeCard,
                      amount: bookNowDetails!.rem_price,
                      currency: global.currency.currency);
            } else {
              callId == 1
                  ? payStatck(
                      _paymentGatewayList!.paystack!.paystack_secret_key)
                  : await payWithNewCard(
                      card: stripeCard,
                      amount: cartList!.total_price.toString(),
                      currency: global.currency.currency);
            }

            hideLoader(context);
          }
        }
      }
    } catch (e) {
      print(
          "Exception - paymentGatewaysScreen.dart - _save(): " + e.toString());
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
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 220,
                            height: 40,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            height: 40,
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

  _startAfreshCharge(int price) async {
    try {
      Charge charge = Charge()
        ..amount = price
        ..email = '${global.user!.email}'
        ..currency = 'INR'
        ..card = _getCardFromUI()
        ..reference = _getReference();

      _chargeCard(charge);
    } catch (e) {
      print("Exception - paymentGatewaysScreen.dart - _startAfreshCharge(): " +
          e.toString());
    }
  }

  _tryAgainDialog() {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.lbl_transaction_failed,
                ),
                content: Text(
                  AppLocalizations.of(context)!.txt_please_try_again,
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      AppLocalizations.of(context)!.lbl_cancel,
                      style: TextStyle(color: Color(0xFF00547B)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context)!.lbl_try_again),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print('Exception - paymentGatewaysScreen.dart - exitAppDialog(): ' +
          e.toString());
    }
  }
}
