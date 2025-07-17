import 'package:rawmid/model/checkout/pvz.dart';

class ShippingModel {
  late String code;
  late String title;
  List<Pvz>? more;
  late List<Quote> quote;
  late bool error;

  ShippingModel({required this.code, required this.title, this.more, required this.quote, required this.error});

  ShippingModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    if (json['more_data'] != null) {
      more = <Pvz>[];
      json['more_data'].forEach((v) {
        more!.add(Pvz.fromJson(v));
      });
    }
    if (json['quote'] != null) {
      quote = <Quote>[];
      json['quote'].forEach((v) {
        quote.add(Quote.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['title'] = title;
    if (more != null) {
      data['more_data'] = more!.map((v) => v.toJson()).toList();
    }
    data['quote'] = quote.map((v) => v.toJson()).toList();
    data['error'] = error;
    return data;
  }
}

class Quote {
  late String code;
  late String title;
  late int cost;
  late int taxClassId;
  late String text;
  late String description;
  late String id;

  Quote({required this.code, required this.title, required this.cost, required this.taxClassId, required this.text, required this.description, required this.id});

  Quote.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    cost = int.tryParse('${json['cost']}') ?? 0;
    taxClassId = int.tryParse('${json['tax_class_id']}') ?? 0;
    text = json['text'];
    description = json['description'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['title'] = title;
    data['cost'] = cost;
    data['tax_class_id'] = taxClassId;
    data['text'] = text;
    data['description'] = description;
    data['id'] = id;
    return data;
  }
}
