import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/order_history.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';

class OrderApi {
  static Future<List<OrdersModel>> order() async {
    List<OrdersModel> items = [];

    try {
      final response = await http.get(Uri.parse(getOrdersUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['orders'] != null) {
        for (var i in json['orders']) {
          items.add(OrdersModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<OrdersModel?> getOrder(int id) async {
    try {
      final response = await http.post(Uri.parse(getOrderUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'id': '$id'});
      final json = jsonDecode(response.body);

      if (json['order'] != null) {
        return OrdersModel.fromJson(json['order']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<bool> cancelOrder(String id) async {
    try {
      final response = await http.post(Uri.parse(orderCancelUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'id': id});
      final json = jsonDecode(response.body);
      return json['success'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<String> printStr(String link) async {
    try {
      final request = http.Request('GET', Uri.parse(link));
      request.headers.addAll({'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'});
      http.StreamedResponse response = await request.send();
      return await response.stream.bytesToString();
    } catch (e) {
      debugPrint(e.toString());
    }

    return '';
  }
}