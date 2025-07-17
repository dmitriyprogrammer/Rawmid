import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api/cart.dart';
import '../api/login.dart';
import '../api/order.dart';
import '../api/product.dart';
import '../model/order_history.dart';
import '../screen/order/info.dart';
import '../screen/user/payment.dart';
import '../utils/helper.dart';
import 'navigation.dart';

class OrderController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPayLoad = false.obs;
  RxBool success = false.obs;
  RxList<OrdersModel> orders = <OrdersModel>[].obs;
  RxInt tab = 0.obs;
  RxInt rating = 0.obs;
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  final navController = Get.find<NavigationController>();
  RxString printStr = ''.obs;
  WebViewController? webController;
  final fioReviewField = TextEditingController();
  final textReviewField = TextEditingController();
  final emailReviewField = TextEditingController();
  RxBool emailValidate = false.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    orders.value = await OrderApi.order();
    isLoading.value = true;

    fioReviewField.text = navController.user.value?.fio ?? '';
    emailReviewField.text = navController.user.value?.email ?? '';

    if (Get.parameters['order_id'] != null) {
      final order = orders.firstWhereOrNull((e) => e.id == Get.parameters['order_id']);

      if (order != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.to(() => OrderInfoView(order: order));
        });
      }
    }
  }

  Future validateEmailX(String val) async {
    if (val.isNotEmpty && EmailValidator.validate(val)) {
      LoginApi.checkEmail(val).then((e) {
        emailValidate.value = !e;
      });
    } else {
      emailValidate.value = false;
    }
  }

  String formatDateCustom(DateTime date) {
    List<String> months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];

    int day = date.day;
    String month = months[date.month - 1];
    int year = date.year;

    return "$day $month $year";
  }

  Future setParam(int val, OrdersModel order) async {
    if (val == 3) {
      await navController.clear();

      for (var product in order.products) {
        await navController.addCart(product.id);
      }

      Get.back();
      Get.back();
      Get.back();
      navController.onItemTapped(4);
      Get.toNamed('/checkout');
    } else if (val == 2) {
      Get.toNamed('/support', arguments: {'department_id': 0, 'order_id': order.id});
    } else if (val == 4) {
      isPayLoad.value = false;

      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              child: PaymentView(id: order.id, link: order.payLink)
          )
      );
    } else if (val == 1) {
      final api = await OrderApi.cancelOrder(order.id);

      if (api) {
        Helper.snackBar(text: 'Заказ успешно отменен', callback2: Get.back);
      } else {
        Helper.snackBar(text: 'Произошла ошибка, попробуйте позже');
      }
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

  Future addReview(String id) async {
    if (rating.value == 0) {
      Helper.snackBar(error: true, text: 'Выберите оценку');
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      final api = await ProductApi.addReview({
        'product_id': id,
        'name': fioReviewField.text,
        'text': textReviewField.text,
        'email': emailReviewField.text,
        'rating': '${rating.value}'
      });

      if (api) {
        Timer.periodic(const Duration(seconds: 3), (t) {
          Get.back();
          textReviewField.clear();
          fioReviewField.clear();
          rating.value = 0;
          emailReviewField.clear();

          t.cancel();
        });
      }
    }
  }
}