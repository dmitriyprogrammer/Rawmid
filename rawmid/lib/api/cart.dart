import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:rawmid/utils/helper.dart';
import '../model/cart.dart';
import '../utils/constant.dart';

class CartApi {
  static Future<List<CartModel>> getProducts() async {
    List<CartModel> items = [];

    try {
      final response = await http.get(Uri.parse(cartProductsUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);

      if (json['products'] != null) {
        for (var i in json['products']) {
          items.add(CartModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<String>> getWishlist() async {
    List<String> items = [];

    try {
      final response = await http.get(Uri.parse(getWishlistStrUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);

      if (json['wishlist'] != null) {
        for (var i in json['wishlist']) {
          items.add(i);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future addWishlist(List<String> items) async {
    try {
      await http.post(Uri.parse(addWishlistUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'wishlist': items.join(',')});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> getColors(String id) async {
    try {
      final response = await http.post(Uri.parse(checkColorsUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'product_id': id});
      final json = jsonDecode(response.body);

      return json['check'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<List<CartModel>> addCart(Map<String, dynamic> body) async {
    List<CartModel> items = [];

    try {
      final response = await http.post(Uri.parse(addCartUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return [];
      }

      if (json['products'] != null) {
        for (var i in json['products']) {
          items.add(CartModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future clear() async {
    try {
      await http.get(Uri.parse(clearUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<List<CartModel>> updateCart(Map<String, dynamic> body) async {
    List<CartModel> items = [];

    try {
      final response = await http.post(Uri.parse(updateCartUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return [];
      }

      if (json['products'] != null) {
        for (var i in json['products']) {
          items.add(CartModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }
}