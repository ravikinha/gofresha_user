import 'package:app/models/payStackModel.dart';
import 'package:app/models/razorpayModel.dart';
import 'package:app/models/stripeModel.dart';

class PaymentGateway {
  RazorpayMethod? razorpay;
  StripeMethod? stripe;
  PayStackMethod? paystack;
  PaymentGateway();

  PaymentGateway.fromJson(Map<String, dynamic> json) {
    try {
      razorpay = json['razorpay'] != null ? RazorpayMethod.fromJson(json['razorpay']) : null;
      stripe = json['stripe'] != null ? StripeMethod.fromJson(json['stripe']) : null;
      paystack = json['paystack'] != null ? PayStackMethod.fromJson(json['paystack']) : null;
    } catch (e) {
      print("Exception - paymentGatewayModel.dart - PaymentGateway.fromJson():" + e.toString());
    }
  }
}
