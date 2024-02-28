class GoogleMapModel {
  int? key_id;
  String? map_api_key;

  GoogleMapModel();

  GoogleMapModel.fromJson(Map<String, dynamic> json) {
    try {
      key_id = json['key_id'] != null ? int.parse('${json['key_id']}') : null;
      map_api_key = json['map_api_key'] != null ? json['map_api_key'] : null;
    } catch (e) {
      print("Exception - googleMapModel.dart - GoogleMapModel.fromJson():" + e.toString());
    }
  }

  @override
  String toString() {
    return 'GoogleMapModel{key_id: $key_id, map_api_key: $map_api_key}';
  }
}
