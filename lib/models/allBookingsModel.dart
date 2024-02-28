import 'package:app/models/serviceCartModel.dart';

class AllBookings {
  String? user_name;
  String? vendor_name;
  String? owner;
  String? vendor_phone;
  String? vendor_email;
  String? vendor_loc;
  String? vendor_logo;
  String? service_date;
  String? service_time;
  String? payment_method;
  String? payment_status;
  String? staff_name;
  String? cart_id;
  String? price;
  int? status;
  String? rem_price;
  String? coupon_discount;
  String? reward_discount;
  int? staff_id;
  int? vendor_id;
  List<ServiceCart> cart_services = [];
  ReviewRating? vendor_review;
  ReviewRating? staff_review;
  AllBookings();
  AllBookings.fromJson(Map<String, dynamic> json) {
    try {
      user_name = json['user_name'] != null ? json['user_name'] : null;
      owner = json['owner'] != null ? json['owner'] : null;
      service_date = json['service_date'] != null ? json['service_date'] : null;
      service_time = json['service_time'] != null ? json['service_time'] : null;
      payment_method = json['payment_method'] != null ? json['payment_method'] : null;
      payment_status = json['payment_status'] != null ? json['payment_status'] : null;
      staff_name = json['staff_name'] != null ? json['staff_name'] : null;
      cart_id = json['cart_id'] != null ? json['cart_id'] : null;
      price = json['price'] != null ? json['price'] : null;
      rem_price = json['rem_price'] != null ? json['rem_price'] : null;
      vendor_name = json['vendor_name'] != null ? json['vendor_name'] : null;
      status = json['status'] != null ? int.parse('${json['status']}') : null;
      coupon_discount = json['coupon_discount'] != null ? json['coupon_discount'] : null;
      vendor_email = json['vendor_email'] != null ? json['vendor_email'] : null;
      vendor_phone = json['vendor_phone'] != null ? json['vendor_phone'] : null;
      vendor_logo = json['vendor_logo'] != null ? json['vendor_logo'] : null;
      vendor_loc = json['vendor_loc'] != null ? json['vendor_loc'] : null;
      reward_discount = json['reward_discount'] != null ? json['reward_discount'] : null;
      staff_id = json['staff_id'] != null ? int.parse('${json['staff_id']}') : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      cart_services = json['cart_services'] != null && json['cart_services'] != [] ? List<ServiceCart>.from(json['cart_services'].map((x) => ServiceCart.fromJson(x))) : [];
      vendor_review = json['vendor_review'] != null ? ReviewRating.fromJson(json['vendor_review']) : null;
      staff_review = json['staff_review'] != null ? ReviewRating.fromJson(json['staff_review']) : null;
    } catch (e) {
      print("Exception - allBookingsModel.dart - AllBookings.fromJson():" + e.toString());
    }
  }
}

class ReviewRating {
  double? rating;
  String? review_description;
  String? description;
  ReviewRating();
  ReviewRating.fromJson(Map<String, dynamic> json) {
    try {
      rating = json['rating'] != null ? double.parse(json['rating'].toString()) : null;
      review_description = json['review_description'] != null ? json['review_description'] : null;
      description = json['description'] != null ? json['description'] : null;
    } catch (e) {
      print("Exception - allBookingsModel.dart - ReviewRating.fromJson():" + e.toString());
    }
  }
}
