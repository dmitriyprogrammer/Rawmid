class ProductAutocompleteModel {
  late String id;
  late String name;
  late bool noSer;
  late String model;

  ProductAutocompleteModel({required this.id, required this.name, required this.noSer, required this.model});

  ProductAutocompleteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    noSer = json['no_sernum'];
    model = json['model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['no_sernum'] = noSer;
    data['model'] = model;
    return data;
  }
}