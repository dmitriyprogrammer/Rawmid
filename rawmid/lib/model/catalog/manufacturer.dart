class ManufacturerModel {
  late String id;
  late String name;

  ManufacturerModel({required this.id, required this.name});

  ManufacturerModel.fromJson(Map<String, dynamic> json) {
    id = json['manufacturer_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['manufacturer_id'] = id;
    data['name'] = name;
    return data;
  }
}