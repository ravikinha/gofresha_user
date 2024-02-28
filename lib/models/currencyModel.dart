class Currency {
  dynamic currency_id;
  String? currency;
  String? currency_sign;

  Currency({this.currency_id, this.currency, this.currency_sign});

  Currency.fromJson(Map<String, dynamic> json) {
    try {
      currency_id = json['currency_id'] != null ? json['currency_id'] : null;
      currency = json['currency'] != null ? json['currency'] : null;
      currency_sign = json['currency_sign'] != null ? json['currency_sign'] : null;
    } catch (e) {
      print("Exception - currencyModel.dart - Currency.fromJson():" + e.toString());
    }
  }
}
