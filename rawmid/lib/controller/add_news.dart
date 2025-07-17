import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawmid/api/profile.dart';
import '../api/home.dart';
import '../model/club/recipe_product.dart';
import '../model/product/product_autocomplete.dart';
import '../utils/helper.dart';

class AddNewsController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameField = TextEditingController();
  final videoField = TextEditingController();
  final textField = TextEditingController();
  final productField = TextEditingController();
  var categoriesSelect = <String>[].obs;
  Rxn<File> imageFile = Rxn<File>();
  var image = ''.obs;
  final ImagePicker picker = ImagePicker();
  var loadImage = false.obs;
  var isLoading = false.obs;
  var stepFiles = <File>[].obs;
  var stepIds = <String>[].obs;
  var stepFilesStr = <String>[].obs;
  var stepFields = <TextEditingController>[].obs;
  var stepFields2 = <TextEditingController>[].obs;
  var products = <RecipeProductModel>[].obs;
  var id = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  @override
  void dispose() {
    nameField.dispose();
    videoField.dispose();
    textField.dispose();

    for (var step in stepFields) {
      step.dispose();
    }

    super.dispose();
  }

  Future initialize() async {
    id.value = Get.parameters['id'] ?? '';
    final api = await ProfileApi.getSurvey(id: id.value);

    if (api != null) {
      nameField.text = api.name;
      videoField.text = api.youtubeLink;
      textField.text = api.description;
      products.value = api.products;
      image.value = api.image;

      for (var e in api.steps) {
        stepFilesStr.add(e.image ?? '');
        stepFields.add(TextEditingController(text: e.title));
        stepFields2.add(TextEditingController(text: e.text));
        stepIds.add(e.id!);
        stepFiles.add(File(''));
      }
    }

    isLoading.value = true;
  }

  void removeStep(int index) {
    stepFiles.removeAt(index);
    stepFields[index].dispose();
    stepFields.removeAt(index);
  }

  void adStep() {
    stepFields.add(TextEditingController());
    stepFields2.add(TextEditingController());
    stepFiles.add(File(''));
  }

  Future pickImage() async {
    loadImage.value = true;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }

    loadImage.value = false;
  }

  Future pickImageStep(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      stepFiles[index] = File(pickedFile.path);

      if (stepFilesStr.elementAtOrNull(index) != null) {
        stepFilesStr[index] = '';
      }

      update();
    }
  }

  Future deleteImage(int index) async {
    stepFiles[index] = File('');
    update();
  }

  Future<List<ProductAutocompleteModel>> suggestionsCallback(String pattern) async {
    return await HomeApi.getAutocomplete({'fn': pattern});
  }

  Future save() async {
    if (formKey.currentState?.validate() ?? false) {
      var steps = [];

      for (var (index, e) in stepFields.indexed) {
        var item = {};

        item.putIfAbsent('sort_order', () => '$index');
        item.putIfAbsent('survey_step_id', () => stepIds.elementAtOrNull(index) != null ? stepIds[index] : '');
        item.putIfAbsent('survey_step_title', () => e.text);
        item.putIfAbsent('text', () => stepFields2[index].text);

        if (stepFiles[index].path.isEmpty) {
          item.putIfAbsent('image_file', () => '');
        }

        steps.add(item);
      }

      final body = {
        'id': id.value,
        'name': nameField.text,
        'youtube_link': videoField.text,
        'description': textField.text,
        'survey_steps': steps,
        'survey_products': products.map((e) => e.id).toList(),
      };

      if (imageFile.value == null && image.isEmpty) {
        body.putIfAbsent('image', () => '');
      }

      final api = await ProfileApi.editSurvey(body, imageFile.value, stepFiles);

      if (api.isNotEmpty) {
        id.value = api;
        Helper.snackBar(text: 'Статья успешно сохранена', callback2: Get.back);
      } else {
        Helper.snackBar(text: 'Ошибка создания статьи, попробуйте позже.');
      }
    }
  }
}