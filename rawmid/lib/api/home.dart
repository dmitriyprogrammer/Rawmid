import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:rawmid/model/home/banner.dart';
import 'package:rawmid/model/home/news.dart';
import '../model/home/product.dart';
import '../model/home/rank.dart';
import '../model/home/search.dart';
import '../model/home/special.dart';
import '../model/location.dart';
import '../model/product/product_autocomplete.dart';
import '../model/profile/sernum.dart';
import '../model/profile/sernum_support.dart';
import '../model/support/contact.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';

class HomeApi {
  static Future<Map<String, String>> getCityByIP() async {
    try {
      final response = await http.get(Uri.parse('http://ip-api.com/json/?lang=ru'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['city'] != null) {
          await http.post(Uri.parse(changeRegionUrl), headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
          }, body: {'city': data['city']!});
        }

        return {'city': data['city'] ?? '', 'code': data['countryCode'] ?? ''};
      }

    } catch (e) {
      debugPrint(e.toString());
    }

    return {};
  }

  static Future<Map<String, dynamic>> changeCityByCity(String city) async {
    try {
      final response = await http.post(Uri.parse(changeRegionUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'city': city});
      final data = jsonDecode(response.body);

      if (data['code'] != null) {
        return data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return {};
  }

  static Future<Map<String, dynamic>> changeCity(int fId) async {
    try {
      final response = await http.post(Uri.parse(changeRegionUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'fias_id': '$fId'});
      final data = jsonDecode(response.body);

      if (data['code'] != null) {
        return data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return {};
  }

  static Future<List<String>> searchAddress(String query, String city, String country) async {
    List<String> items = [];

    try {
      const String apiKey = '2f0980328dabb04ad1203cf872acf82ac55d77b5';
      const String url = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $apiKey'
        },
        body: jsonEncode({
          'query': query,
          'count': 5,
          "locations": [
            { "country": country, "city": city }
          ],
          'restrict_value': false,
          'language': 'ru'
        })
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final suggestions = data['suggestions'] as List;
        return suggestions.map((item) => item['value'] as String).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<Location>> searchCity(String query, {String countryId = '', int? level = 0}) async {
    List<Location> items = [];

    try {
      final response = await http.get(Uri.parse('$searchCityUrl$query&country_id=$countryId${level != null ? '&level=$level' : ''}'), headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      });

      final extractedJson = response.body.replaceAll(RegExp(r'^[^(]*\(|\);?$'), '');
      List<dynamic> jsonList = jsonDecode(extractedJson);
      items = jsonList.map((e) => Location.fromJson(e)).toList();
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<BannerModel>> getBanner(Map<String, dynamic> body) async {
    List<BannerModel> items = [];

    try {
      final response = await http.post(Uri.parse(getBannerUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);

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

  static Future<SearchModel?> search(String query) async {
    try {
      final response = await http.post(Uri.parse(searchUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'query': query});
      final json = jsonDecode(response.body);

      if (json['search'] != null) {
        return SearchModel.fromJson(json['search']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<MapEntry<String, String>> getUrlType(String link) async {
    try {
      final response = await http.post(Uri.parse(getUrlTypeUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'link': link});
      final json = jsonDecode(response.body);

      return MapEntry(json?['type'] ?? '', '${json?['category'] ?? json?['id'] ?? ''}');
    } catch (e) {
      debugPrint(e.toString());
    }

    return MapEntry('', '');
  }

  static Future<bool> saveToken(String token) async {
    try {
      final response = await http.post(Uri.parse(saveTokenUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'token': token, 'app': Platform.isAndroid ? 'android' : 'apple'});
      final json = jsonDecode(response.body);

      return json['success'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<List<RankModel>> getRanks() async {
    List<RankModel> items = [];

    try {
      final response = await http.get(Uri.parse(getRanksUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['ranks'] != null) {
        for (var i in json['ranks']) {
          items.add(RankModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<ProductModel>> getFeatured() async {
    List<ProductModel> items = [];

    try {
      final response = await http.get(Uri.parse(getFeaturedUrl), headers: {
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

  static Future<List<String>> getOrderIds() async {
    List<String> items = [];

    try {
      final response = await http.get(Uri.parse(getOrderIdsUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['ids'] != null) {
        for (var i in json['ids']) {
          items.add('$i');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<SernumSupportModel>> getSernumSupport() async {
    List<SernumSupportModel> items = [];

    try {
      final response = await http.get(Uri.parse(getSernumSupportUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['sernums'] != null) {
        for (var i in json['sernums']) {
          items.add(SernumSupportModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<ContactMapData?> getContact(String city) async {
    try {
      final response = await http.get(Uri.parse('$contactsUrl&city=$city'), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);
      return ContactMapData.fromJson(json);
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<List<SernumModel>> getSernum() async {
    List<SernumModel> items = [];

    try {
      final response = await http.get(Uri.parse(getSernumUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['products'] != null) {
        for (var i in json['products']) {
          items.add(SernumModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<ProductAutocompleteModel>> getAutocomplete(Map<String, dynamic> body) async {
    List<ProductAutocompleteModel> items = [];

    try {
      final response = await http.post(Uri.parse(getAutocompleteUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);

      final json = jsonDecode(response.body);

      if (json['products'] != null) {
        for (var i in json['products']) {
          items.add(ProductAutocompleteModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<bool> registerProduct(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(registerProductUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if ((json['error'] ?? '').isEmpty) {
        return true;
      } else {
        Helper.snackBar(error: true, text: '${json['error']}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<String> warrantyProduct(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(warrantyProductUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if ((json['warranty'] ?? '').isNotEmpty) {
        return '${json['warranty']}';
      } else {
        Helper.snackBar(error: true, text: '${json['error']}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return '';
  }

  static Future<List<ProductModel>> getViewed(List<String> pids) async {
    List<ProductModel> items = [];

    try {
      final response = await http.post(Uri.parse(getViewedUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'pids': pids.join(',')});
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

  static Future<List<SpecialModel>> getRecords() async {
    List<SpecialModel> items = [];

    try {
      final response = await http.get(Uri.parse(getRecordsUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['records'] != null) {
        for (var i in json['records']) {
          items.add(SpecialModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<NewsModel>> getNews() async {
    List<NewsModel> items = [];

    try {
      final response = await http.get(Uri.parse(getNewsUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['news'] != null) {
        for (var i in json['news']) {
          items.add(NewsModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<NewsModel>> getRecipes() async {
    List<NewsModel> items = [];

    try {
      final response = await http.get(Uri.parse(getRecipesUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);

      if (json['news'] != null) {
        for (var i in json['news']) {
          items.add(NewsModel.fromJson(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }
}