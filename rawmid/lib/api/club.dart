import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../model/club/club.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';

class ClubApi {
  static Future<Map<String, dynamic>> getAchievements() async {
    try {
      final response = await http.get(Uri.parse(getAchievementsUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);
      return json;
    } catch (e) {
      debugPrint(e.toString());
    }

    return {};
  }

  static Future<ClubModel?> getClub() async {
    try {
      final response = await http.get(Uri.parse(getClubUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);
      return ClubModel.fromJson(json['club']);
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}