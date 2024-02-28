// class MapByModel {
//   int map_id;
//   int mapbox;
//   int google_map;
//   MapByModel();
//
//   MapByModel.fromJson(Map<String, dynamic> json) {
//     try {
//       map_id = json['map_id'] != null ? int.parse('${json['map_id']}') : null;
//       mapbox = json['mapbox'] != null ? int.parse('${json['mapbox']}') : null;
//       google_map = json['google_map'] != null ? int.parse('${json['google_map']}') : null;
//     } catch (e) {
//       print("Exception - mapByModel.dart - MapByModel.fromJson():" + e.toString());
//     }
//   }
// }

class MapByModel {
  dynamic status;
  dynamic message;
  MapByModelData? data;

  MapByModel({this.status, this.message, this.data});

  MapByModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new MapByModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MapByModelData {
  dynamic mapId;
  dynamic mapbox;
  dynamic googleMap;

  MapByModelData({this.mapId, this.mapbox, this.googleMap});

  MapByModelData.fromJson(Map<String, dynamic> json) {
    mapId = json['map_id'];
    mapbox = json['mapbox'];
    googleMap = json['google_map'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['map_id'] = this.mapId;
    data['mapbox'] = this.mapbox;
    data['google_map'] = this.googleMap;
    return data;
  }
}
