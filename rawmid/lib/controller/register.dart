import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../utils/helper.dart';
import '../api/home.dart';
import '../api/login.dart';
import '../utils/notifications.dart';
import 'navigation.dart';

class RegisterController extends GetxController {
  RxBool submit = false.obs;
  RxBool valid = false.obs;
  RxBool agree = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isPasswordConfirmVisible = false.obs;
  final TextEditingController emailField = TextEditingController();
  final TextEditingController passwordField = TextEditingController();
  final TextEditingController confirmField = TextEditingController();
  final navController = Get.find<NavigationController>();
  RxBool validateEmail = false.obs;
  WebViewController? webPersonalController;

  Future register() async {
    if (!agree.value) {
      Helper.snackBar(error: true, text: 'Необходимо принять условия и политику обработки');
      return;
    }

    if (valid.value && !submit.value) {
      submit.value = true;
      Helper.closeKeyboard();

      final user = await LoginApi.register({
        'email': emailField.text,
        'password': passwordField.text,
        'firstname': emailField.text.split('@')[0]
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

        if ((param['tab'] ?? '').isNotEmpty) {
          navController.onItemTapped(int.tryParse('${param['tab']}') ?? 0);
        } else {
          navController.onItemTapped(0);
        }

        Get.offAllNamed('home');
      }

      submit.value = false;
    }
  }

  Future validate() async {
    valid.value = emailField.text.isNotEmpty && EmailValidator.validate(emailField.text) && passwordField.text.isNotEmpty && confirmField.text.isNotEmpty && passwordField.text == confirmField.text;
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