import 'package:rawmid/model/home/product.dart';

class ReviewModel {
  late String id;
  late String author;
  DateTime? date;
  late String text;
  late int rating;
  late List<ReviewModel> comments;
  late bool parent;
  bool checked = false;
  ProductModel? product;

  ReviewModel({required this.id, required this.author, this.date, required this.text, required this.rating, required this.comments, required this.parent, this.product});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    date = DateTime.tryParse('${json['date_added']}');
    text = json['text'];
    rating = json['rating'];
    parent = json['parent'];
    comments = <ReviewModel>[];
    if (json['comments'] != null) {
      for (var i in json['comments']) {
        comments.add(ReviewModel.fromJson(i));
      }
    }
    if (json['product'] != null && (json['product'] ?? []).isNotEmpty) {
      product = ProductModel.fromJson(json['product']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['author'] = author;
    data['date'] = date;
    data['text'] = text;
    data['rating'] = rating;
    data['parent'] = parent;
    data['comments'] = comments;
    data['product'] = product;
    return data;
  }
}