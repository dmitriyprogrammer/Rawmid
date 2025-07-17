import 'package:rawmid/model/catalog/category.dart';
import 'package:rawmid/model/home/product.dart';
import 'news.dart';

class SearchModel {
  late List<CategoryModel> categories;
  late List<ProductModel> products;
  late List<NewsModel> news;

  SearchModel({
    required this.products,
    required this.news
  });

  SearchModel.fromJson(Map<String, dynamic> json) {
    List<CategoryModel> items = [];

    if (json['categories'] != null) {
      for (var i in json['categories']) {
        items.add(CategoryModel.fromJson(i));
      }
    }

    categories = items;

    List<ProductModel> items2 = [];

    if (json['products'] != null) {
      for (var i in json['products']) {
        items2.add(ProductModel.fromJson(i));
      }
    }

    products = items2;

    List<NewsModel> items3 = [];

    if (json['news'] != null) {
      for (var i in json['news']) {
        items3.add(NewsModel.fromJson(i));
      }
    }

    news = items3;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories'] = categories;
    data['products'] = products;
    data['news'] = news;
    return data;
  }
}
