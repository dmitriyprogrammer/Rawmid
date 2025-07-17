import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/compare.dart';
import '../model/compare.dart';

class CompareController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isC = false.obs;
  RxList<CompareProductModel> compares = <CompareProductModel>[].obs;
  RxList<CompareProductModel> filteredCompares = <CompareProductModel>[].obs;
  RxList<CompareProductModel> search = <CompareProductModel>[].obs;
  RxList<String> titles = <String>[].obs;
  RxList<GlobalKey> keys = <GlobalKey>[].obs;
  RxList<GlobalKey> keys2 = <GlobalKey>[].obs;
  RxMap<int, double> height = <int, double>{}.obs;
  final navController = Get.find<NavigationController>();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future setHeight(int index, double val) async {
    if (height.containsKey(index) && height[index]! < val) {
      height[index] = val;
    } else {
      height.putIfAbsent(index, () => val);
    }
  }

  setCompares() {
    isC.value = !isC.value;
    height.clear();

    if (isC.value) {
      search.value = filteredCompares;
    } else {
      search.value = compares;
    }

    titles.clear();

    titles.addAll([
      'Товар',
      ''
    ]);

    for (var compare in search) {
      if (compare.category.isNotEmpty) {
        titles.add('Категория');
      }

      if (compare.price.isNotEmpty) {
        titles.add('Цена');
      }

      if (compare.manufacturer.isNotEmpty) {
        titles.add('Производитель');
      }

      if (compare.model.isNotEmpty) {
        titles.add('Модель');
      }

      if (compare.availability.isNotEmpty) {
        titles.add('Наличие');
      }

      if (compare.rating > 0) {
        titles.add('Рейтинг');
      }

      if (compare.color.isNotEmpty) {
        titles.add('Цвет');
      }

      for (var attribute in compare.attributes) {
        titles.add(attribute.name);
      }
    }

    titles.value = titles.toSet().toList();
    keys.clear();
    keys2.clear();

    for (var _ in titles) {
      keys.add(GlobalKey());
      keys2.add(GlobalKey());
    }
  }

  Future initialize() async {
    isLoading.value = false;
    final ids = Helper.compares.value.join(',');

    if (ids.isNotEmpty) {
      final api = await CompareApi.getCompares(ids);

      if (api.isNotEmpty) {
        for (var i in api['products']) {
          compares.add(CompareProductModel.fromJson(i));
        }

        search.value = compares;

        for (var i in api['products2']) {
          filteredCompares.add(CompareProductModel.fromJson(i));
        }

        titles.addAll([
          'Товар',
          '',
          'Категория',
          'Цена',
          'Производитель',
          'Модель',
          'Наличие',
          'Рейтинг',
          'Цвет'
        ]);

        for (var compare in compares) {
          for (var attribute in compare.attributes) {
            titles.add(attribute.name);
          }
        }

        titles.value = titles.toSet().toList();

        for (var _ in titles) {
          keys.add(GlobalKey());
          keys2.add(GlobalKey());
        }
      }
    }

    isLoading.value = true;
  }
}