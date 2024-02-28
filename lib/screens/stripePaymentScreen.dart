import 'dart:convert';

import 'package:app/models/cardModel.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String createCustomerUrl = '${StripeService.apiBase}/customers';

  static String publishableKey = "pk_test_c0oc159sTDjBAxK4JOCpPElA00WOC6sWJq";
  static String secret = "sk_test_AsWOqM4QzNC5kiiuhVaMr1mH00JC9bmg6A";

  static Map<String, String> headers = {'Authorization': 'Bearer ${StripeService.secret}', 'Content-Type': 'application/x-www-form-urlencoded'};

  static Future<Map<String, dynamic>?> confirmPaymentIntent(String? paymentIntentId, String? paymentMethodId, {String? customerId}) async {
    try {
      Map<String, dynamic> body = {'payment_method': paymentMethodId};
      var response = await http.post(Uri.parse('${StripeService.apiBase}/payment_intents/$paymentIntentId/confirm'), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripePaymentScreen.dart - confirmPaymentIntent(): ${err.toString()}');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> createCustomer({String? source, String? email}) async {
    try {
      Map<String, dynamic> body = {'email': email};
      var response = await http.post(Uri.parse(StripeService.createCustomerUrl), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripePaymentScreen.dart - createCustomer():${err.toString()}');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(String? amount, String? currency, {String? customerId}) async {
    try {
      Map<String, dynamic> body = {'amount': amount, 'currency': 'INR', 'customer': customerId};
      var response = await http.post(Uri.parse(StripeService.paymentApiUrl), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripePaymentScreen.dart - createPaymentIntent(): ${err.toString()}');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> createPaymentMethod(CardModel card) async {
    try {
      Map<String, dynamic> body = {'type': "card", 'card[number]': card.number?.replaceAll(' ', ''), 'card[exp_month]': card.expiryMonth.toString(), 'card[exp_year]': card.expiryYear.toString(), "card[cvc]": card.cvv};
      var response = await http.post(Uri.parse('${StripeService.apiBase}/payment_methods'), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripePaymentScreen.dart - createPaymentMethod():${err.toString()}');
    }
    return null;
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }
}

class StripeTransactionResponse {
  String? message;
  bool? success;
  StripeTransactionResponse({this.message, this.success});
}
