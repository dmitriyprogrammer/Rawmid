import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/blog.dart';
import 'package:rawmid/model/home/news.dart';

import '../api/home.dart';
import '../model/home/category_news.dart';
import '../utils/helper.dart';

class BlogController extends GetxController {
  var id = ''.obs;
  var isLoading = false.obs;
  var isRecipe = false.obs;
  var news = <NewsModel>[].obs;
  var featured = <NewsModel>[].obs;
  RxInt isChecked = (-1).obs;
  var revHeight = 0.0.obs;
  var activeIndex = 0.obs;
  final pageController = PageController(viewportFraction: 0.85);
  var categories = <CategoryNewsModel>[].obs;
  var myRecipes = (Get.parameters['my_recipes'] == '1');
  var mySurvey = (Get.parameters['mySurvey'] == '1');

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future setCategory(String id) async {
    this.id.value = id;
    isLoading.value = false;

    final api = await BlogApi.blog(isRecipe.value, id: id, myRecipes: myRecipes, mySurvey: mySurvey);
    news.clear();

    if (api.isNotEmpty) {
      for (var i in api['blog']['news'] ?? []) {
        news.add(NewsModel.fromJson(i));
      }
    }

    isLoading.value = true;
  }

  Future initialize() async {
    final fId = Helper.prefs.getInt('fias_id') ?? 0;

    if (fId > 0) {
      await HomeApi.changeCity(fId);
    }

    isRecipe.value = Get.arguments != null || Get.parameters['my_recipes'] == '1';

    if (Get.parameters['my_survey'] != '1') {
      final categories = await BlogApi.getCategoriesNews(isRecipe.value, myRecipes: Get.parameters['my_recipes'] == '1');
      this.categories.value = categories;

      final title = Get.parameters['my_recipes'] == '1' ? 'Мои рецепты' : Get.parameters['my_survey'] == '1' ? 'Мои обзоры' : isRecipe.value ? 'Рецепты' : 'Статьи';

      if (title == 'Статьи' && categories.where((e) => e.name == 'Обзоры').isEmpty) {
        categories.add(CategoryNewsModel(id: '0', name: 'Обзоры', image: ''));
      }
    }

    final api = await BlogApi.blog(Get.arguments != null || Get.parameters['my_recipes'] == '1', mySurvey: Get.parameters['my_survey'] == '1', myRecipes: Get.parameters['my_recipes'] == '1');

    if (api.isNotEmpty) {
      for (var i in api['blog']['news'] ?? []) {
        news.add(NewsModel.fromJson(i));
      }

      if (!isRecipe.value) {
        for (var i in api['blog']['featured'] ?? []) {
          featured.add(NewsModel.fromJson(i));
        }
      }
    }

    isLoading.value = true;
  }
}