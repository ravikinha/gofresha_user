class NotificationList {
  int? noti_id;
  int? user_id;
  String? noti_title;
  String? noti_message;
  String? image;
  int? read_by_user;
  DateTime? created_at;
  NotificationList();

  NotificationList.fromJson(Map<String, dynamic> json) {
    try {
      noti_id = json['noti_id'] != null ? int.parse('${json['noti_id']}') : null;
      user_id = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      noti_title = json['noti_title'] != null ? json['noti_title'] : null;
      noti_message = json['noti_message'] != null ? json['noti_message'] : null;
      image = json['image'] != null ? json['image'] : '';
      read_by_user = json['read_by_user'] != null ? int.parse('${json['read_by_user']}') : null;
      created_at = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    } catch (e) {
      print("Exception - notificationListModel.dart - NotificationList.fromJson():" + e.toString());
    }
  }
}
