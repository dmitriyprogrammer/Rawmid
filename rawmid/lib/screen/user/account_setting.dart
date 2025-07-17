import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/h.dart';
import '../../controller/user.dart';
import '../../utils/utils.dart';
import '../../widget/primary_button.dart';
import '../../widget/switch.dart';
import '../../widget/w.dart';

class AccountSettingView extends GetView<UserController> {
  const AccountSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Настройка аккаунта', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          h(12),
          Divider(color: Color(0xFFDDE8EA), height: 1),
          h(24),
          Text(
              'Смена пароля',
              style: TextStyle(
                  color: Color(0xFF8A95A8),
                  fontSize: 14
              )
          ),
          h(10),
          Row(
              children: [
                Expanded(
                    flex: 2,
                    child: SizedBox(
                        height: 45,
                        child: TextFormField(
                            controller: controller.changePasswordField,
                            obscureText: true,
                            cursorHeight: 15,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: (val) {
                              controller.changePassValid.value = val.isNotEmpty;
                            },
                            decoration: decorationInput(hint: 'Введите новый пароль*', contentPadding: const EdgeInsets.symmetric(horizontal: 16))
                        )
                    )
                ),
                w(10),
                Expanded(
                    child: PrimaryButton(text: 'Сменить', disable: !controller.changePassValid.value, loader: true, height: 44, onPressed: controller.changePass)
                )
              ]
          ),
          h(20),
          Text(
              'Подписка на новости',
              style: TextStyle(
                  color: Color(0xFF8A95A8),
                  fontSize: 14
              )
          ),
          h(16),
          SwitchTile(title: 'Хочу получать информацию о выгодных предложениях и новинках', value: controller.newsSubscription.value, onChanged: (val) {
            controller.newsSubscription.value = val;
            controller.setNewsletter(val);
          }),
          h(20),
          Text(
              'Уведомления',
              style: TextStyle(
                  color: Color(0xFF8A95A8),
                  fontSize: 14
              )
          ),
          SwitchTile(title: 'Получать push-уведомления', value: controller.pushNotifications.value, onChanged: (val) {
            controller.pushNotifications.value = val;
            controller.setPush(val);
          }),
          h(16),
          Divider(color: Color(0xFFDDE8EA), height: 1)
        ]
    ));
  }
}