import 'package:app/models/serviceTypeModel.dart';

class Service {
  int? service_id;
  String? service_name;
  String? service_image;
  int? vendor_id;
  int? shop_type;
  List<ServiceType> service_type = [];
  Service();

  Service.fromJson(Map<String, dynamic> json) {
    try {
      service_name = json['service_name'] != null ? json['service_name'] : null;
      service_image = json['service_image'] != null ? json['service_image'] : '';

      service_id = json['service_id'] != null ? int.parse('${json['service_id'] }'): null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;

      shop_type = json['shop_type'] != null ? int.parse('${json['shop_type']}') : null;
      service_type = json['service_type'] != null && json['service_type'] != [] ? List<ServiceType>.from(json['service_type'].map((x) => ServiceType.fromJson(x))) : [];
    } catch (e) {
      print("Exception - seviceModel.dart - Service.fromJson():" + e.toString());
    }
  }
}
