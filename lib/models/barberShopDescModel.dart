import 'package:app/models/barberShopModel.dart';
import 'package:app/models/galleryModel.dart';
import 'package:app/models/popularBarbersModel.dart';
import 'package:app/models/productModel.dart';
import 'package:app/models/reviewModel.dart';
import 'package:app/models/serviceModel.dart';
import 'package:app/models/weeklyTimeModel.dart';

class BarberShopDesc {
  String? salon_name;
  String? owner;
  String? description;
  int? type;
  double? rating;
  String? vendor_logo;
  String? vendor_loc;
  String? vendor_phone;
  String? vendor_whatsapp;
  int? vendor_id;
  List<WeekTimeSlot> weekly_time = [];
  List<PopularBarbers> barber = [];
  List<Product> products = [];
  List<Service> services = [];
  List<Review> review = [];
  List<Gallery> gallery = [];
  List<BarberShop> similar_salons = [];

  BarberShopDesc();
  BarberShopDesc.fromJson(Map<String, dynamic> json) {
    try {
      salon_name = json['salon_name'] != null ? json['salon_name'] : null;
      owner = json['owner'] != null ? json['owner'] : null;
      description = json['description'] != null ? json['description'] : null;

      vendor_logo = json['vendor_logo'] != null ? json['vendor_logo'] : null;
      vendor_loc = json['vendor_loc'] != null ? json['vendor_loc'] : null;
      vendor_phone = json['vendor_phone'] != null ? json['vendor_phone'] : null;
      vendor_whatsapp = json['vendor_whatsapp'] != null ? json['vendor_whatsapp'] : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      type = json['type'] != null ? int.parse('${json['type']}') : null;
      rating = json['rating'] != null ? double.parse(json['rating'].toString()) : null;
      weekly_time = json['weekly_time'] != null && json['weekly_time'] != [] ? List<WeekTimeSlot>.from(json['weekly_time'].map((x) => WeekTimeSlot.fromJson(x))) : [];
      barber = json['barber'] != null && json['barber'] != [] ? List<PopularBarbers>.from(json['barber'].map((x) => PopularBarbers.fromJson(x))) : [];
      products = json['products'] != null && json['products'] != [] ? List<Product>.from(json['products'].map((x) => Product.fromJson(x))) : [];
      services = json['services'] != null && json['services'] != [] ? List<Service>.from(json['services'].map((x) => Service.fromJson(x))) : [];
      review = json['review'] != null && json['review'] != [] ? List<Review>.from(json['review'].map((x) => Review.fromJson(x))) : [];
      gallery = json['gallery'] != null && json['gallery'] != [] ? List<Gallery>.from(json['gallery'].map((x) => Gallery.fromJson(x))) : [];
      similar_salons = json['similar_salons'] != null && json['similar_salons'] != [] ? List<BarberShop>.from(json['similar_salons'].map((x) => BarberShop.fromJson(x))) : [];
    } catch (e) {
      print("Exception - BarberShopDescModel.dart - BarberShopDesc.fromJson():" + e.toString());
    }
  }
}
