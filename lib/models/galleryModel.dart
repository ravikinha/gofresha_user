class Gallery {
  int? id;
  String? image;
  int? vendor_id;

  Gallery();

  Gallery.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      image = json['image'] != null ? json['image'] : null;
    } catch (e) {
      print("Exception - galleryModel.dart - Gallery.fromJson():" + e.toString());
    }
  }
}
