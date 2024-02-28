class ServiceCart {
  int? order_cart_id;
  String? service_name;
  int? service_id;
  String? varient;
  int? varient_id;
  String? cart_id;
  int? user_id;
  int? vendor_id;
  String? status;
  String? price;
  DateTime? created_at;
  ServiceCart();

   ServiceCart.fromJson(Map<String, dynamic> json) {
    try {
      order_cart_id = json['order_cart_id'] != null ? int.parse('${json['order_cart_id']}') : null;
      service_name = json['service_name'] != null && json['service_name'] != 'n/a'  ? json['service_name'] : '';
      service_id = json['service_id'] != null ? int.parse('${json['service_id']}') : null;
      varient = json['varient'] != null ? json['varient'] : null;
      varient_id = json['varient_id'] != null ? int.parse('${json['varient_id']}') : null;
      cart_id = json['cart_id'] != null ? json['cart_id'] : null;
      user_id = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      status = json['status'] != null ? json['status'] : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      price = json['price'] != null ? json['price'] : null;
      created_at = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
   
    } catch (e) {
      print("Exception - serviceCartModel.dart - ServiceCart.fromJson():" + e.toString());
    }
  }
}
