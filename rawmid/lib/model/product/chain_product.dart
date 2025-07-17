class ChainProductModel {
  late String name;
  late String image;
  late String productId;
  late String model;
  late String priceStr;
  late String specialStr;
  late int price;
  late int special;

  ChainProductModel({required this.name, required this.image, required this.productId, required this.model, required this.priceStr, required this.specialStr, required this.price, required this.special});

  ChainProductModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    productId = json['product_id'];
    model = json['model'];
    priceStr = json['price_str'];
    specialStr = json['special_str'];
    price = json['price'];
    special = json['special'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['product_id'] = productId;
    data['model'] = model;
    data['price_str'] = priceStr;
    data['special_str'] = specialStr;
    data['price'] = price;
    data['special'] = special;
    return data;
  }
}