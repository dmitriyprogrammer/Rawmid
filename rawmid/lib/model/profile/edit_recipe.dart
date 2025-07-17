import 'package:rawmid/model/home/news.dart';
import '../club/recipe_product.dart';

class EditRecipeModel {
  late List<RecipeCategory> categories;
  EditRecipe? recipe;

  EditRecipeModel({required this.categories, required this.recipe});

  EditRecipeModel.fromJson(Map<String, dynamic> json) {
    categories = [];

    for (var i in json['categories']) {
      categories.add(RecipeCategory.fromJson(i));
    }

    if (json['recipe'] != null) {
      recipe = EditRecipe.fromJson(json['recipe']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories'] = categories;
    data['recipe'] = recipe;
    return data;
  }
}

class RecipeCategory {
  late String id;
  late String name;

  RecipeCategory({required this.id, required this.name});

  RecipeCategory.fromJson(Map<String, dynamic> json) {
    id = json['recipe_category_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recipe_category_id'] = id;
    data['name'] = name;
    return data;
  }
}

class EditRecipe {
  late String id;
  late String name;
  late String description;
  late String tag;
  late String image;
  late String youtubeLink;
  late List<Ingredients> ingredients;
  late List<Energy> energy;
  late List<String> recipeTip;
  late List<Steps> steps;
  late List<String> recipeCategories;
  late List<RecipeProductModel> recipeProducts;

  EditRecipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.energy,
    required this.tag,
    required this.image,
    required this.youtubeLink,
    required this.recipeTip,
    required this.steps,
    required this.recipeCategories,
    required this.recipeProducts
  });

  EditRecipe.fromJson(Map<String, dynamic> json) {
    id = json['recipe_id'];
    name = json['name'];
    description = json['description'];
    tag = json['tag'];
    image = json['image'];
    youtubeLink = json['youtube_link'];
    ingredients = <Ingredients>[];
    energy = <Energy>[];
    recipeTip = <String>[];
    steps = <Steps>[];
    recipeCategories = <String>[];
    recipeProducts = <RecipeProductModel>[];

    if (json['ingredients'] != null && json['ingredients'] != false) {
      for (var i in json['ingredients']) {
        ingredients.add(Ingredients.fromJson(i));
      }
    }

    if (json['energy'] != null && json['energy'] != false) {
      for (var i in json['energy']) {
        energy.add(Energy.fromJson(i));
      }
    }

    if (json['recipe_tip'] != null) {
      for (var i in json['recipe_tip'].split(',')) {
        recipeTip.add(i);
      }
    }

    if (json['steps'] != null) {
      for (var i in json['steps']) {
        steps.add(Steps.fromJson(i));
      }
    }

    if (json['recipe_categories'] != null) {
      for (var i in json['recipe_categories']) {
        recipeCategories.add('$i');
      }
    }

    if (json['products'] != null) {
      for (var i in json['products']) {
        recipeProducts.add(RecipeProductModel.fromJson(i));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recipe_id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['ingredients'] = ingredients;
    data['energy'] = energy;
    data['tag'] = tag;
    data['image'] = image;
    data['youtube_link'] = youtubeLink;
    data['recipe_tip'] = recipeTip;
    data['steps'] = steps;
    data['recipe_categories'] = recipeCategories;
    data['recipe_products'] = recipeProducts;
    return data;
  }
}