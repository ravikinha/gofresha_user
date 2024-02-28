import 'package:app/models/productModel.dart';

class Favorites {
  int? fav_count;
  List<Product> fav_items = [];

  Favorites();

  Favorites.fromJson(Map<String, dynamic> json) {
    try {
      fav_count = json['fav_count'] != null ? int.parse('${json['fav_count']}') : null;
      fav_items = json['fav_items'] != null && json['fav_items'] != [] ? List<Product>.from(json['fav_items'].map((x) => Product.fromJson(x))) : [];
    } catch (e) {
      print("Exception - FavoritesModel.dart - Favorites.fromJson():" + e.toString());
    }
  }
}
