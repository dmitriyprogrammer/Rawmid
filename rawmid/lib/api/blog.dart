import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rawmid/model/home/news.dart';
import '../model/home/category_news.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';

class BlogApi {
  static Future<Map<String, dynamic>> blog(bool recipe, {bool mySurvey = false, bool myRecipes = false, String id = ''}) async {
    try {
      final response = await http.get(Uri.parse('$getBlogUrl&recipe=${recipe ? 1 : 0}${id == '0' ? '&survey=1' : ''}${mySurvey ? '&mySurvey=1' : ''}${myRecipes ? '&myRecipes=1' : ''}${id.isNotEmpty ? '&id=$id' : ''}'), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if ((json['blog']?['news'] ?? []).isNotEmpty) {
        return json;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return {};
  }

  static Future<NewsModel?> getNew(String id, bool recipe, bool survey) async {
    try {
      final response = await http.post(Uri.parse(getNewUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'id': id, 'recipe': '${recipe ? 1 : 0}', 'survey': '${survey ? 1 : 0}'});
      final json = jsonDecode(response.body);

      if (json['record'] != null) {
        return NewsModel.fromJson(json['record']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<List<CategoryNewsModel>> getCategoriesNews(bool recipe, {bool myRecipes = false}) async {
    var items = <CategoryNewsModel>[];

    try {
      final response = await http.get(Uri.parse('$getCategoriesRecipeUrl&recipe=${recipe ? 1 : 0}${myRecipes ? '&myRecipes=1' : ''}'), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['categories'] != null) {
        for (var i in json['categories']) {
          items.add(CategoryNewsModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }
}