class CancelReasons {
  int? res_id;
  String? reason;
  CancelReasons();

  CancelReasons.fromJson(Map<String, dynamic> json) {
    try {
      res_id = json['res_id'] != null ? int.parse(json['res_id']) : null;
      reason = json['reason'] != null ? json['reason'] : null;
    } catch (e) {
      print("Exception - cancelReasonsModel.dart - CancelReasons.fromJson():" + e.toString());
    }
  }
}
