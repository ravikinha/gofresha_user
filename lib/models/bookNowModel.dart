import 'package:app/models/serviceTypeModel.dart';

class BookNow {
  int? id;
  String? cart_id;
  int? user_id;
  int? vendor_id;
  int? staff_id;
  String? total_price;
  String? rem_price;
  String? payment_method;
  String? payment_status;
  String? service_date;
  String? service_time;
  int? status;
  int? order_status;
  String? mobile;
  int? coupon_id;
  String? coupon_discount;
  String? reward_use;
  String? reward_discount;
  String? payment_gateway;
  String? payment_id;
  String? delivery_date;
  String? time_slot;
  String? lang;
  String? typeString;

  List<ServiceType> serviceTypeVarientIdList = [];

  BookNow();
  Map<String, dynamic> toJson() => {
        // 'order_array': serviceTypeVarientIdList,
        'order_array[]': typeString,
        'user_id': user_id,
        'delivery_date': delivery_date,
        'time_slot': time_slot,
        'vendor_id': vendor_id,
        'staff_id': staff_id,
        'payment_method': payment_method,
        'payment_status': payment_status,
        'payment_id': payment_id,
        'payment_gateway': payment_gateway,
        'cart_id': cart_id,
        'lang': lang,
      };

  BookNow.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      cart_id = json['cart_id'] != null ? json['cart_id'] : null;
      user_id = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      staff_id = json['staff_id'] != null ? int.parse('${json['staff_id']}') : null;
      total_price = json['total_price'] != null ? json['total_price'] : null;
      rem_price = json['rem_price'] != null ? json['rem_price'] : null;
      coupon_discount = json['coupon_discount'] != null ? json['coupon_discount'] : null;
      reward_discount = json['reward_discount'] != null ? json['reward_discount'] : null;
      reward_use = json['reward_use'] != null ? json['reward_use'] : null;
      payment_method = json['payment_method'] != null ? json['payment_method'] : null;
      payment_status = json['payment_status'] != null ? json['payment_status'] : null;
      service_date = json['service_date'] != null ? json['service_date'] : null;
      service_time = json['service_time'] != null ? json['service_time'] : null;
      status = json['status'] != null ? int.parse('${json['status']}') : null;
      order_status = json['order_status'] != null ? int.parse('${json['order_status']}') : null;
      mobile = json['mobile'] != null ? json['mobile'] : null;
      coupon_id = json['coupon_id'] != null ? int.parse('${json['coupon_id']}') : null;
      payment_gateway = json['payment_gateway'] != null ? json['payment_gateway'] : null;
      payment_id = json['payment_id'] != null ? json['payment_id'] : null;
      delivery_date = json['delivery_date'] != null ? json['delivery_date'] : null;
      time_slot = json['time_slot'] != null ? json['time_slot'] : null;
    } catch (e) {
      print("Exception - BookNowModel.dart - BookNow.fromJson():" + e.toString());
    }
  }
}
