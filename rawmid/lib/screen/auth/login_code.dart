import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/primary_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../controller/login.dart';
import '../../widget/h.dart';

class LoginCodeView extends StatelessWidget {
  const LoginCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    const focusedBorderColor = Color(0xFFA1ABB9);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);

    final defaultPinTheme = PinTheme(
        width: 60,
        height: 54,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        textStyle: const TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w600),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Color(0xFFDDE8EA)),
          borderRadius: BorderRadius.circular(8)
        )
    );

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: Scaffold(
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Вход',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                                h(10),
                                Divider(color: Color(0xFFDDE8EA), thickness: 1, height: 0.1),
                                h(30),
                                Text(
                                  'Введите код',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.28
                                  )
                                ),
                                h(10),
                                Pinput(
                                    controller: controller.pinController,
                                    focusNode: controller.focusNode,
                                    defaultPinTheme: defaultPinTheme,
                                    separatorBuilder: (index) => const SizedBox(width: 8),
                                    validator: (value) {
                                      return value != null && value.length == 4 ? null : 'Проверочный код введен неверно';
                                    },
                                    length: 4,
                                    hapticFeedbackType:
                                    HapticFeedbackType.lightImpact,
                                    onCompleted: (pin) {
                                      controller.verificationCode.value = pin;
                                      controller.valid.value = pin.length == 4;
                                    },
                                    autofocus: true,
                                    cursor: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(bottom: 9),
                                              width: 22,
                                              height: 2,
                                              decoration: defaultPinTheme.decoration!.copyWith(
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(color: const Color(0xFFA1ABB9))
                                              )
                                          )
                                        ]
                                    ),
                                    focusedPinTheme: defaultPinTheme.copyWith(
                                        decoration: defaultPinTheme.decoration!.copyWith(
                                          borderRadius: BorderRadius.circular(8), border: Border.all(color: focusedBorderColor)
                                        )
                                    ),
                                    submittedPinTheme: defaultPinTheme.copyWith(
                                        decoration: defaultPinTheme.decoration!.copyWith(
                                          color: fillColor,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: focusedBorderColor)
                                        )
                                    ),
                                    errorPinTheme: defaultPinTheme.copyBorderWith(
                                        border: Border.all(color: Colors.redAccent)
                                    )
                                ),
                                h(8),
                                Text(
                                  'Код для доступа был отправлен на указанный вами EMAIL',
                                  style: TextStyle(
                                    color: Color(0xFF8A95A8),
                                    fontSize: 12,
                                    letterSpacing: 0.24
                                  ),
                                  textAlign: TextAlign.center
                                ),
                                h(48),
                                PrimaryButton(
                                    text: 'Войти через пароль',
                                    loader: true,
                                    height: 40,
                                    borderRadius: 8,
                                    background: Colors.white,
                                    borderColor: primaryColor,
                                    borderWidth: 2,
                                    textStyle: TextStyle(color: primaryColor),
                                    onPressed: Get.back
                                ),
                                h(6),
                                PrimaryButton(
                                    text: 'Войти',
                                    loader: true,
                                    disable: !controller.valid.value,
                                    height: 40,
                                    borderRadius: 8,
                                    onPressed: controller.loginCode
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
                                        'Еще нет аккаунта?',
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
                                            Get.toNamed('register', parameters: {'tab': Get.parameters['tab']!});
                                          } else {
                                            Get.toNamed('register');
                                          }
                                        },
                                        child: Text('Зарегистрироваться', style: TextStyle(color: Colors.blue))
                                    )
                                )
                              ]
                          )
                      ))
                    ]
                )
            )
        )
    );
  }
}