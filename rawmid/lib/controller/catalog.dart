import 'dart:async';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/model/catalog/category.dart';
import 'package:rawmid/model/home/banner.dart';
import 'package:rawmid/model/home/product.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/cart.dart';
import '../api/catalog.dart';
import '../api/home.dart';

class CatalogController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<ProductModel> specials = <ProductModel>[].obs;
  RxList<ProductModel> shopProducts = <ProductModel>[].obs;
  RxList<BannerModel> banners = <BannerModel>[].obs;
  RxList<BannerModel> banners2 = <BannerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    final fId = Helper.prefs.getInt('fias_id') ?? 0;

    if (fId > 0) {
      await HomeApi.changeCity(fId);
    }

    final e = await CatalogApi.getCategories();
    categories.value = e;

    final api = await HomeApi.getBanner({});
    banners2.value = api;

    CatalogApi.getSpecials().then((e) {
      specials.value = e;
    });

    CatalogApi.getPredloz().then((e) {
      banners.value = e;
    });

    HomeApi.getFeatured().then((e) {
      shopProducts.value = e;
    });

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
    final navController = Get.find<NavigationController>();
    navController.wishlist.value = wishlist;
    if (navController.user.value != null) {
      CartApi.addWishlist(wishlist);
    }
  }
}