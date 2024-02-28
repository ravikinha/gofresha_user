class TermsAndCondition {
  int? id;
  String? termcondition;
  TermsAndCondition();
  TermsAndCondition.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      termcondition = json['termcondition'] != null ? json['termcondition'] : 'No policy found';
    } catch (e) {
      print("Exception - termsAndConditionModel.dart - TermsAndCondition.fromJson():" + e.toString());
    }
  }
}
