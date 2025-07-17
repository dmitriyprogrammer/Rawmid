import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/cart.dart';
import '../api/home.dart';
import '../model/cart.dart';

class CartController extends GetxController {
  final navController = Get.find<NavigationController>();
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  RxList<CartModel> cartProducts = <CartModel>[].obs;
  RxBool isLoading = false.obs;

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

    final e = await CartApi.getProducts();
    cartProducts.value = e;
    navController.cartProducts.value = e;
    isLoading.value = true;
  }

  Future updateCart(CartModel cart) async {
    CartApi.updateCart({
      'key': cart.key,
      'quantity': '${cart.quantity}'
    }).then((e) {
      cartProducts.value = e;
      navController.cartProducts.value = e;

      if (cartProducts.isEmpty) {
        CartApi.clear();
      }

      if ((cart.quantity ?? 0) <= 0) {
        final kre = Helper.prefs.getStringList('product_kre') ?? [];

        for (var i in e) {
          if (kre.contains(i.id)) {
            kre.removeWhere((e) => e == i.id);
          }
        }

        Helper.prefs.setStringList('product_kre', kre);
      }
    });
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