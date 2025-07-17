class AttributeModel {
  late String name;
  late String description;
  late List<String> values;
  late String display;
  late int expanded;
  late int attributeId;
  late String suffix;

  AttributeModel({
    required this.name,
    required this.description,
    required this.values,
    required this.display,
    required this.expanded,
    required this.attributeId,
    required this.suffix
  });

  AttributeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    values = json['values'].cast<String>();
    display = json['display'];
    expanded = json['expanded'];
    attributeId = json['attribute_id'];
    suffix = json['suffix'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['values'] = values;
    data['display'] = display;
    data['expanded'] = expanded;
    data['attribute_id'] = attributeId;
    data['suffix'] = suffix;
    return data;
  }
}