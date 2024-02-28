import 'package:app/models/reviewModel.dart';
import 'package:app/models/weeklyTimeModel.dart';

class PopularBarbers {
  String? staff_name;
  String? staff_image;
  int? staff_id;
  int? count;
  int? vendor_id;
  String? vendor_name;
  String? vendor_logo;
  String? owner;
  String? vendor_loc;
  String? staff_description;
  String? salon_name;
  int? type;
  late double rating;
  List<WeekTimeSlot> weekly_time = [];
  List<Review> review = [];
  PopularBarbers();

  PopularBarbers.fromJson(Map<String, dynamic> json) {
    try {
      staff_name = json['staff_name'] != null ? json['staff_name'] : null;
      staff_image = json['staff_image'] != null ? json['staff_image'] : null;
      staff_id = json['staff_id'] != null ? int.parse('${json['staff_id']}') : null;
      count = json['count'] != null ? int.parse('${json['count']}') : null;
      vendor_loc = json['vendor_loc'] != null ? json['vendor_loc'] : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      vendor_name = json['vendor_name'] != null ? json['vendor_name'] : null;
      vendor_logo = json['vendor_logo'] != null ? json['vendor_logo'] : '';
      owner = json['owner'] != null ? json['owner'] : null;
      staff_description = json['staff_description'] != null ? json['staff_description'] : null;
      salon_name = json['salon_name'] != null ? json['salon_name'] : null;
      type = json['type'] != null ? int.parse('${json['type']}') : null;
      rating = json['rating'] != null ? double.parse(json['rating'].toString()) : 0;
      weekly_time = json['weekly_time'] != null && json['weekly_time'] != [] ? List<WeekTimeSlot>.from(json['weekly_time'].map((x) => WeekTimeSlot.fromJson(x))) : [];
      review = json['review'] != null && json['review'] != [] ? List<Review>.from(json['review'].map((x) => Review.fromJson(x))) : [];
    } catch (e) {
      print("Exception - popularBarbersModel.dart - PopularBarbers.fromJson():" + e.toString());
    }
  }
}
