import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:rawmid/model/checkout/bb_location.dart';
import 'package:rawmid/model/checkout/checkout.dart';
import 'package:rawmid/model/home/product.dart';
import 'package:rawmid/utils/helper.dart';
import '../model/checkout/bb_item.dart';
import '../model/checkout/order.dart';
import '../utils/constant.dart';

class CheckoutApi {
  static Future<List<ProductModel>> getAccProducts() async {
    List<ProductModel> items = [];

    try {
      final response = await http.get(Uri.parse(getAccProductsUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

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

  static Future<CheckoutModel?> getCheckout(String city, bool update, {String countryId = ''}) async {
    try {
      final response = await http.get(Uri.parse('$getCheckoutUrl&city=$city&update=${update ? '1' : '0'}&country_id=$countryId'), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);

      if (json['error'] != null) {
        Helper.snackBar(error: true, text: json['error']);
        return null;
      }

      if (json['checkout'] != null) {
        return CheckoutModel.fromJson(json['checkout']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<Point?> getCityCoordinates(String cityName) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$cityName&format=json&limit=1');
    final response = await http.get(url, headers: {'User-Agent': 'FlutterApp'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        return Point(latitude: lat, longitude: lon);
      }
    }
    return null;
  }

  static Future<bool> getPayStatus(String id) async {
    try {
      final response = await http.get(Uri.parse('$getPayStatusUrl&order_id=$id'), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);
      return json ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<List<BBItemModel>> getBBPvz() async {
    List<BBItemModel> items = [];

    try {
      final response = await http.get(Uri.parse(getBbPvzUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);

      if (json['om']['features'] != null) {
        for (var i in json['om']['features']) {
          items.add(BBItemModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<CheckoutModel?> setCheckout(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(setCheckoutUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);

      final json = jsonDecode(response.body);

      if (json['error'] != null) {
        Helper.snackBar(error: true, text: json['error']);
        return null;
      }

      if (json['checkout'] != null) {
        return CheckoutModel.fromJson(json['checkout']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<OrderModel?> checkout(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(checkoutUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: jsonEncode(body));

      final json = jsonDecode(response.body);

      if (json['error'] != null) {
        Helper.snackBar(error: true, text: json['error']);
      }

      if (json['order_id'] != null) {
        return OrderModel.fromJson(json);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<OrderModel?> checkout2(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(checkout2Url), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: jsonEncode(body));

      final json = jsonDecode(response.body);

      if (json['error'] != null) {
        Helper.snackBar(error: true, text: json['error']);
      }

      if (json['order_id'] != null) {
        return OrderModel.fromJson(json);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<BbLocationModel?> setBbPvz(String pvzId) async {
    try {
      final response = await http.get(Uri.parse('$bbPvzUrl&pvz_id=$pvzId'), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);

      return BbLocationModel.fromJson(json);
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}