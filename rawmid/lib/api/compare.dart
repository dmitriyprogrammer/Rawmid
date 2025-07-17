import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constant.dart';
import '../utils/helper.dart';

class CompareApi {
  static Future<Map<String, dynamic>> getCompares(String ids) async {
    Map<String, dynamic> items = {};

    try {
      final response = await http.post(Uri.parse(comparesUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'ids': ids});
      final json = jsonDecode(response.body);

      if (json['products'] != null) {
        return json;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }
}