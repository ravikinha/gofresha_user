class Coupons {
  int? coupon_id;
  String? coupon_name;
  String? coupon_code;
  String? coupon_description;
  DateTime? start_date;
  DateTime? end_date;
  int? cart_value;
  String? amount;
  String? type;
  int? uses_restriction;
  int? coupon_vendor_id;
  int? vendor_id;
  String? vendor_name;
  String? owner;
  String? cityadmin_id;
  String? vendor_email;
  String? vendor_phone;
  String? vendor_logo;
  String? vendor_loc;
  String? lat;
  String? lng;
  String? description;
  String? vendor_pass;
  String? opening_time;
  String? closing_time;
  int? comission;
  int? delivery_range;
  String? device_id;
  String? otp;
  int? phone_verified;
  String? online_status;
  int? shop_type;
  int? booking_amount;
  int? admin_approval;

  Coupons();

  Coupons.fromJson(Map<String, dynamic> json) {
    try {
      coupon_id = json['coupon_id'] != null ? int.parse('${json['coupon_id']}') : null;
      coupon_name = json['coupon_name'] != null ? json['coupon_name'] : null;
      coupon_code = json['coupon_code'] != null ? json['coupon_code'] : null;
      coupon_description = json['coupon_description'] != null ? json['coupon_description'] : null;
      cart_value = json['cart_value'] != null ? int.parse('${json['cart_value']}') : null;
      amount = json['amount'] != null ? json['amount'] : null;
      type = json['type'] != null ? json['type'] : null;
      uses_restriction = json['uses_restriction'] != null ? int.parse('${json['uses_restriction']}') : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      coupon_vendor_id = json['coupon_vendor_id'] != null ? int.parse('${json['coupon_vendor_id']}') : null;
      start_date = json['start_date'] != null ? DateTime.parse(json['start_date'].toString()).toLocal() : null;
      end_date = json['end_date'] != null ? DateTime.parse(json['end_date'].toString()).toLocal() : null;
      vendor_name = json['vendor_name'] != null ? json['vendor_name'] : null;
      cityadmin_id = json['cityadmin_id'] != null ? json['cityadmin_id'] : null;
      vendor_email = json['vendor_email'] != null ? json['vendor_email'] : null;
      vendor_phone = json['vendor_phone'] != null ? json['vendor_phone'] : null;
      vendor_logo = json['vendor_logo'] != null ? json['vendor_logo'] : null;
      vendor_loc = json['vendor_loc'] != null ? json['vendor_loc'] : null;
      description = json['description'] != null ? json['description'] : null;
      vendor_pass = json['vendor_pass'] != null ? json['vendor_pass'] : null;
      opening_time = json['opening_time'] != null ? json['opening_time'] : null;
      closing_time = json['closing_time'] != null ? json['closing_time'] : null;
      comission = json['comission'] != null ? int.parse('${json['comission']}') : null;
      delivery_range = json['delivery_range'] != null ? int.parse('${json['delivery_range']}') : null;
      device_id = json['device_id'] != null ? json['device_id'] : null;
      otp = json['otp'] != null ? json['otp'] : null;
      phone_verified = json['phone_verified'] != null ? int.parse('${json['phone_verified']}') : null;
      online_status = json['online_status'] != null ? json['online_status'] : null;
      shop_type = json['shop_type'] != null ? int.parse('${json['shop_type']}') : null;
      booking_amount = json['booking_amount'] != null ? int.parse('${json['booking_amount']}') : null;
      admin_approval = json['admin_approval'] != null ? int.parse('${json['admin_approval']}') : null;
    } catch (e) {
      print("Exception - couponsModel.dart - Coupons.fromJson():" + e.toString());
    }
  }
}
