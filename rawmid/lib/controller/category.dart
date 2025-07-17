import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/catalog.dart';
import 'package:rawmid/api/home.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/model/catalog/attribute.dart';
import 'package:rawmid/model/home/banner.dart';
import 'package:rawmid/model/home/product.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/cart.dart';
import '../model/catalog/category.dart';
import '../model/catalog/manufacturer.dart';

class CategoryController extends GetxController {
  CategoryModel category;
  RxBool isLoading = false.obs;
  RxBool openFilter = false.obs;
  RxBool load = false.obs;
  RxBool isHeaderScrolled = false.obs;
  final navController = Get.find<NavigationController>();
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<BannerModel> banners = <BannerModel>[].obs;
  CategoryController(this.category);
  RxList<ManufacturerModel> manufacturers = <ManufacturerModel>[].obs;
  RxList<AttributeModel> attributes = <AttributeModel>[].obs;
  RxMap<String, Object> filter = <String, Object>{}.obs;
  RxDouble minPrice = 0.0.obs;
  RxDouble maxPrice = 0.0.obs;
  final scrollController = ScrollController();
  final GlobalKey targetKey = GlobalKey();
  RxInt total = 0.obs;
  RxInt tab = 0.obs;
  RxInt page = 1.obs;
  final List<MapEntry<String, String>> sorts = [
    MapEntry('sort_order_asc', 'По умолчанию'),
    MapEntry('name_asc', 'Наименование (А -> Я)'),
    MapEntry('name_desc', 'Наименование (Я -> А)'),
    MapEntry('price_asc', 'Цена (по возрастанию)'),
    MapEntry('price_desc', 'Цена (по убыванию)'),
    MapEntry('rating_desc', 'Рейтинг (по убыванию)'),
    MapEntry('rating_asc', 'Рейтинг (по возрастанию)')
  ];
  RxString sort = 'sort_order_asc'.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  @override
  void onClose() {
    scrollController.removeListener(listener);
    super.onClose();
  }

  Future setManufacturer(String val) async {
    if (!filter.containsKey('manufacturer')) {
      filter.putIfAbsent('manufacturer', () => [val]);
    } else {
      var item = filter['manufacturer'] as List<String>;

      if (item.contains(val)) {
        item.remove(val);
      } else {
        item.add(val);
      }

      filter['manufacturer'] = item;
    }

    filter.refresh();
  }

  Future setFilter(int attrId, String val) async {
    if (!filter.containsKey('attribute_value')) {
      filter.putIfAbsent('attribute_value', () => {'$attrId': [val]});
    } else {
      var item = filter['attribute_value'] as Map<String, List<String>>;

      if (item.containsKey('$attrId')) {
        if (item['$attrId']!.contains(val)) {
          item['$attrId']!.remove(val);

          if (item['$attrId']!.isEmpty) {
            item.removeWhere((e, k) => e == '$attrId');
          }
        } else {
          item['$attrId']!.add(val);
          item.putIfAbsent('$attrId', () => item['$attrId']!);
        }
      } else {
        item.putIfAbsent('$attrId', () => [val]);
      }

      if (item.isNotEmpty) {
        filter['attribute_value'] = item;
      } else {
        filter.remove('attribute_value');
      }
    }

    if (!filter.containsKey('min_price')) {
      filter.putIfAbsent('min_price', () => minPrice.value);
      filter.putIfAbsent('max_price', () => maxPrice.value);
    }

    filter.refresh();
  }

  Future changePrice(RangeValues val) async {
    if (!filter.containsKey('min_price')) {
      filter.putIfAbsent('min_price', () => val.start);
      filter.putIfAbsent('max_price', () => val.end);
    } else {
      filter['min_price'] = val.start;
      filter['max_price'] = val.end;
    }

    filter.refresh();
  }

  Future changeFilter(int attrId, RangeValues val) async {
    if (!filter.containsKey('attr_slider')) {
      filter.putIfAbsent('attr_slider', () => {'$attrId': {'min': '${val.start}', 'max': '${val.end}'}});
    } else {
      var item = filter['attr_slider'] as Map<String, Map<String, String>>;

      if (!item.containsKey('$attrId')) {
        item.putIfAbsent('$attrId', () => {'min': '${val.start}', 'max': '${val.end}'});
      } else {
        item['$attrId'] = {'min': '${val.start}', 'max': '${val.end}'};
      }
    }

    if (!filter.containsKey('min_price')) {
      filter.putIfAbsent('min_price', () => minPrice.value.toInt());
      filter.putIfAbsent('max_price', () => maxPrice.value.toInt());
    }

    filter.refresh();
  }

  Future clear() async {
    await loadProducts(clear: true);
    filter.clear();
    openFilter.value = false;
  }

  getSortedProducts() {
    List<ProductModel> sortedProducts = List.from(products);

    switch (sort.value) {
      case 'price_asc':
        sortedProducts.sort((a, b) => int.parse('${a.price ?? 0}'.replaceAll(RegExp(r'[^0-9]'), '')).compareTo(int.parse('${b.price ?? 0}'.replaceAll(RegExp(r'[^0-9]'), ''))));
        break;
      case 'price_desc':
        sortedProducts.sort((a, b) => int.parse('${b.price ?? 0}'.replaceAll(RegExp(r'[^0-9]'), '')).compareTo(int.parse('${a.price ?? 0}'.replaceAll(RegExp(r'[^0-9]'), ''))));
        break;
      case 'name_asc':
        sortedProducts.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'name_desc':
        sortedProducts.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'model_asc':
        sortedProducts.sort((a, b) => a.model.compareTo(b.model));
        break;
      case 'model_desc':
        sortedProducts.sort((a, b) => b.model.compareTo(a.model));
        break;
      case 'rating_asc':
        sortedProducts.sort((a, b) => a.rating!.compareTo(b.rating!));
        break;
      case 'rating_desc':
        sortedProducts.sort((a, b) => b.rating!.compareTo(a.rating!));
      case 'sort_order_asc':
        sortedProducts.sort((a, b) => a.sortOrder!.compareTo(b.sortOrder!));
        break;
      default:
        break;
    }

    products.value = sortedProducts;
  }

  Future loadProducts({bool clear = false}) async {
    Map<String, dynamic> body = {'category_id': category.id};

    if (!clear) {
      if (!filter.containsKey('min_price')) {
        filter.putIfAbsent('min_price', () => minPrice.value.toInt());
        filter.putIfAbsent('max_price', () => maxPrice.value.toInt());
      }

      filter.forEach((key, val) {
        body.putIfAbsent(key, () => val);
      });
    }

    final api = await CatalogApi.loadProducts(body);
    products.value = api.value;
    total.value = api.key;

    Scrollable.ensureVisible(
        targetKey.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut
    );
  }

  Future _loadProducts() async {
    if (load.value) return;
    load.value = true;
    page.value++;

    Map<String, dynamic> body = {
      'category_id': category.id,
      'page': page.value
    };

    filter.forEach((key, val) {
      body.putIfAbsent(key, () => val);
    });

    final api = await CatalogApi.loadProducts(body);

    if (api.value.isNotEmpty) {
      total.value = api.key;
      products.addAll(api.value);
      load.value = false;
    }
  }

  double getValue(dynamic val) {
    return double.tryParse('$val') ?? 0;
  }

  Future initialize() async {
    final api = await CatalogApi.getCategory({
      'category_id': category.id
    });

    if (api != null) {
      products.value = api.products;
      manufacturers.value = api.manufacturers;
      attributes.value = api.attributes;
      total.value = api.total;
      minPrice.value = api.minPrice;
      maxPrice.value = api.maxPrice;
    }

    banners.value = await HomeApi.getBanner({'category_id': category.id});

    isLoading.value = true;
    scrollController.addListener(listener);
  }

  listener() {
    if (total.value > products.length && (scrollController.position.pixels + 200).toInt() >= scrollController.position.maxScrollExtent.toInt()) {
      _loadProducts();
    }
  }

  Future addWishlist(String id) async {
    if (wishlist.contains(id)) {
      wishlist.remove(id);
    } else {
      wishlist.add(id);
    }

    Helper.prefs.setStringList('wishlist', wishlist);
    Helper.wishlist.value = wishlist;
    Helper.trigger.value++;
    navController.wishlist.value = wishlist;

    if (navController.user.value != null) {
      CartApi.addWishlist(wishlist);
    }
  }
}