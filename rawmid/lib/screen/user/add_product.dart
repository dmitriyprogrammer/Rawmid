import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:rawmid/utils/helper.dart';
import 'package:rawmid/widget/module_title.dart';
import 'package:rawmid/widget/primary_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../widget/h.dart';
import '../../controller/my_product.dart';
import '../../model/product/product_autocomplete.dart';
import '../../utils/constant.dart';
import '../../utils/utils.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../product/zap.dart';

class AddProductView extends GetView<MyProductController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          onPressed: Get.back,
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
            child: Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ColoredBox(
                                color: Color(0xFFF0F0F0),
                                child: Column(
                                    children: [
                                      h(20),
                                      SearchBarView(),
                                      h(20)
                                    ]
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Form(
                                  key: controller.formKey,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        h(10),
                                        ModuleTitle(title: 'Регистрация товара', type: true),
                                        h(24),
                                        TextFormField(
                                            cursorHeight: 15,
                                            controller: controller.lastnameField,
                                            decoration: decorationInput(hint: 'Фамилия*', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (val) {
                                              if ((val ?? '').isEmpty) {
                                                return 'Заполните фамилию';
                                              }

                                              return null;
                                            }
                                        ),
                                        h(8),
                                        TextFormField(
                                            cursorHeight: 15,
                                            controller: controller.nameField,
                                            decoration: decorationInput(hint: 'Имя*', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (val) {
                                              if ((val ?? '').isEmpty) {
                                                return 'Заполните имя';
                                              }

                                              return null;
                                            }
                                        ),
                                        h(8),
                                        TextFormField(
                                            cursorHeight: 15,
                                            controller: controller.emailField,
                                            decoration: decorationInput(error: controller.validateEmail.value ? dangerColor : null, hint: 'E-mail*', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
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
                                        ),
                                        h(8),
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
                                          decoration: decorationInput(contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
                                        ),
                                        h(24),
                                        DropdownButtonFormField<String?>(
                                            value: controller.place.value,
                                            isExpanded: true,
                                            decoration: decorationInput(hint: 'Место покупки*', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                            items: controller.places.map((item) {
                                              return DropdownMenuItem<String?>(
                                                  value: item,
                                                  child: Text(item, style: TextStyle(fontSize: 14))
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              controller.place.value = newValue;

                                              if (newValue == 'madeindream.com' && controller.orderIds.isEmpty) {
                                                controller.getOrderIds();
                                              }
                                            }
                                        ),
                                        if (!controller.noOrderId.value) h(8),
                                        if (controller.place.value == 'madeindream.com' && !controller.noOrderId.value) DropdownButtonFormField<String?>(
                                            value: controller.orderId.value,
                                            isExpanded: true,
                                            validator: (val) {
                                              if ((val ?? '').isEmpty && !controller.noOrderId.value) {
                                                return ' ';
                                              }

                                              return null;
                                            },
                                            decoration: decorationInput(hint: '№ заказа*', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                            items: controller.orderIds.map((item) {
                                              return DropdownMenuItem<String?>(
                                                  value: item,
                                                  child: Text(item, style: TextStyle(fontSize: 14))
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              controller.orderId.value = newValue;
                                            }
                                        ),
                                        if (controller.place.value == 'madeindream.com') h(8),
                                        if (controller.place.value == 'madeindream.com') Row(
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 8,
                                            children: [
                                              Checkbox(
                                                  value: controller.noOrderId.value,
                                                  onChanged: (value) {
                                                    controller.noOrderId.value = value!;
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  side: const BorderSide(color: Colors.lightBlue, width: 2),
                                                  activeColor: Colors.lightBlue,
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  visualDensity: VisualDensity.compact
                                              ),
                                              Text(
                                                  'Не помню номер заказа',
                                                  style: TextStyle(
                                                      color: const Color(0xFF8A95A8),
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700
                                                  )
                                              )
                                            ]
                                        ),
                                        h(8),
                                        TextFormField(
                                            controller: controller.dateField,
                                            readOnly: true,
                                            onTap: () => controller.selectDate(context),
                                            validator: (val) {
                                              if ((val ?? '').isEmpty) return ' ';
                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                            textInputAction: TextInputAction.next,
                                            decoration: decorationInput(hint: 'Укажите дату покупки', contentPadding: const EdgeInsets.symmetric(horizontal: 20), suffixIcon: InkWell(
                                                onTap: () {
                                                  Helper.snackBar(title: '', text: 'Дата должна совпадать с датой указанной в чеке, при наступлении гарантийного случая потребуются оригиналы чеков!');
                                                },
                                                child: Icon(Icons.info, color: primaryColor)
                                            ))
                                        ),
                                        h(8),
                                        Text(
                                            'Дата должна совпадать с датой, указанной на чеке, при наступлении гарантийного случая потребуются оригиналы чеков.',
                                            style: TextStyle(
                                                color: const Color(0xFF8A95A8),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500
                                            )
                                        ),
                                        h(24),
                                        TypeAheadField<ProductAutocompleteModel>(
                                          suggestionsCallback: controller.suggestionsCallback,
                                          controller: controller.productField,
                                          itemBuilder: (context, e) => ListTile(title: Text(e.name)),
                                          onSelected: (e) {
                                            controller.productField.text = e.name;
                                            controller.modelField.text = e.model;
                                            controller.productId.value = e.id;
                                            controller.noSer.value = e.noSer;

                                            if (!e.noSer) {
                                              controller.noSerCheck.value = false;
                                            }
                                          },
                                          builder: (context, textController, focusNode) {
                                            return TextFormField(
                                              controller: textController,
                                              focusNode: focusNode,
                                              textInputAction: TextInputAction.next,
                                              decoration: decorationInput(
                                                hint: 'Наименование товара*',
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                              ),
                                              validator: (val) {
                                                if ((val ?? '').isEmpty) return ' ';
                                                return null;
                                              }
                                            );
                                          }
                                        ),
                                        h(8),
                                        TypeAheadField<ProductAutocompleteModel>(
                                            suggestionsCallback: controller.suggestionsCallback2,
                                            controller: controller.modelField,
                                            itemBuilder: (context, e) => ListTile(title: Text(e.name)),
                                            onSelected: (e) {
                                              controller.productField.text = e.name;
                                              controller.modelField.text = e.model;
                                              controller.productId.value = e.id;
                                              controller.noSer.value = e.noSer;

                                              if (!e.noSer) {
                                                controller.noSerCheck.value = false;
                                              }
                                            },
                                            builder: (context, textController, focusNode) {
                                              return TextFormField(
                                                  controller: textController,
                                                  focusNode: focusNode,
                                                  textInputAction: TextInputAction.next,
                                                  decoration: decorationInput(
                                                    hint: 'Модель товара*',
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                                    suffixIcon: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                                opaque: false,
                                                                pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: 'https://madeindream.com/image/whereis_model.jpg'),
                                                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                  return FadeTransition(opacity: animation, child: child);
                                                                }
                                                            )
                                                        );
                                                      },
                                                      child: Icon(Icons.info, color: primaryColor)
                                                    )
                                                  ),
                                                  validator: (val) {
                                                    if ((val ?? '').isEmpty) return ' ';
                                                    return null;
                                                  }
                                              );
                                            }
                                        ),
                                        h(8),
                                        TextFormField(
                                            controller: controller.numberField,
                                            validator: (val) {
                                              if ((val ?? '').isEmpty && !controller.noSerCheck.value) return ' ';
                                              return null;
                                            },
                                            textInputAction: TextInputAction.next,
                                            decoration: decorationInput(hint: 'Серийный номер (английскими буквами)*', contentPadding: const EdgeInsets.symmetric(horizontal: 20), suffixIcon: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                          opaque: false,
                                                          pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: 'https://madeindream.com/image/whereis_sernum.jpg'),
                                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                            return FadeTransition(opacity: animation, child: child);
                                                          }
                                                      )
                                                  );
                                                },
                                                child: Icon(Icons.info, color: primaryColor)
                                            ))
                                        ),
                                        if (controller.noSer.value) h(8),
                                        if (controller.noSer.value) Row(
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 8,
                                            children: [
                                              Checkbox(
                                                  value: controller.noSerCheck.value,
                                                  onChanged: (value) {
                                                    controller.noSerCheck.value = value!;
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  side: const BorderSide(color: Colors.lightBlue, width: 2),
                                                  activeColor: Colors.lightBlue,
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  visualDensity: VisualDensity.compact
                                              ),
                                              Text(
                                                  'Нет серийного номера',
                                                  style: TextStyle(
                                                      color: const Color(0xFF8A95A8),
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700
                                                  )
                                              )
                                            ]
                                        ),
                                        h(8),
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 8,
                                            children: [
                                              Checkbox(
                                                  value: controller.commerce.value,
                                                  onChanged: (value) {
                                                    controller.commerce.value = value!;
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  side: const BorderSide(color: Colors.lightBlue, width: 2),
                                                  activeColor: Colors.lightBlue,
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  visualDensity: VisualDensity.compact
                                              ),
                                              Text(
                                                  'Коммерческое использование',
                                                  style: TextStyle(
                                                      color: const Color(0xFF8A95A8),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700
                                                  )
                                              )
                                            ]
                                        ),
                                        h(24),
                                        PrimaryButton(text: 'Зарегистрировать', loader: true, height: 48, onPressed: controller.register),
                                        h(10),
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
                                        h(40),
                                        PrimaryButton(text: 'Вернуться на главную', height: 40, background: Colors.white, borderColor: primaryColor, borderWidth: 2, textStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w700), onPressed: () => controller.main.onItemTapped(0)),
                                        h(MediaQuery.of(context).padding.bottom + 20)
                                      ]
                                  )
                                )
                            )
                          ]
                      )
                  ),
                  SearchWidget()
                ]
            )
        ))
    );
  }
}