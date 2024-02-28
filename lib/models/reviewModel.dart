class Review {
  int? id;
  late double rating;
  String? description;
  int? user_id;
  int? vendor_id;
  int? product_id;
  int? active;
  String? name;
  String? image;
  DateTime? created_at;

  Review();

  Review.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      user_id = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
       product_id = json['product_id'] != null ? int.parse('${json['product_id']}') : null;
      description = json['description'] != null ? json['description'] : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      rating = json['rating'] != null ? double.parse(json['rating'].toString()) : 0;
      active = json['active'] != null ? int.parse('${json['active']}') : null;
      name = json['name'] != null ? json['name'] : null;
      image = json['image'] != null ? json['image'] : null;
      created_at = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    } catch (e) {
      print("Exception - reviewModel.dart - Review.fromJson():" + e.toString());
    }
  }
}
