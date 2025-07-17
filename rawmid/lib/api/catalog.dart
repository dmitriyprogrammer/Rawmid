import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:rawmid/model/catalog/category.dart';
import 'package:rawmid/model/home/banner.dart';
import 'package:rawmid/model/home/product.dart';
import '../model/catalog/category_item.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';

class CatalogApi {
  static Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> items = [];

    try {
      final response = await http.get(Uri.parse(categoriesUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['categories'] != null) {
        for (var i in json['categories']) {
          items.add(CategoryModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<ProductModel>> getSpecials() async {
    List<ProductModel> items = [];

    try {
      final response = await http.get(Uri.parse(specialUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['specials'] != null) {
        for (var i in json['specials']) {
          items.add(ProductModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<BannerModel>> getPredloz() async {
    List<BannerModel> items = [];

    try {
      final response = await http.get(Uri.parse(ocoXUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['banners'] != null) {
        for (var i in json['banners']) {
          items.add(BannerModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<CategoryItemModel?> getCategory(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(categoryUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      return CategoryItemModel.fromJson(json);
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<MapEntry<int, List<ProductModel>>> loadProducts(Map<String, dynamic> body) async {
    MapEntry<int, List<ProductModel>> map = MapEntry(0, []);

    try {
      final response = await http.post(Uri.parse(loadProductsUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: jsonEncode(body));
      final json = jsonDecode(response.body);

      if (json['products'] != null) {
        List<ProductModel> items = [];

        for (var i in json['products']) {
          items.add(ProductModel.fromJson(i));
        }

        map = MapEntry(int.tryParse('${json['total']}') ?? 0, items);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return map;
  }

  static Future<Map<String, dynamic>> loadSpecialProducts(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(loadSpecialProductsUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: jsonEncode(body));
      final json = jsonDecode(response.body);

      if (json['products'] != null) {
        return json;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return {};
  }
}