import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rawmid/widget/primary_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../controller/register.dart';
import '../../utils/constant.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: GetBuilder<RegisterController>(
            init: RegisterController(),
            builder: (controller) => Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.white,
                    titleSpacing: 20,
                    leadingWidth: 0,
                    leading: SizedBox.shrink(),
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                if ((Get.parameters['tab'] ?? '').isNotEmpty) {
                                  controller.navController.onItemTapped(0);
                                }

                                Get.back();
                              },
                              child: Image.asset('assets/icon/left.png')
                          ),
                          Image.asset('assets/image/logo.png', width: 70)
                        ]
                    )
                ),
                backgroundColor: Colors.transparent,
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/image/login_back.png'), fit: BoxFit.cover)
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Container(
                              padding: const EdgeInsets.all(16),
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Регистрация',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                    ),
                                    h(10),
                                    Divider(color: Color(0xFFDDE8EA), thickness: 1, height: 0.1),
                                    h(20),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Адрес электронной почты', style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.28
                                          )),
                                          h(4),
                                          TextFormField(
                                              cursorHeight: 15,
                                              controller: controller.emailField,
                                              decoration: decorationInput(error: controller.validateEmail.value ? dangerColor : null, hint: 'E-mail', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              validator: (val) {
                                                if ((val ?? '').isEmpty) {
                                                  return 'Заполните E-mail';
                                                } else if ((val ?? '').isNotEmpty && !EmailValidator.validate(val!)) {
                                                  return 'E-mail некорректен';
                                                }

                                                return null;
                                              },
                                              onChanged: (val) {
                                                controller.validate();
                                                controller.validateEmailX();
                                              }
                                          ),
                                          if (controller.validateEmail.value) Padding(
                                              padding: const EdgeInsets.only(top: 4, left: 16),
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'E-mail не существует',
                                                        style: TextStyle(color: dangerColor, fontSize: 12)
                                                    )
                                                  ]
                                              )
                                          )
                                        ]
                                    ),
                                    h(16),
                                    _buildPasswordField('Пароль', controller.isPasswordVisible.value, () {
                                      controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                    }, controller.passwordField, controller),
                                    h(16),
                                    _buildPasswordField('Повторите пароль', controller.isPasswordConfirmVisible.value, () {
                                      controller.isPasswordConfirmVisible.value = !controller.isPasswordConfirmVisible.value;
                                    }, controller.confirmField, controller, confirm: true),
                                    h(20),
                                    PrimaryButton(
                                        text: 'Зарегистрироваться',
                                        loader: true,
                                        disable: !controller.valid.value,
                                        height: 40,
                                        borderRadius: 8,
                                        onPressed: controller.register
                                    ),
                                    h(12),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 8,
                                        children: [
                                          Checkbox(
                                              value: controller.agree.value,
                                              onChanged: (value) {
                                                controller.agree.value = value!;
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              side: const BorderSide(color: Colors.lightBlue, width: 2),
                                              activeColor: Colors.lightBlue,
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              visualDensity: VisualDensity.compact
                                          ),
                                          Expanded(
                                              child: Text.rich(
                                                  TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: 'Я прочитал ',
                                                            style: TextStyle(
                                                                color: const Color(0xFF8A95A8),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w700
                                                            )
                                                        ),
                                                        TextSpan(
                                                            recognizer: TapGestureRecognizer()..onTap = () {
                                                              showAdaptiveDialog(
                                                                  context: Get.context!,
                                                                  useRootNavigator: true,
                                                                  useSafeArea: true,
                                                                  builder: (c) {
                                                                    controller.webPersonalController ??= WebViewController()
                                                                      ..setJavaScriptMode(
                                                                          JavaScriptMode.unrestricted)
                                                                      ..loadRequest(Uri.parse('https://madeindream.com/informatsija/usloviya-rashirennoj-garantii.html?ajax=1'));

                                                                    return Scaffold(
                                                                        backgroundColor: Colors.black45,
                                                                        body: Align(
                                                                            alignment: Alignment.center,
                                                                            child: Container(
                                                                                padding: EdgeInsets.all(20),
                                                                                height: Get.height * 0.7,
                                                                                child: Container(
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    child: Stack(
                                                                                        children: [
                                                                                          Padding(
                                                                                              padding: EdgeInsets.all(20),
                                                                                              child: Column(
                                                                                                  children: [
                                                                                                    Expanded(child: WebViewWidget(controller: controller.webPersonalController!))
                                                                                                  ]
                                                                                              )
                                                                                          ),
                                                                                          Positioned(
                                                                                              right: 0,
                                                                                              top: 0,
                                                                                              child: IconButton(onPressed: Get.back, icon: Icon(Icons.close, size: 20, color: Colors.black))
                                                                                          )
                                                                                        ]
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                    );
                                                                  }
                                                              );
                                                            },
                                                            text: 'Условия предоставления расширенной гарантии',
                                                            style: TextStyle(
                                                                color: const Color(0xFF14BFFF),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w700
                                                            )
                                                        ),
                                                        TextSpan(
                                                            text: ' и ',
                                                            style: TextStyle(
                                                                color: const Color(0xFF8A95A8),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w700
                                                            )
                                                        ),
                                                        TextSpan(
                                                            recognizer: TapGestureRecognizer()..onTap = () {
                                                              showAdaptiveDialog(
                                                                  context: Get.context!,
                                                                  useRootNavigator: true,
                                                                  useSafeArea: true,
                                                                  builder: (c) {
                                                                    controller.webPersonalController ??= WebViewController()
                                                                      ..setJavaScriptMode(
                                                                          JavaScriptMode.unrestricted)
                                                                      ..loadRequest(Uri.parse('https://madeindream.com/informatsija/politika-obrabotki.html?ajax=1'));

                                                                    return Scaffold(
                                                                        backgroundColor: Colors.black45,
                                                                        body: Align(
                                                                            alignment: Alignment.center,
                                                                            child: Container(
                                                                                padding: EdgeInsets.all(20),
                                                                                height: Get.height * 0.7,
                                                                                child: Container(
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    child: Stack(
                                                                                        children: [
                                                                                          Padding(
                                                                                              padding: EdgeInsets.all(20),
                                                                                              child: Column(
                                                                                                  children: [
                                                                                                    Expanded(child: WebViewWidget(controller: controller.webPersonalController!))
                                                                                                  ]
                                                                                              )
                                                                                          ),
                                                                                          Positioned(
                                                                                              right: 0,
                                                                                              top: 0,
                                                                                              child: IconButton(onPressed: Get.back, icon: Icon(Icons.close, size: 20, color: Colors.black))
                                                                                          )
                                                                                        ]
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                    );
                                                                  }
                                                              );
                                                            },
                                                            text: 'Политику обработки персональных даных',
                                                            style: TextStyle(
                                                                color: const Color(0xFF14BFFF),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w700
                                                            )
                                                        ),
                                                        TextSpan(
                                                            text: ' и согласен с условиями.',
                                                            style: TextStyle(
                                                                color: const Color(0xFF8A95A8),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w700
                                                            )
                                                        )
                                                      ]
                                                  )
                                              )
                                          )
                                        ]
                                    ),
                                    h(24),
                                    Center(
                                        child: Text(
                                            'Уже есть аккаунт?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF8A95A8),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.24
                                            )
                                        )
                                    ),
                                    Center(
                                        child: TextButton(
                                            onPressed: () {
                                              if ((Get.parameters['tab'] ?? '').isNotEmpty) {
                                                Get.offNamed('login', parameters: {'tab': Get.parameters['tab']!});
                                              } else {
                                                Get.offNamed('login');
                                              }
                                            },
                                            child: Text('Вход', style: TextStyle(color: Colors.blue))
                                        )
                                    )
                                  ]
                              )
                          ))
                        ]
                    )
                  )
                )
            )
        )
    );
  }

  Widget _buildPasswordField(String label, bool isVisible, VoidCallback toggleVisibility, TextEditingController controllerField, RegisterController controller, {bool confirm = false}) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          h(4),
          TextFormField(
              cursorHeight: 15,
              controller: controllerField,
              obscureText: !isVisible,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: decorationInput(hint: 'Введите пароль', contentPadding: const EdgeInsets.symmetric(horizontal: 16), suffixIcon: IconButton(
                  icon: Icon(!isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                  onPressed: toggleVisibility
              )),
              onChanged: (val) => controller.validate(),
              validator: (val) {
                if ((val ?? '').isEmpty) {
                  return 'Заполните пароль';
                } else if (confirm && controller.passwordField.text.length == controller.confirmField.text.length && controller.passwordField.text != controller.confirmField.text) {
                  return 'Пароль не совпадают';
                }

                return null;
              }
          )
        ]
    );
  }
}