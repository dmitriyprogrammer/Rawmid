class CategoryModel {
  late String id;
  late String name;
  late String image;
  List<CategoryModel>? children;

  CategoryModel({required this.id, required this.name, required this.image, this.children});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];

    if ((json['children'] ?? []).isNotEmpty) {
      List<CategoryModel> items = [];

      for (var i in json['children']) {
        items.add(CategoryModel.fromJson(i));
      }

      children = items;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['children'] = children;
    return data;
  }
}