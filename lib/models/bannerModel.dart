class BannerModel {
  int? banner_id;
  String? banner_name;
  String? banner_image;
  int? service;
  DateTime? created_at;
  DateTime? updated_at;
  String? vendor_id;
  BannerModel();

  BannerModel.fromJson(Map<String, dynamic> json) {
    try {
      banner_id = json['banner_id'] != null ? int.parse('${json['banner_id']}') : null;
      banner_name = json['banner_name'] != null ? json['banner_name'] : null;
      banner_image = json['banner_image'] != null && json['banner_image'] != '' && json['banner_image'] != 'N/A' && json['banner_image'] != 'N\A' ? json['banner_image'] : null;
      service = json['service'] != null ? int.parse('${json['service']}') : null;
      vendor_id = json['vendor_id'] != null ? json['vendor_id'] : null;
    } catch (e) {
      print("Exception - bannerModel.dart - Banner.fromJson():" + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'banner_id': banner_id,
        'banner_name': banner_name != null && banner_name!.isNotEmpty ? banner_name : null,
        'banner_image': banner_image != null && banner_image!.isNotEmpty ? banner_image : null,
        'service': service != null ? service : null,
        'vendor_id': vendor_id != null ? vendor_id : null,
        'created_at': created_at != null ? created_at!.toIso8601String() : null,
        'updated_at': updated_at != null ? updated_at!.toIso8601String() : null,
      };
}
