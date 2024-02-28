class Product {
  int? id;
  int? subcat_id;
  String? product_name;
  String? product_image;
  String? price;
  String? quantity;
  String? description;
  int? vendor_id;
  String? vendor_name;
  int? delivery_range;
  double? distance;
  int? cart_qty;
  int? store_order_id;
  int? product_id;
  int? qty; //
  String? total_price;
  String? order_cart_id;
  String? order_date;
  int? user_id;
  String? status;
  bool? isFavourite;
  int? wish_id;
  Product();

  Product.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      subcat_id = json['subcat_id'] != null ? int.parse('${json['subcat_id']}') : null;
      product_name = json['product_name'] != null ? json['product_name'] : null;
      product_image = json['product_image'] != null ? json['product_image'] : '';
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      price = json['price'] != null ? json['price'] : null;
      quantity = json['quantity'] != null ? json['quantity'] : null;
      description = json['description'] != null ? json['description'] : null;
      vendor_name = json['vendor_name'] != null ? json['vendor_name'] : null;
      delivery_range = json['delivery_range'] != null ? int.parse('${json['delivery_range']}') : null;
      distance = json['distance'] != null ? double.parse(json['distance'].toString()) : null;
      store_order_id = json['store_order_id'] != null ? int.parse('${json['store_order_id']}') : null;
      product_id = json['product_id'] != null ? int.parse('${json['product_id']}') : null;
      qty = json['qty'] != null ? int.parse('${json['qty']}') : null;
      total_price = json['total_price'] != null ? json['total_price'] : null;
      order_cart_id = json['order_cart_id'] != null ? json['order_cart_id'] : null;
      order_date = json['order_date'] != null ? json['order_date'] : null;
      user_id = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      status = json['status'] != null ? json['status'] : null;
      isFavourite = json['isFavourite'] != null && json['isFavourite'] == true ? true : false;
      wish_id = json['wish_id'] != null ? int.parse('${json['wish_id']}') : null;
      cart_qty = json['cart_qty'] != null ? int.parse('${json['cart_qty']}') : null;
    } catch (e) {
      print("Exception - productModel.dart - Product.fromJson():" + e.toString());
    }
  }
}
