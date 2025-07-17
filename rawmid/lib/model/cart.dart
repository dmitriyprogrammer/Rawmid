class CartModel {
  late String id;
  late String name;
  late String image;
  late String price;
  late String key;
  int? quantity;
  late String color;
  late String hdd;

  CartModel({required this.id, required this.name, required this.image, required this.price, required this.key, required this.quantity, required this.color, required this.hdd});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    key = '${json['key']}';
    quantity = int.tryParse('${json['quantity']}') ?? 1;
    color = json['color'];
    hdd = json['hdd'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['price'] = price;
    data['key'] = key;
    data['quantity'] = quantity;
    data['color'] = color;
    data['hdd'] = hdd;
    return data;
  }
}