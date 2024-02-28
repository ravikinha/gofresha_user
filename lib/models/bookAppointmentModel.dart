import 'package:app/models/popularBarbersModel.dart';
import 'package:app/models/serviceModel.dart';
import 'package:app/models/timeSlotModel.dart';

class BookAppointment {
  String? salon_name;
  String? owner;
  String? description;
  int? type;
  String? vendor_logo;
  String? vendor_loc;
  int? vendor_id;
  double? rating;
  int? staff_id;
  String? selected_date;
  List<Service> services = [];
  List<TimeSlot>? time_slot = [];
  List<PopularBarbers> barber = [];

  BookAppointment();
  BookAppointment.fromJson(Map<String, dynamic> json) {
    try {
      salon_name = json['salon_name'] != null ? json['salon_name'] : null;
      owner = json['owner'] != null ? json['owner'] : null;
      description = json['description'] != null ? json['description'] : null;
      type = json['type'] != null ? int.parse('${json['type']}') : null;
      rating = json['rating'] != null ? double.parse('${json['rating']}') : null;
      vendor_logo = json['vendor_logo'] != null ? json['vendor_logo'] : null;
      vendor_loc = json['vendor_loc'] != null ? json['vendor_loc'] : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      staff_id = json['staff_id'] != null ? int.parse('${json['staff_id']}') : null;
      selected_date = json['selected_date'] != null ? json['selected_date'] : null;
      barber = json['barber'] != null && json['barber'] != [] ? List<PopularBarbers>.from(json['barber'].map((x) => PopularBarbers.fromJson(x))) : [];
      time_slot = json['time_slot'] != null && json['time_slot'] != [] ? List<TimeSlot>.from(json['time_slot'].map((x) => TimeSlot.fromJson(x))) : [];
      services = json['services'] != null && json['services'] != [] ? List<Service>.from(json['services'].map((x) => Service.fromJson(x))) : [];
    } catch (e) {
      print("Exception - bookAppointmentModel.dart - BookAppointment.fromJson():" + e.toString());
    }
  }
}
