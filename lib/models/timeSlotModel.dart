class TimeSlot {
  String? timeslot;
  bool? availibility;
  TimeSlot();

  TimeSlot.fromJson(Map<String, dynamic> json) {
    try {
      timeslot = json['timeslot'] != null ? json['timeslot'] : null;
      availibility = json['availability'] != null && json['availability'] == 'true' ? true : false;
    } catch (e) {
      print("Exception - timeSlotModel.dart - TimeSlot.fromJson():" + e.toString());
    }
  }
}
