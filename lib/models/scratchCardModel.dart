class ScratchCard{
  int? id;
  int? user_id;
  int? scratch_id;
  String? earning;
  int? earn_points;
  late bool is_scratch;
  DateTime? created_at;
  String? scratch_card_image;

 ScratchCard();

  ScratchCard.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      user_id = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
       scratch_id = json['scratch_id'] != null ? int.parse('${json['scratch_id']}') : null;
      earning = json['earning'] != null ? json['earning'] : null;
      earn_points = json['earn_points'] != null ? int.parse('${json['earn_points']}') : null;
      is_scratch = json['is_scratch'] != null && int.parse('${json['is_scratch']}') == 0 ? false : true;
      scratch_card_image = json['scratch_card_image'] != null ? json['scratch_card_image'] : null;
           created_at = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    } catch (e) {
      print("Exception - scratchCardModel.dart - ScratchCard.fromJson():" + e.toString());
    }
  }

}