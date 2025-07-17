import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:rawmid/model/home/product.dart';
import 'package:rawmid/model/product/review.dart';
import '../model/cart.dart';
import '../model/product/product_item.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';
import 'package:get/get.dart';

class ProductApi {
  static Future<ProductItemModel?> getProduct(String id) async {
    try {
      final response = await http.post(Uri.parse(productUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'product_id': id});

      final json = jsonDecode(response.body);

      if (json != null && json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return null;
      }

      if (json != null && json['product'] != null) {
        return ProductItemModel.fromJson(json['product']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<bool> getSerNum(String num, String id) async {
    try {
      final response = await http.post(Uri.parse(getSerNumUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'num': num, 'id': id});

      final json = jsonDecode(response.body);

      if ((json['error'] ?? '').isNotEmpty) {
        Helper.snackBar(error: true, html: json['error'], callback: Get.back);
        return false;
      } else {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<List<ProductModel>> getAccessories(String id) async {
    List<ProductModel> items = [];

    try {
      final response = await http.post(Uri.parse(getAccessoriesUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'product_id': id});
      final json = jsonDecode(response.body);

      if (json != null && json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return [];
      }

      if (json['products'] != null) {
        for (var i in json['products']) {
          items.add(ProductModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<ReviewModel>> getReviews(String id, {bool mes = true}) async {
    List<ReviewModel> items = [];

    try {
      final response = await http.post(Uri.parse(getReviewsUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'product_id': id});
      final json = jsonDecode(response.body);

      if (json != null && json['message'] != null && mes) {
        Helper.snackBar(error: true, text: json['message']);
        return [];
      }

      if (json['reviews'] != null) {
        for (var i in json['reviews']) {
          items.add(ReviewModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<String> yPay(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse('https://pay.yandex.ru/api/merchant/v1/orders'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Api-Key 2c8f4476a851429e89c6f5ffef02a3f1.UektewWGq_SauUCWSSMz0JJe3b6L-1LO'
      }, body: jsonEncode(body));
      final json = jsonDecode(response.body);

      if (json['status'] == 'fail') {
        Helper.snackBar(error: true, text: json['reason'] ?? json['reasonCode']);
        return '';
      }

      if ((json['data']?['paymentUrl'] ?? '').isNotEmpty) {
        return json['data']['paymentUrl'];
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return '';
  }

  static Future<List<CartModel>> addChainCart(Map<String, dynamic> body) async {
    List<CartModel> items = [];

    try {
      final response = await http.post(Uri.parse(addChainCartUrl), headers: {
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

  static Future<bool> addQuestion(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(addQuestionUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if (json['error'] != null) {
        Helper.snackBar(error: true, text: json['error']);
        return false;
      }

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message'], callback: Get.back);
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> addQuestionOther(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(addQuestionOtherUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if (json['error'] != null) {
        Helper.snackBar(error: true, text: json['error']);
        return false;
      }

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message'], callback2: Get.back);
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> addReview(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(addReviewUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if (json['error'] != null) {
        Helper.snackBar(error: true, text: json['error']);
        return false;
      }

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message'], callback2: Get.back);
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> addComment(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(addCommentUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if (json['error'] != null) {
        Helper.snackBar(error: true, text: json['error']);
        return false;
      }

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message'], hide: true);
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> addQuestionComment(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(addQuestionCommentUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if (json['error'] != null) {
        Helper.snackBar(error: true, text: json['error']);
        return false;
      }

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message'], hide: true);
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> addX(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(addXUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if (json['error'] != null) {
        Helper.snackBar(error: true, text: json['error']);
        return false;
      }

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message'], callback2: Get.back);
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }
}