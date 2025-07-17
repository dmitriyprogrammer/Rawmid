class AttributeProductModel {
  late String attributeId;
  late String name;
  late String text;
  late String description;

  AttributeProductModel({required this.attributeId, required this.name, required this.text, required this.description});

  AttributeProductModel.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id'];
    name = json['name'];
    text = json['text'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attribute_id'] = attributeId;
    data['name'] = name;
    data['text'] = text;
    data['description'] = description;
    return data;
  }
}