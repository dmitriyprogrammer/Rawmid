class CompareProductModel {
  late String id;
  late String image;
  late String name;
  late String price;
  late String special;
  late String model;
  late String manufacturer;
  late String availability;
  late String category;
  late int rating;
  late String color;
  late List<AttributeModel> attributes;

  CompareProductModel(
      {required this.id,
        required this.image,
        required this.name,
        required this.price,
        required this.special,
        required this.model,
        required this.manufacturer,
        required this.availability,
        required this.category,
        required this.rating,
        required this.color,
        required this.attributes});

  CompareProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    price = json['price'];
    special = json['special'];
    model = json['model'];
    manufacturer = json['manufacturer'];
    availability = json['availability'];
    category = json['category'];
    rating = int.tryParse('${json['rating']}') ?? 0;
    color = json['color'];
    attributes = <AttributeModel>[];
    
    if (json['attributes'] != null) {
      for (var i in json['attributes']) {
        attributes.add(AttributeModel.fromJson(i));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['price'] = price;
    data['special'] = special;
    data['model'] = model;
    data['manufacturer'] = manufacturer;
    data['availability'] = availability;
    data['category'] = category;
    data['rating'] = rating;
    data['color'] = color;
    data['attributes'] = attributes;
    return data;
  }
}

class AttributeModel {
  late String name;
  late dynamic text;

  AttributeModel(
      {required this.name,
        required this.text});

  AttributeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['text'] = text;
    return data;
  }
}
