import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/home/product.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';

class WishlistApi {
  static Future<List<ProductModel>> getWishlist(String wishlist) async {
    List<ProductModel> items = [];

    try {
      final response = await http.post(Uri.parse(getWishlistUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'wishlist': wishlist});
      final json = jsonDecode(response.body);

      if (json['wishlist'] != null) {
        for (var i in json['wishlist']) {
          items.add(ProductModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }
}