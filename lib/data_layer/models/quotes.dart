class Quote {
  Quote({
    required this.quote,
  });
  late final String quote;

  Quote.fromJson(Map<String, dynamic> json) {
    quote = json['quote'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['quote'] = quote;
    return _data;
  }
}
