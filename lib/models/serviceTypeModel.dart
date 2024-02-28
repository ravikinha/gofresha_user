class ServiceType {
  int? varient_id;
  int? service_id;
  String? varient;
  int? price;
  int? time;
  String? service_name;
  int? vendor_id;

  ServiceType();
  ServiceType.fromJson(Map<String, dynamic> json) {
    try {
      varient_id = json['varient_id'] != null ? int.parse('${json['varient_id']}') : null;
      service_id = json['service_id'] != null ? int.parse('${json['service_id']}') : null;
      varient = json['varient'] != null ? json['varient'] : null;
      time = json['time'] != null ? int.parse('${json['time']}') : null;
      // vendor_id = json['vendor_id'] != null ? json['vendor_id'] : null;
      price = json['price'] != null ? int.parse('${json['price']}') : null;
      service_name = json['service_name'] != null ? json['service_name'] : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
    } catch (e) {
      print("Exception - serviceTypeModel.dart - ServiceType.fromJson():" + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'varient_id': varient_id != null ? varient_id.toString() : null,
      };
}
