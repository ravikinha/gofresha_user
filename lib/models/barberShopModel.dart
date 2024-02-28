import 'package:app/models/productModel.dart';

class BarberShop {
  String? vendor_name;
  String? owner;
  String? vendor_email;
  String? vendor_phone;
  String? vendor_logo;
  String? vendor_loc;
  String? lat;
  String? lng;
  String? opening_time;
  String? closing_time;
  int? vendor_id;
  int? delivery_range;
  int? shop_type;
  double? distance;
  String? description;
  DateTime? created_at;
  int? phone_verified;
  String? online_status;
  double? rating;

  List<Product> products = [];

  BarberShop();

  BarberShop.fromJson(Map<String, dynamic> json) {
    try {
      vendor_name = json['vendor_name'] != null ? json['vendor_name'] : null;
      owner = json['owner'] != null ? json['owner'] : null;
      vendor_email = json['vendor_email'] != null ? json['vendor_email'] : null;
      vendor_phone = json['vendor_phone'] != null ? json['vendor_phone'] : null;
      vendor_logo = json['vendor_logo'] != null ? json['vendor_logo'] : '';
      vendor_loc = json['vendor_loc'] != null ? json['vendor_loc'] : null;
      lat = json['lat'] != null ? json['lat'] : null;
      lng = json['lng'] != null ? json['lng'] : null;
      opening_time = json['opening_time'] != null ? json['opening_time'] : null;
      closing_time = json['closing_time'] != null ? json['closing_time'] : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      delivery_range = json['delivery_range'] != null ? int.parse('${json['delivery_range']}') : null;
      shop_type = json['shop_type'] != null ? int.parse('${json['shop_type']}') : null;
      distance = json['distance'] != null ? double.parse(json['distance'].toString()) : null;

      rating = json['rating'] != null ? double.parse(json['rating'].toString()) : null;
      description = json['description'] != null ? json['description'] : null;

      phone_verified = json['phone_verified'] != null ? int.parse('${json['phone_verified']}') : null;
      online_status = json['online_status'] != null ? json['online_status'] : null;

      products = json['products'] != null && json['products'] != [] ? List<Product>.from(json['products'].map((x) => Product.fromJson(x))) : [];
    } catch (e) {
      print("Exception - barberShopModel.dart - BarberShop.fromJson():" + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {'vendor_id': vendor_id};
}
