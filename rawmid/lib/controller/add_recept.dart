import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/home.dart';
import '../model/club/recipe_product.dart';
import '../model/product/product_autocomplete.dart';
import '../model/profile/edit_recipe.dart';

class AddReceptController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameField = TextEditingController();
  final videoField = TextEditingController();
  final textField = TextEditingController();
  final bField = TextEditingController();
  final zField = TextEditingController();
  final uField = TextEditingController();
  final kField = TextEditingController();
  final tegField = TextEditingController();
  final productField = TextEditingController();
  var types = <String>[].obs;
  var categoriesSelect = <String>[].obs;
  Rxn<File> imageFile = Rxn<File>();
  var image = ''.obs;
  final ImagePicker picker = ImagePicker();
  var loadImage = false.obs;
  var isLoading = false.obs;
  var ingredients = <Map<String, TextEditingController>>[].obs;
  var stepFiles = <String, File?>{}.obs;
  var stepFilesStr = <String, String>{}.obs;
  var stepFields = <TextEditingController>[].obs;
  var products = <RecipeProductModel>[].obs;
  var categories = <RecipeCategory>[].obs;
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
    tegField.dispose();
    bField.dispose();
    zField.dispose();
    uField.dispose();
    kField.dispose();

    for (var ing in ingredients) {
      ing['name']!.dispose();
      ing['text']!.dispose();
    }

    for (var step in stepFields) {
      step.dispose();
    }

    super.dispose();
  }

  Future initialize() async {
    id.value = Get.parameters['id'] ?? '';
    final api = await ProfileApi.getRecipe(id: id.value);

    if (api != null) {
      categories.value = api.categories;

      final recipe = api.recipe;

      if (recipe != null) {
        nameField.text = recipe.name;
        videoField.text = recipe.youtubeLink;
        textField.text = recipe.description;

        if (recipe.energy.isNotEmpty) {
          bField.text = recipe.energy.first.text;
          zField.text = recipe.energy.length > 1 ? recipe.energy[1].text : '';
          uField.text = recipe.energy.length >= 2 ? recipe.energy[2].text : '';
          kField.text = recipe.energy.length >= 3 ? recipe.energy[3].text : '';
        }

        tegField.text = recipe.tag;
        types.value = recipe.recipeTip;

        for (var i in categories) {
          if (recipe.recipeCategories.contains(i.id)) {
            categoriesSelect.add(i.name);
          }
        }

        ingredients.value = recipe.ingredients.map((e) => {
          'name': TextEditingController(text: e.title),
          'text': TextEditingController(text: e.text),
        }).toList();
        stepFields.value = recipe.steps.map((e) => TextEditingController(text: e.text)).toList();
        products.value = recipe.recipeProducts;
        image.value = recipe.image;

        for (var (index, _) in stepFields.indexed) {
          stepFiles.putIfAbsent('image1_$index', () => File(''));
          stepFiles.putIfAbsent('image2_$index', () => File(''));
        }

        for (var (index, e) in recipe.steps.indexed) {
          stepFilesStr.putIfAbsent('image1_$index', () => e.image1 ?? '');
          stepFilesStr.putIfAbsent('image2_$index', () => e.image2 ?? '');
        }
      }
    }

    isLoading.value = true;
  }

  void addIngredient() {
    ingredients.add({
      'name': TextEditingController(),
      'text': TextEditingController()
    });
  }

  void removeIngredient(int index) {
    ingredients[index]['name']!.dispose();
    ingredients[index]['text']!.dispose();
    ingredients.removeAt(index);
  }

  void removeStep(int index) {
    stepFiles.remove('image1_$index');
    stepFiles.remove('image2_$index');
    stepFields[index].dispose();
    stepFields.removeAt(index);
  }

  void adStep() {
    stepFields.add(TextEditingController());
    stepFiles.putIfAbsent('image1_${stepFields.length-1}', () => File(''));
    stepFiles.putIfAbsent('image2_${stepFields.length-1}', () => File(''));
  }

  Future pickImage() async {
    loadImage.value = true;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }

    loadImage.value = false;
  }

  Future pickImageStep(int index, String type) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      stepFiles['${type}_$index'] = File(pickedFile.path);

      if (stepFilesStr.containsKey('${type}_$index')) {
        stepFilesStr['${type}_$index'] = '';
      }

      update();
    }
  }

  Future deleteImage(int index, String type) async {
    stepFiles['${type}_$index'] = null;
    update();
  }

  Map<K, V> insertToMap<K, V>(
      Map<K, V> original,
      int index,
      K newKey,
      V newValue,
      ) {
    final entries = original.entries.toList();
    if (index < 0) index = 0;
    if (index > entries.length) index = entries.length;

    entries.insert(index, MapEntry(newKey, newValue));
    return Map.fromEntries(entries);
  }

  Future<List<ProductAutocompleteModel>> suggestionsCallback(String pattern) async {
    return await HomeApi.getAutocomplete({'fn': pattern});
  }

  Future save() async {
    if (formKey.currentState?.validate() ?? false) {
      var steps = [];

      for (var (index, i) in stepFields.indexed) {
        var item = {};

        item.putIfAbsent('text', () => i.text);

        if (stepFiles['image1_$index'] == null) {
          item.putIfAbsent('image_file', () => '');
        }

        if (stepFiles['image2_$index'] == null) {
          item.putIfAbsent('image_file', () => '');
        }

        steps.add(item);
      }

      final body = {
        'id': id.value,
        'name': nameField.text,
        'youtube_link': videoField.text,
        'recipe_tip': types,
        'description': textField.text,
        'ingredients': ingredients.map((e) => {
          'title': e['name']!.text,
          'text': e['text']!.text
        }).toList(),
        'energy': [{'title': 'Белки', 'text': bField.text}, {'title': 'Жиры', 'text': zField.text}, {'title': 'Углеводы', 'text': uField.text}, {'title': 'Каллории', 'text': kField.text}],
        'recipe_steps': steps,
        'tag': tegField.text,
        'recipe_products': products.map((e) => e.id).toList(),
        'recipe_categories': categories.where((e) => categoriesSelect.firstWhereOrNull((c) => c == e.name) != null).map((e) => e.id).toList()
      };

      if (imageFile.value == null && image.isEmpty) {
        body.putIfAbsent('image', () => '');
      }

      final api = await ProfileApi.editRecipe(body, imageFile.value, stepFiles);

      if (api.isNotEmpty) {
        id.value = api;
        Helper.snackBar(text: 'Рецепт успешно сохранен', callback2: Get.back);
      } else {
        Helper.snackBar(text: 'Ошибка создания рецепта, попробуйте позже.');
      }
    }
  }
}