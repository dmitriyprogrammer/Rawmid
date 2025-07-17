class CategoryNewsModel {
  late String id;
  late String name;
  late String image;

  CategoryNewsModel({required this.id, required this.name, required this.image});

  CategoryNewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}