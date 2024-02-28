import 'package:app/models/reviewModel.dart';

class ProductDetail {
  int? id;
  String? product_name;
  String? product_image;
  String? price;
  String? quantity;
  String? description;
  DateTime? created_at;
  DateTime? updated_at;
  int? vendor_id;
  int? rating;
  String? salon_name;
  String? owner;
  late bool isFavourite;
  List<Review> review = [];
  ProductDetail();

  ProductDetail.fromJson(Map<String, dynamic> json) {
    try {
      salon_name = json['salon_name'] != null ? json['salon_name'] : null;
      owner = json['owner'] != null ? json['owner'] : null;
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      product_name = json['product_name'] != null ? json['product_name'] : null;
      product_image = json['product_image'] != null ? json['product_image'] : null;
      price = json['price'] != null ? json['price'] : null;
      quantity = json['quantity'] != null ? json['quantity'] : null;
      description = json['description'] != null ? json['description'] : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      rating = json['rating'] != null ? int.parse('${json['rating']}') : null;
      isFavourite = json['isFavourite'] != null && json['isFavourite'] == true ? true : false;
      review = json['review'] != null && json['review'] != [] ? List<Review>.from(json['review'].map((x) => Review.fromJson(x))) : [];
    } catch (e) {
      print("Exception - productDetailModel.dart - ProductDetail.fromJson():" + e.toString());
    }
  }
}
