import 'package:get/get.dart';
import 'package:rawmid/api/wishlist.dart';
import 'package:rawmid/controller/navigation.dart';
import '../api/cart.dart';
import '../api/home.dart';
import '../model/home/product.dart';
import '../utils/helper.dart';

class WishlistController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt tab = 0.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  final navController = Get.find<NavigationController>();

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

    products.clear();
    wishlist.value = Helper.prefs.getStringList('wishlist') ?? <String>[];

    if (wishlist.isNotEmpty) {
      final e = await WishlistApi.getWishlist(wishlist.join(','));

      products.addAll(e);

      if (e.isNotEmpty) {
        navController.wishlist.value = e.map((item) => item.id).toList();
      } else {
        navController.wishlist.clear();
        Helper.prefs.setStringList('wishlist', []);
      }
    }

    isLoading.value = true;
  }

  Future removeWishlist(String id) async {
    wishlist.remove(id);
    Helper.prefs.setStringList('wishlist', wishlist);
    Helper.wishlist.value = wishlist;
    products.removeWhere((e) => e.id == id);
    navController.wishlist.value = wishlist;
    CartApi.addWishlist(wishlist);
  }
}