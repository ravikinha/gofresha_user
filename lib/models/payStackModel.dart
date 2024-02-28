class PayStackMethod {
  String? paystack_status;
  String? paystack_public_key;
  String? paystack_secret_key;
  PayStackMethod();

  PayStackMethod.fromJson(Map<String, dynamic> json) {
    try {
      paystack_status = json['paystack_status'] != null ? '${json['paystack_status']}' : null;
      paystack_public_key = json['paystack_public_key'] != null ? '${json['paystack_public_key']}' : null;
      paystack_secret_key = json['paystack_secret_key'] != null ? '${json['paystack_secret_key']}' : null;
    } catch (e) {
      print("Exception - payStackMethodModel.dart - PayStackMethod.fromJson():" + e.toString());
    }
  }
}
