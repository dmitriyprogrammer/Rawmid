import 'package:get/get.dart';
import 'package:rawmid/api/blog.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/model/home/news.dart';
import '../api/cart.dart';
import '../api/home.dart';
import '../utils/helper.dart';
import 'package:flutter/material.dart';

class NewsController extends GetxController {
  String id;
  bool recipe;
  bool survey;
  bool full;
  final List<GlobalKey> stepKeys = [];
  NewsController(this.id, this.recipe, this.survey, {this.full = false});
  final main = Get.find<NavigationController>();
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;

  void initStepKeys(int count) {
    if (stepKeys.length != count) {
      stepKeys.clear();
      stepKeys.addAll(List.generate(count, (_) => GlobalKey()));
    }
  }

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  RxBool isLoading = false.obs;
  Rxn<NewsModel> news = Rxn();

  Future initialize() async {
    final fId = Helper.prefs.getInt('fias_id') ?? 0;

    if (fId > 0) {
      await HomeApi.changeCity(fId);
    }

    news.value = await BlogApi.getNew(id, recipe, survey, full: full);

    isLoading.value = true;
  }

  setId(String val) {
    isLoading.value = false;
    id = val;
  }

  setRecipe(bool val) {
    isLoading.value = false;
    recipe = val;
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
    main.wishlist.value = wishlist;
    if (main.user.value != null) {
      CartApi.addWishlist(wishlist);
    }
  }
}