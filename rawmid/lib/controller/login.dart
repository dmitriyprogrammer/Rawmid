import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rawmid/api/home.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/controller/club.dart';
import 'package:rawmid/controller/home.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/screen/main.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../utils/helper.dart';
import '../api/cart.dart';
import '../api/login.dart';
import '../model/cart.dart';
import '../model/profile/profile.dart';
import '../utils/notifications.dart';

class LoginController extends GetxController {
  RxBool valid = false.obs;
  RxBool agree = false.obs;
  RxBool isPasswordVisible = false.obs;
  final TextEditingController emailField = TextEditingController();
  final TextEditingController passwordField = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  RxString verificationCode = ''.obs;
  final navController = Get.find<NavigationController>();
  RxBool validateEmail = false.obs;
  WebViewController? webPersonalController;

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future login() async {
    if (!agree.value) {
      Helper.snackBar(error: true, text: 'Необходимо принять условия и политику обработки');
      return;
    }

    if (valid.value) {
      Helper.closeKeyboard();

      final user = await LoginApi.login({
        'email': emailField.text,
        'password': passwordField.text
      });

      if (user != null) {
        final token = await NotificationsService.getToken();

        if (token.isNotEmpty) {
          HomeApi.saveToken(token);
        }

        final wishlist = Helper.prefs.getStringList('wishlist') ?? [];

        if (wishlist.isNotEmpty) {
          CartApi.addWishlist(wishlist);
        }

        final carts = navController.cartProducts;
        List<CartModel> copy = List.from(carts);
        await navController.clear();

        if (copy.isNotEmpty) {
          for (var cart in copy) {
            navController.addCart(cart.id, c: true);
          }

          update();
        }

        navController.user.value = user;

        final param = Get.parameters;
        if (Get.isRegistered<HomeController>()) {
          Get.delete<HomeController>();
        }

        Get.put(HomeController());
        Get.find<HomeController>().initialize();

        if ((param['route'] ?? '').isNotEmpty) {
          navController.onItemTapped(0);

          Get.toNamed('/home');
          Get.toNamed('/${param['route']}');
          return;
        }

        if ((param['tab'] ?? '').isNotEmpty) {
          if (Get.isRegistered<ClubController>()) {
            Get.delete<ClubController>();
          }

          Get.put(ClubController());
          Get.find<ClubController>().initialize();
          Get.to(() => MainView(index: int.tryParse('${param['tab']}') ?? 0));
        } else {
          Get.offNamed('/home');
        }
      }
    }
  }

  Future<ProfileModel?> getUser() async {
    return await ProfileApi.user();
  }

  Future loginCode() async {
    if (!agree.value) {
      Helper.snackBar(error: true, text: 'Необходимо принять условия и политику обработки');
      return;
    }

    if (valid.value && verificationCode.isNotEmpty && verificationCode.value.length == 4) {
      Helper.closeKeyboard();

      final user = await LoginApi.loginCode({
        'email': emailField.text,
        'code': verificationCode.value
      });

      if (user != null) {
        final token = await NotificationsService.getToken();

        if (token.isNotEmpty) {
          HomeApi.saveToken(token);
        }

        final carts = navController.cartProducts;
        navController.cartProducts.clear();

        for (var cart in carts) {
          navController.addCart(cart.id);
        }

        navController.user.value = user;
        update();

        final param = Get.parameters;

        if ((param['route'] ?? '').isNotEmpty) {
          Get.toNamed('/${param['route']}');
          return;
        }

        if (Get.isRegistered<HomeController>()) {
          Get.delete<HomeController>();
        }

        Get.put(HomeController());
        Get.find<HomeController>().initialize();

        if ((param['tab'] ?? '').isNotEmpty) {
          navController.onItemTapped(int.tryParse('${param['tab']}') ?? 0);
        } else {
          navController.onItemTapped(0);
        }

        Get.offAllNamed('/home');
      }
    }
  }

  Future sendCode() async {
    if (emailField.text.isNotEmpty && EmailValidator.validate(emailField.text)) {
      Helper.closeKeyboard();

      final register = await LoginApi.sendCode(emailField.text);

      if (register) {
        final param = Get.parameters;
        Map<String, String> newParam = {};

        if ((param['route'] ?? '').isNotEmpty) {
          newParam = {'route': param['route']!};
        }

        Get.toNamed('/login_code', parameters: newParam);
      } else {
        Helper.snackBar(error: true, text: 'Ошибка отправки кода');
      }
    } else {
      Helper.snackBar(error: true, text: 'Заполните E-mail');
    }
  }

  Future validate() async {
    valid.value = emailField.text.isNotEmpty && EmailValidator.validate(emailField.text) && passwordField.text.isNotEmpty;
  }

  Future validateEmailX() async {
    if (emailField.text.isNotEmpty && EmailValidator.validate(emailField.text)) {
      final api = await LoginApi.checkEmail(emailField.text);
      validateEmail.value = !api;
    } else {
      validateEmail.value = false;
    }
  }
}