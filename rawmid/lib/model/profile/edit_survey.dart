import '../club/recipe_product.dart';

class EditSurveyModel {
  late String id;
  late String name;
  late String description;
  late String image;
  late String youtubeLink;
  late List<SurveyStep> steps;
  late List<RecipeProductModel> products;

  EditSurveyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.youtubeLink,
    required this.steps,
    required this.products
  });

  EditSurveyModel.fromJson(Map<String, dynamic> json) {
    id = json['survey_id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    youtubeLink = json['youtube_link'];
    steps = <SurveyStep>[];
    products = <RecipeProductModel>[];

    if (json['survey_steps'] != null) {
      for (var i in json['survey_steps']) {
        steps.add(SurveyStep.fromJson(i));
      }
    }

    if (json['products'] != null) {
      for (var i in json['products']) {
        products.add(RecipeProductModel.fromJson(i));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recipe_id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['youtube_link'] = youtubeLink;
    data['survey_steps'] = steps;
    data['products'] = products;
    return data;
  }
}

class SurveyStep {
  String? id;
  String? text;
  String? title;
  String? image;

  SurveyStep({this.id, this.text, this.title, this.image});

  SurveyStep.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['title'] = title;
    data['image'] = image;
    return data;
  }
}