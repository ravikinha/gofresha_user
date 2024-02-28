class PrivacyPolicy {
  int? id;
  String? privacy_policy;
  PrivacyPolicy();
  PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      privacy_policy = json['privacy_policy'] != null ? json['privacy_policy'] : null;
    } catch (e) {
      print("Exception - privacyPolicyModel.dart - PrivacyPolicy.fromJson():" + e.toString());
    }
  }
}
