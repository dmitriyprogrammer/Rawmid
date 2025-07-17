import 'package:rawmid/model/product/review.dart';
import '../home/news.dart';

class ClubModel {
  late List<ReviewModel> reviews;
  late List<NewsModel> recipes;
  late List<NewsModel> news;

  ClubModel({required this.reviews, required this.recipes, required this.news});

  ClubModel.fromJson(Map<String, dynamic> json) {
    List<ReviewModel> items = [];

    if (json['reviews'] != null) {
      for (var i in json['reviews']) {
        items.add(ReviewModel.fromJson(i));
      }
    }

    reviews = items;

    List<NewsModel> items2 = [];

    if (json['recipes'] != null) {
      for (var i in json['recipes']) {
        items2.add(NewsModel.fromJson(i));
      }
    }

    recipes = items2;

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
    data['reviews'] = reviews;
    data['recipes'] = recipes;
    data['news'] = news;
    return data;
  }
}