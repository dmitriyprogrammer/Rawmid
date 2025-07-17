class SernumSupportModel {
  final String model;
  final String sernum;

  SernumSupportModel({
    required this.model,
    required this.sernum
  });

  factory SernumSupportModel.fromJson(Map<String, dynamic> json) {
    return SernumSupportModel(
      model: json['model'] ?? '',
      sernum: json['sernum'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'sernum': sernum
    };
  }
}