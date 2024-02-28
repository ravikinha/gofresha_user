class RazorpayMethod {
  String? razorpay_status;
  String? razorpay_secret;
  String? razorpay_key;
  RazorpayMethod();

  RazorpayMethod.fromJson(Map<String, dynamic> json) {
    try {
      razorpay_status = json['razorpay_status'] != null ? '${json['razorpay_status']}' : null;
      razorpay_secret = json['razorpay_secret'] != null ? '${json['razorpay_secret']}' : null;
      razorpay_key = json['razorpay_key'] != null ? '${json['razorpay_key']}' : null;
    } catch (e) {
      print("Exception - razorpayMethod.dart - RazorpayMethod.fromJson():" + e.toString());
    }
  }
}
