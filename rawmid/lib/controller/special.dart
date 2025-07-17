import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rawmid/model/catalog/category.dart';
import '../api/cart.dart';
import '../api/catalog.dart';
import '../api/home.dart';
import '../model/home/banner.dart';
import '../model/home/product.dart';
import '../utils/helper.dart';
import 'navigation.dart';

class SpecialController extends GetxController {
  var isLoading = false.obs;
  var tab = 0.obs;
  var type = 0.obs;
  var activeIndex = 0.obs;
  var id = Rxn<String>();
  var products = <ProductModel>[].obs;
  var categories = <CategoryModel>[].obs;
  var wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  final navController = Get.find<NavigationController>();
  final scrollController = ScrollController();
  RxList<BannerModel> banners = <BannerModel>[].obs;
  final pageController = PageController();
  Rx<Duration> time = Duration().obs;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  void onClose() {
    timer?.cancel();
    timer = null;
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  setTimer(int val) {
    activeIndex.value = val;
    final now = DateTime.now();
    final item = banners[val];
    timer?.cancel();
    timer = null;

    if (item.promotionEnd != null && item.promotionEnd!.millisecondsSinceEpoch > now.millisecondsSinceEpoch) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final difference = item.promotionEnd!.difference(DateTime.now());
        time.value = difference.isNegative ? Duration.zero : difference;
      });
    }
  }

  Future initialize() async {
    final fId = Helper.prefs.getInt('fias_id') ?? 0;

    if (fId > 0) {
      await HomeApi.changeCity(fId);
    }

    final now = DateTime.now();

    HomeApi.getBanner({'special': '1'}).then((e) {
      banners.value = e;

      if (e.isNotEmpty && e.first.promotionEnd != null && e.first.promotionEnd!.millisecondsSinceEpoch > now.millisecondsSinceEpoch) {
        timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
          final difference = e.first.promotionEnd!.difference(DateTime.now());
          time.value = difference.isNegative ? Duration.zero : difference;
        });
      }
    });

    final api = await CatalogApi.loadSpecialProducts({});
    var items = <ProductModel>[];

    for (var i in api['products'] ?? []) {
      items.add(ProductModel.fromJson(i));
    }

    var items2 = <CategoryModel>[];

    for (var i in api['categories'] ?? []) {
      items2.add(CategoryModel.fromJson(i));
    }

    products.value = items;
    categories.value = items2;
    isLoading.value = true;
  }

  Future loadProducts(String? id, {bool cat = true}) async {
    this.id.value = id;
    if (!isLoading.value) return;
    isLoading.value = false;

    Map<String, dynamic> body = {
      'filter_markdown': tab.value == 2,
      'filter_sale': tab.value == 1,
      'filter_unlimited': tab.value == 0
    };

    if (id != null && cat) {
      body.putIfAbsent('id', () => id);
    }

    final api = await CatalogApi.loadSpecialProducts(body);
    var items = <ProductModel>[];

    for (var i in api['products'] ?? []) {
      items.add(ProductModel.fromJson(i));
    }

    var items2 = <CategoryModel>[];

    for (var i in api['categories'] ?? []) {
      items2.add(CategoryModel.fromJson(i));
    }

    products.value = items;
    categories.value = items2;
    isLoading.value = true;
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