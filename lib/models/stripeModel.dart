class StripeMethod {
  String? stripe_status;
  String? stripe_secret;
  String? stripe_publishable;
  String? stripe_merchant_id;

  StripeMethod();

  StripeMethod.fromJson(Map<String, dynamic> json) {
    try {
      stripe_status = json['stripe_status'] != null ? '${json['stripe_status']}' : null;
      stripe_secret = json['stripe_secret'] != null ? '${json['stripe_secret']}' : null;
      stripe_publishable = json['stripe_publishable'] != null ? '${json['stripe_publishable']}' : null;
      stripe_merchant_id = json['stripe_merchant_id'] != null ? '${json['stripe_merchant_id']}' : null;
    } catch (e) {
      print("Exception - stripeMethodModel.dart - StripeMethod.fromJson():" + e.toString());
    }
  }
}
