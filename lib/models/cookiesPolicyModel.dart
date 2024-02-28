class Cookies {
  int? id;
  String? cookies_policy;
  Cookies();
  Cookies.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      cookies_policy = json['cookies_policy'] != null ? json['cookies_policy'] : null;
    } catch (e) {
      print("Exception - cookiesPolicyModel.dart - Cookies.fromJson():" + e.toString());
    }
  }
}
