class ProductCartCheckout {
  int? order_id;
  int? user_id;
  String? cart_id;
  String? total_price;
  String? payment_gateway;
  String? payment_id;
  String? payment_status;
  int? status;

  DateTime? created_at;

  ProductCartCheckout();

  ProductCartCheckout.fromJson(Map<String, dynamic> json) {
    try {
      order_id = json['order_id'] != null ? int.parse('${json['order_id']}') : null;
      user_id = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      cart_id = json['cart_id'] != null ? json['cart_id'] : null;
      total_price = json['total_price'] != null ? json['total_price'] : null;
      payment_gateway = json['payment_gateway'] != null ? json['payment_gateway'] : null;
      payment_id = json['payment_id'] != null ? json['payment_id'] : null;
      payment_status = json['payment_status'] != null ? json['payment_status'] : null;
      status = json['status'] != null ? int.parse('${json['status']}') : null;
      created_at = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    } catch (e) {
      print("Exception - productCartCheckoutModel.dart - ProductCartCheckout.fromJson():" + e.toString());
    }
  }
}
