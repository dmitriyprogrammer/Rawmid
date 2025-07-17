import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:rawmid/screen/user/address.dart';
import 'package:rawmid/screen/user/profile.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../../widget/h.dart';
import '../../controller/user.dart';
import '../../utils/utils.dart';
import 'account_setting.dart';
import 'fiz_field.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
        init: UserController(),
        builder: (controller) => Scaffold(
          appBar: AppBar(
                backgroundColor: Colors.white,
                titleSpacing: 0,
                leadingWidth: 0,
                leading: SizedBox.shrink(),
                title: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (controller.edit.value) {
                                controller.edit.value = false;
                              } else {
                                Get.back();
                              }
                            },
                            icon: Image.asset('assets/icon/left.png')
                        ),
                        Image.asset('assets/image/logo.png', width: 70)
                      ]
                  )
                )
            ),
          backgroundColor: Colors.white,
          body: Obx(() => SafeArea(
              bottom: false,
              child: controller.isLoading.value ? SingleChildScrollView(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 34),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        h(20),
                        Text(
                          'Настройки',
                          style: TextStyle(
                            color: Color(0xFF1B1B1B),
                            fontSize: 24,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        h(20),
                        controller.edit.value ? Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              controller.tab.value == 0 ? FizFieldView() : Wrap(
                                runSpacing: 16,
                                children: controller.controllerUr.entries.map((item) => Column(
                                  children: [
                                    item.key == 'phone_buh' ? PhoneFormField(
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
                                      decoration: decorationInput(contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
                                    ) :
                                    TextFormField(
                                        controller: item.value,
                                        cursorHeight: 15,
                                        focusNode: controller.focusNodeUrAddress[item.key],
                                        validator: (value) => controller.activeField.value == item.key ? controller.validators[item.key]!(value) : null,
                                        decoration: decorationInput(error: item.key == 'email' && controller.usEmailValidate.value ? dangerColor : null, prefixIcon: item.key == 'phone_buh' ? Image.asset('assets/icon/rph.png', width: 20) : null, hint: controller.controllerHints[item.key], contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (val) async {
                                          if (item.key == 'email') {
                                            controller.validateEmailX(val);
                                          }
                                        }
                                    ),
                                    if (item.key == 'email' && controller.usEmailValidate.value) Padding(
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
                                )).toList()
                              ),
                              if (controller.tab.value == 1) h(16),
                              if (controller.tab.value == 1) DropdownButtonFormField<String?>(
                                  value: controller.edo.value,
                                  isExpanded: true,
                                  decoration: decorationInput(hint: 'ЭДО', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                  items: ['ДИАДОК', 'СБИС', 'НЕТ'].map((item) {
                                    return DropdownMenuItem<String?>(
                                        value: item,
                                        child: Text(item, style: TextStyle(fontSize: 14))
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    controller.edo.value = newValue;
                                  }
                              ),
                              h(16),
                              PrimaryButton(text: 'Сохранить', height: 46, loader: true, onPressed: () async {
                                if (controller.tab.value == 0) {
                                  await controller.save();
                                } else {
                                  await controller.saveUz();
                                }
                              }),
                              h(16),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.all(4),
                                decoration: ShapeDecoration(
                                  color: Color(0xFFEBF3F6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => controller.setTab(0),
                                        child: Container(
                                            height: 32,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: ShapeDecoration(
                                                color: Color(controller.tab.value == 0 ? 0xFF80AEBF : 0xFFEBF3F6),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                                'Физическое лицо',
                                                style: TextStyle(
                                                    color: controller.tab.value != 0 ? Color(0xFF80AEBF) : Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.24
                                                )
                                            )
                                        )
                                      )
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => controller.setTab(1),
                                        child: Container(
                                            height: 32,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: ShapeDecoration(
                                                color: Color(controller.tab.value == 1 ? 0xFF80AEBF : 0xFFEBF3F6),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                                'Юридическое лицо',
                                                style: TextStyle(
                                                    color: controller.tab.value != 1 ? Color(0xFF80AEBF) : Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.24
                                                )
                                            )
                                        )
                                      )
                                    )
                                  ]
                                )
                              )
                            ]
                          )
                        ) : ProfileSection(),
                        h(22),
                        AddressView(),
                        h(50),
                        AccountSettingView()
                      ]
                  )
              ) : Center(
                  child: CircularProgressIndicator(color: primaryColor)
              )
          ))
        )
    );
  }
}