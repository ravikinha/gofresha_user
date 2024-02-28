import 'package:app/models/barberShopModel.dart';

class ProductOrderHistory {
  int? order_id;
  int? user_id;
  String? cart_id;
  String? total_price;
  String? payment_gateway;
  String? payment_id;
  String? payment_status;
  int? status;
  int? count;
  String? cancelling_reason;
  List<BarberShop> vendor = [];
  DateTime? created_at;
  ProductOrderHistory();

  ProductOrderHistory.fromJson(Map<String, dynamic> json) {
    try {
      order_id = json['order_id'] != null ? int.parse('${json['order_id']}') : null;
      user_id = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      cart_id = json['cart_id'] != null ? json['cart_id'] : null;
      total_price = json['total_price'] != null ? json['total_price'] : null;
       count = json['count'] != null ? int.parse('${json['count']}') : null;
      payment_gateway = json['payment_gateway'] != null ? json['payment_gateway'] : null;
      payment_id = json['payment_id'] != null ? json['payment_id'] : null;
      payment_status = json['payment_status'] != null ? json['payment_status'] : null;
      status = json['status'] != null ? int.parse('${json['status']}') : null;
      cancelling_reason = json['cancelling_reason'] != null ? json['cancelling_reason'] : null;
      vendor = json['vendor'] != null && json['vendor'] != [] ? List<BarberShop>.from(json['vendor'].map((x) => BarberShop.fromJson(x))) : [];
      created_at = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    } catch (e) {
      print("Exception - productOrderHistoryModel.dart - ProductOrderHistory.fromJson():" + e.toString());
    }
  }
}
