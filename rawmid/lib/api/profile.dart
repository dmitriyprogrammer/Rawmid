import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rawmid/model/country.dart';
import 'package:rawmid/model/profile/edit_survey.dart';
import 'package:rawmid/model/support/question.dart';
import '../model/home/product.dart';
import '../model/profile/edit_recipe.dart';
import '../model/profile/profile.dart';
import '../model/profile/reward.dart';
import '../utils/constant.dart';
import '../utils/helper.dart';

class ProfileApi {
  static Future<ProfileModel?> user() async {
    try {
      final response = await http.get(Uri.parse(userUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);

      if (json['user'] != null) {
        return ProfileModel.fromJson(json['user']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<EditRecipeModel?> getRecipe({String id = ''}) async {
    try {
      final response = await http.get(Uri.parse('$getRecipeUrl&recipe_edit_id=$id'), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);
      return EditRecipeModel.fromJson(json);
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<EditSurveyModel?> getSurvey({String id = ''}) async {
    try {
      final response = await http.get(Uri.parse('$getSurveyUrl&survey_edit_id=$id'), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);
      return EditSurveyModel.fromJson(json['survey']);
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<String> editSurvey(Map<String, dynamic> body, File? image, List<File> images) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(editSurveyUrl));

      final count = images.length;

      for (var x = 0; x < count; x++) {
        if (images[x].path.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath(
              'survey_steps[$x][image_file]',
              images[x].path
          ));
        }
      }

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'image_file',
            image.path
        ));
      }

      request.headers.addAll({
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      request.fields['body'] = jsonEncode(body);

      final response = await request.send();
      final json = jsonDecode(await response.stream.bytesToString());
      return '${json?['id'] ?? ''}';
    } catch (e) {
      debugPrint(e.toString());
    }

    return '';
  }

  static Future<String> editRecipe(Map<String, dynamic> body, File? image, Map<String, File?> images) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(editRecipeUrl));

      final count = images.length;

      for (var x = 0; x < count; x++) {
        if (images['image1_$x'] != null && images['image1_$x']!.path.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath(
              'recipe_steps[$x][image_file]',
              images['image1_$x']!.path
          ));
        }

        if (images['image2_$x'] != null && images['image2_$x']!.path.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath(
              'recipe_steps[$x][image_file2]',
              images['image2_$x']!.path
          ));
        }
      }

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'image_file',
            image.path
        ));
      }

      request.headers.addAll({
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      request.fields['body'] = jsonEncode(body);

      final response = await request.send();
      final json = jsonDecode(await response.stream.bytesToString());
      return '${json?['id'] ?? ''}';
    } catch (e) {
      debugPrint(e.toString());
    }

    return '';
  }

  static Future<List<CountryModel>> countries() async {
    List<CountryModel> items = [];

    try {
      final response = await http.get(Uri.parse(countriesUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);

      if (json['countries'] != null) {
        for (var i in json['countries']) {
          items.add(CountryModel.fromJson(i));
        }

        return items;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<RewardModel>> rewards() async {
    List<RewardModel> items = [];

    try {
      final response = await http.get(Uri.parse(rewardsUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);

      if (json['rewards'] != null) {
        for (var i in json['rewards']) {
          items.add(RewardModel.fromJson(i));
        }

        return items;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future<List<QuestionAnswerModel>> questions() async {
    List<QuestionAnswerModel> items = [];

    try {
      final response = await http.get(Uri.parse(questionsUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final json = jsonDecode(response.body);

      if (json['questions'] != null) {
        for (var i in json['questions']) {
          items.add(QuestionAnswerModel.fromJson(i));
        }

        return items;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return items;
  }

  static Future logout() async {
    try {
      await http.get(Uri.parse(userDeleteUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> delete() async {
    try {
      final response = await http.post(Uri.parse(userDeleteUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });
      final json = jsonDecode(response.body);
      return json['status'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> changePass(String password) async {
    try {
      final response = await http.post(Uri.parse(changePassUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'password': password});
      final json = jsonDecode(response.body);
      return json['status'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<ProfileModel?> saveAddress(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(saveAddressUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);
      final json = jsonDecode(response.body);

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return null;
      }

      if (json['user'] != null) {
        return ProfileModel.fromJson(json['user']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<ProfileModel?> deleteAddress(String id) async {
    try {
      final response = await http.post(Uri.parse(deleteAddressUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'id': id});
      final json = jsonDecode(response.body);

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return null;
      }

      if (json['user'] != null) {
        return ProfileModel.fromJson(json['user']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<ProfileModel?> setAddress(int id) async {
    try {
      final response = await http.post(Uri.parse(setAddressUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'address_id': '$id'});

      final json = jsonDecode(response.body);

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return null;
      }

      if (json['user'] != null) {
        return ProfileModel.fromJson(json['user']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<bool> setNewsletter(bool val) async {
    try {
      final response = await http.post(Uri.parse(setNewsletterUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'newsletter': '${val ? 1 : 0}'});
      final json = jsonDecode(response.body);
      return json['status'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> setPush(bool val) async {
    try {
      final response = await http.post(Uri.parse(setPushUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: {'push': '${val ? 1 : 0}'});
      final json = jsonDecode(response.body);
      return json['status'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<ProfileModel?> save(Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(saveUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      }, body: body);

      final json = jsonDecode(response.body);

      if (json['user'] != null) {
        return ProfileModel.fromJson(json['user']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<List<ProductModel>> getReviews() async {
    List<ProductModel> items = [];

    try {
      final response = await http.get(Uri.parse(getMyReviewsUrl), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
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

  static Future<bool> sendForm(PlatformFile? file, Map<String, String> body) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(supportUrl),
      );

      if (file != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            await File(file.path!).readAsBytes(),
            filename: file.name
          )
        );
      }

      request.fields.addAll(body);

      request.headers.addAll({
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final response = await request.send();
      final json = jsonDecode(await response.stream.bytesToString());

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return false;
      }

      return json['status'] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static Future<bool> uploadImage(File image) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(uploadAvatarUrl));

      request.files.add(await http.MultipartFile.fromPath(
          'avatar',
          image.path
      ));

      request.headers.addAll({
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'
      });

      final response = await request.send();
      final json = jsonDecode(await response.stream.bytesToString());

      if (json['message'] != null) {
        Helper.snackBar(error: true, text: json['message']);
        return false;
      }

      return json['status'] ?? false;
    } catch(e) {
      debugPrint(e.toString());
    }

    return false;
  }
}