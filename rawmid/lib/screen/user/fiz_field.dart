import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../widget/h.dart';
import '../../controller/user.dart';
import '../../utils/constant.dart';
import '../../utils/utils.dart';

class FizFieldView extends GetView<UserController> {
  const FizFieldView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
              controller: controller.controllers['lastname'],
              focusNode: controller.focusNodes['lastname'],
              cursorHeight: 15,
              validator: (value) => controller.activeField.value == 'lastname' ? controller.validators['lastname']!(value) : null,
              decoration: decorationInput(hint: 'Фамилия *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next
          ),
          h(16),
          TextFormField(
              controller: controller.controllers['firstname'],
              focusNode: controller.focusNodes['firstname'],
              cursorHeight: 15,
              validator: (value) => controller.activeField.value == 'firstname' ? controller.validators['firstname']!(value) : null,
              decoration: decorationInput(hint: 'Имя *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next
          ),
          h(16),
          PhoneFormField(
            controller: controller.phoneField,
            validator: PhoneValidator.compose([PhoneValidator.required(Get.context!, errorText: 'Номер телефона обязателен'), PhoneValidator.validMobile(Get.context!, errorText: 'Номер телефона некорректен')]),
            countrySelectorNavigator: const CountrySelectorNavigator.draggableBottomSheet(),
            isCountrySelectionEnabled: true,
            isCountryButtonPersistent: true,
            autofillHints: const [AutofillHints.telephoneNumber],
            countryButtonStyle: const CountryButtonStyle(
                showDialCode: true,
                showIsoCode: false,
                showFlag: true,
                showDropdownIcon: false,
                flagSize: 20
            ),
            textInputAction: TextInputAction.next,
            decoration: decorationInput(contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
          ),
          h(16),
          TextFormField(
              controller: controller.controllers['email'],
              focusNode: controller.focusNodes['email'],
              cursorHeight: 15,
              validator: (value) => controller.activeField.value == 'email' ? controller.validators['email']!(value) : null,
              decoration: decorationInput(hint: 'E-mail *', error: controller.fizEmailValidate.value ? dangerColor : null, contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.done,
              onChanged: controller.validateEmailX
          ),
          if (controller.fizEmailValidate.value) Padding(
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
    ));
  }
}