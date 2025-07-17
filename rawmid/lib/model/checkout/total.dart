class TotalModel {
  final String code;
  final String title;
  final String text;
  final double value;
  final String sortOrder;

  TotalModel({
    required this.code,
    required this.title,
    required this.text,
    required this.value,
    required this.sortOrder,
  });

  factory TotalModel.fromJson(Map<String, dynamic> json) {
    return TotalModel(
      code: json['code'],
      title: json['title'],
      text: json['text'],
      value: double.tryParse('${json['value']}') ?? 0,
      sortOrder: json['sort_order'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'text': text,
      'value': value,
      'sort_order': sortOrder,
    };
  }
}