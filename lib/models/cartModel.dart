import 'package:app/models/productModel.dart';

class Cart {
  double? total_price;
  List<Product> cart_items = [];

  Cart();

  Cart.fromJson(Map<String, dynamic> json) {
    try {
      total_price = json['total_price'] != null ? double.parse('${json['total_price']}') : null;
      cart_items = json['cart_items'] != null && json['cart_items'] != [] ? List<Product>.from(json['cart_items'].map((x) => Product.fromJson(x))) : [];
    } catch (e) {
      print("Exception - CartModel.dart - Cart.fromJson():" + e.toString());
    }
  }
}
