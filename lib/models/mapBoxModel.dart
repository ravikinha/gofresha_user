class MapBoxModel {
  int? map_id;
  String? mapbox_api;

  MapBoxModel();

  MapBoxModel.fromJson(Map<String, dynamic> json) {
    try {
      map_id = json['map_id'] != null ? int.parse('${json['map_id']}') : null;
      mapbox_api = json['mapbox_api'] != null ? json['mapbox_api'] : null;
    } catch (e) {
      print("Exception - mapBoxModel.dart - MapBoxModel.fromJson():" + e.toString());
    }
  }
}
