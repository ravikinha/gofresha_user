class WeekTimeSlot {
  int? time_slot_id;
  String? open_hour;
  String? close_hour;
  String? days;
  int? vendor_id;
  int? status;

  WeekTimeSlot();
  WeekTimeSlot.fromJson(Map<String, dynamic> json) {
    try {
      time_slot_id = json['time_slot_id'] != null ? int.parse('${json['time_slot_id']}') : null;
      open_hour = json['open_hour'] != null ? json['open_hour'] : null;
      close_hour = json['close_hour'] != null ? json['close_hour'] : null;
      days = json['days'] != null ? json['days'] : null;
      vendor_id = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      status = json['status'] != null ? int.parse('${json['status']}') : null;
    } catch (e) {
      print("Exception - weeklyTimeModel.dart - WeekTimeSlot.fromJson():" + e.toString());
    }
  }
}
