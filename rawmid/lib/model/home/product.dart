import '../product/color.dart';
import '../profile/reviews.dart';

class ProductModel {
  late String id;
  late String title;
  late String image;
  late String category;
  late String color;
  late String model;
  List<ProductColor>? colors;
  List<MyReviewModel>? reviews;
  int? rating;
  int? sortOrder;
  String? price;
  String? hdd;
  String? special;
  List<String>? images;

  ProductModel({required this.id, required this.title, required this.image, required this.category, required this.color, required this.model, this.colors, this.reviews, this.rating, this.hdd, this.sortOrder, this.price, this.special, this.images});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['name'];
    image = json['image'];
    category = json['category'];
    color = json['color'];
    model = json['model'] ?? '';
    rating = json['rating'];
    sortOrder = json['sort_order'];
    hdd = json['hdd'];
    price = '${json['price'] != 0 ? json['price'] : ''}';
    special = '${json['special'] != 0 ? json['special'] : ''}';
    images = <String>[];
    colors = <ProductColor>[];
    reviews = <MyReviewModel>[];

    if (json['images'] != null) {
      for (var i in json['images']) {
        images!.add(i);
      }
    }

    if (json['colors'] != null) {
      for (var i in json['colors']) {
        colors!.add(ProductColor.fromJson(i));
      }
    }

    if (json['reviews'] != null) {
      for (var i in json['reviews']) {
        reviews!.add(MyReviewModel.fromJson(i));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = title;
    data['image'] = image;
    data['category'] = category;
    data['color'] = color;
    data['model'] = model;
    data['rating'] = rating;
    data['sort_order'] = sortOrder;
    data['hdd'] = hdd;
    data['price'] = price;
    data['special'] = special;
    data['images'] = images;
    data['colors'] = colors;
    data['reviews'] = reviews;
    return data;
  }
}