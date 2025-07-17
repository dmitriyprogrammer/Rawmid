import 'package:rawmid/model/home/product.dart';

class NewsModel {
  late String id;
  late String title;
  late String image;
  late String text;
  late String time;
  late String date;
  late String link;
  String? youtubeLink;
  int? status;
  List<Steps>? steps;
  List<Energy>? energy;
  List<Ingredients>? ingredients;
  List<ProductModel>? products;
  String? moderate;
  bool? recipe;
  bool? survey;

  NewsModel({required this.id, this.steps, this.energy, this.ingredients, required this.title, required this.image, required this.text, required this.date, required this.time, required this.link, this.moderate, this.youtubeLink, this.status, this.products, this.recipe, this.survey});

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    text = json['text'];
    date = json['date_added'];
    link = json['link'];
    youtubeLink = json['youtube_link'];
    status = json['status'];
    moderate = json['moderate'];
    recipe = json['recipe'] ?? false;
    survey = json['survey'] ?? false;

    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(Steps.fromJson(v));
      });
    }
    if (json['energy'] != null && json['energy'].isNotEmpty) {
      energy = <Energy>[];
      json['energy'].forEach((v) {
        energy!.add(Energy.fromJson(v));
      });
      final last = energy!.last;
      energy!.removeLast();
      energy!.insert(0, last);
    }
    if (json['ingredients_one'] != null) {
      ingredients = <Ingredients>[];
      json['ingredients_one'].forEach((v) {
        ingredients!.add(Ingredients.fromJson(v));
      });
    }
    if (json['products'] != null && json['products'].isNotEmpty) {
      products = <ProductModel>[];
      json['products'].forEach((v) {
        products!.add(ProductModel.fromJson(v));
      });
    }
    if (json['ingredients_two'] != null) {
      json['ingredients_two'].forEach((v) {
        ingredients!.add(Ingredients.fromJson(v));
      });
    }

    if (json['prep_time'] != null) {
      time = json['prep_time'];
    } else {
      time = getReadingTime('${json['text2'] ?? json['text']}${json['ingredients_one'] ?? ''}${json['ingredients_two'] ?? ''}${json['energy'] ?? ''}');
    }
  }

  String getReadingTime(String text, {int wpm = 180}) {
    String cleanText = text.replaceAll(RegExp(r'<[^>]*>'), '');

    Map<String, String> htmlEntities = {
      '&nbsp;': ' ',
      '&lt;': '<',
      '&gt;': '>',
      '&amp;': '&',
      '&quot;': '"',
      '&#39;': "'",
    };
    htmlEntities.forEach((key, value) {
      cleanText = cleanText.replaceAll(key, value);
    });

    cleanText = cleanText.replaceAll(RegExp(r'\s+'), ' ').trim();

    List<String> words = RegExp(r'[А-Яа-яA-Za-z0-9]+', unicode: true)
        .allMatches(cleanText)
        .map((match) => match.group(0)!)
        .toList();

    int wordCount = words.length;

    if (wordCount == 0) return '';

    int totalSeconds = (wordCount / (wpm / 60)).round();

    if (totalSeconds >= 3600) {
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;
      return "$hours ч. $minutes мин.";
    }

    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    return minutes > 0 ? "$minutes мин.${seconds > 0 ? ' $seconds сек.' : ''}" : '$seconds сек.';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['text'] = text;
    data['date_added'] = date;
    data['time'] = time;
    data['link'] = link;
    data['youtube_link'] = youtubeLink;
    data['status'] = status;
    data['moderate'] = moderate;
    data['recipe'] = recipe;
    data['survey'] = survey;

    if (steps != null) {
      data['steps'] = steps!.map((v) => v.toJson()).toList();
    }
    if (energy != null) {
      data['energy'] = energy!.map((v) => v.toJson()).toList();
    }
    if (ingredients != null) {
      data['ingredients_one'] =
          ingredients!.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      data['products'] =
          products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Steps {
  String? text;
  String? image1;
  String? image2;

  Steps({this.text, this.image1, this.image2});

  Steps.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    image1 = json['image1'];
    image2 = json['image2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['image1'] = image1;
    data['image2'] = image2;
    return data;
  }
}

class Energy {
  late final String title;
  late final String text;

  Energy({required this.title, required this.text});

  Energy.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    text = json['text'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['text'] = text;
    return data;
  }
}

class Ingredients {
  late final String title;
  late final String text;

  Ingredients({required this.title, required this.text});

  Ingredients.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['text'] = text;
    return data;
  }
}