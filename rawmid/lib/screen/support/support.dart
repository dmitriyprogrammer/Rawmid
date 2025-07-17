import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/widget/module_title.dart';
import 'package:rawmid/widget/primary_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../controller/support.dart';
import '../../model/profile/sernum_support.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../../widget/w.dart';
import '../home/city.dart';
import '../product/zap.dart';

class SupportView extends GetView<NavigationController> {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportController>(
        init: SupportController(),
        builder: (support) => Obx(() => Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                titleSpacing: 0,
                leadingWidth: 0,
                leading: SizedBox.shrink(),
                title: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: Get.back,
                              icon: Image.asset('assets/icon/left.png')
                          ),
                          if (controller.city.value.isNotEmpty) w(10),
                          if (controller.city.value.isNotEmpty) Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    final nav = Get.find<NavigationController>();
                                    final city = nav.city.value;

                                    showModalBottomSheet(
                                        context: Get.context!,
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        useRootNavigator: true,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                        ),
                                        builder: (context) {
                                          return CitySearch();
                                        }
                                    ).then((_) async {
                                      controller.filteredCities.value = controller.cities;
                                      controller.filteredLocation.clear();
                                      if (city == nav.city.value) return;
                                      controller.initialize();
                                      controller.update();
                                      await support.initialize();

                                      support.map.value!.moveCamera(
                                          CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                  target: support.contact.value?.map.center ?? const Point(latitude: 55.853593, longitude: 37.501265),
                                                  zoom: 10
                                              )
                                          )
                                      );
                                    });
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.location_on_rounded, color: Color(0xFF14BFFF)),
                                            w(6),
                                            Flexible(
                                                child: Text(
                                                    controller.city.value,
                                                    textAlign: TextAlign.right,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Color(0xFF14BFFF),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600
                                                    )
                                                )
                                            )
                                          ]
                                      )
                                  )
                              )
                          )
                        ]
                    )
                )
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SafeArea(
                bottom: false,
                child: Stack(
                    children: [
                      SingleChildScrollView(
                          child: Stack(
                              children: [
                                Container(
                                    color: Colors.white,
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
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    h(20),
                                                    Text(
                                                        'Поддержка',
                                                        style: TextStyle(
                                                            color: Color(0xFF1E1E1E),
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.w700
                                                        )
                                                    ),
                                                    h(support.questions.isNotEmpty ? 32 : 6),
                                                    if (support.questions.isNotEmpty) Text(
                                                        'Часто задаваемые вопросы',
                                                        style: TextStyle(
                                                            color: Color(0xFF1E1E1E),
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w700
                                                        )
                                                    ),
                                                    if (support.questions.isNotEmpty) h(20),
                                                    if (support.questions.isNotEmpty) Wrap(
                                                        children: List.generate(support.questions.length, (index) {
                                                          return Column(
                                                              children: [
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      support.isExpandedList[index] = !support.isExpandedList[index];
                                                                    },
                                                                    child: Container(
                                                                        color: Colors.transparent,
                                                                        child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              ListTile(
                                                                                  title: Text(
                                                                                      support.questions[index].question,
                                                                                      style: TextStyle(
                                                                                          color: Color(0xFF1E1E1E),
                                                                                          fontSize: 16,
                                                                                          height: 1.40
                                                                                      )
                                                                                  ),
                                                                                  trailing: AnimatedRotation(
                                                                                      turns: support.isExpandedList[index] ? 0.5 : 0,
                                                                                      duration: Duration(milliseconds: 300),
                                                                                      child: Icon(
                                                                                          Icons.expand_more,
                                                                                          color: Colors.grey
                                                                                      )
                                                                                  ),
                                                                                  contentPadding: EdgeInsets.zero
                                                                              ),
                                                                              AnimatedSize(
                                                                                  duration: Duration(milliseconds: 300),
                                                                                  curve: Curves.easeInOut,
                                                                                  child: support.isExpandedList[index] ? Transform.translate(
                                                                                      offset: Offset(-8, 0),
                                                                                      child: Padding(
                                                                                          padding: EdgeInsets.symmetric(vertical: 8),
                                                                                          child: Html(
                                                                                              data: support.questions[index].answer,
                                                                                              extensions: [
                                                                                                TagExtension(
                                                                                                    tagsToExtend: {'img'},
                                                                                                    builder: (context) {
                                                                                                      final src = context.attributes['src'] ?? '';

                                                                                                      return GestureDetector(
                                                                                                          onTap: () {
                                                                                                            Navigator.push(
                                                                                                                Get.context!,
                                                                                                                PageRouteBuilder(
                                                                                                                    opaque: false,
                                                                                                                    pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: src),
                                                                                                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                                                                      return FadeTransition(opacity: animation, child: child);
                                                                                                                    }
                                                                                                                )
                                                                                                            );
                                                                                                          },
                                                                                                          child: Image.network(src)
                                                                                                      );
                                                                                                    }
                                                                                                )
                                                                                              ],
                                                                                              onLinkTap: (val, map, element) {
                                                                                                if ((val ?? '').isNotEmpty) {
                                                                                                  Helper.openLink(val!);
                                                                                                }
                                                                                              }
                                                                                          )
                                                                                      )
                                                                                  ) : SizedBox.shrink()
                                                                              )
                                                                            ]
                                                                        )
                                                                    )
                                                                ),
                                                                Divider(height: 1, color: Colors.grey[300]),
                                                              ]
                                                          );
                                                        }).toList()
                                                    ),
                                                    if (support.questions.isNotEmpty) h(20),
                                                    if (support.questions.isNotEmpty) Text(
                                                        'Остались вопросы?',
                                                        style: TextStyle(
                                                            color: Color(0xFF1E1E1E),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600
                                                        )
                                                    ),
                                                    h(20),
                                                    DropdownButtonFormField<int>(
                                                        value: support.type.value,
                                                        isExpanded: true,
                                                        decoration: decorationInput(hint: 'Отдел', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                                        items: List.generate(support.types.length, (index) {
                                                          return DropdownMenuItem<int>(
                                                              value: index,
                                                              child: Text(support.types[index], style: TextStyle(fontSize: 14))
                                                          );
                                                        }).toList(),
                                                        onChanged: (val) {
                                                          support.type.value = val;
                                                          support.subjectField.text = [2, 3, 4, 5, 7].contains(val) ? '' : support.types[val!];

                                                          if (val == 0 && support.orderId.value != null) {
                                                            support.subjectField.text += ' №${support.orderId.value}';
                                                          }

                                                          if (val == 6) {
                                                            support.textField.text = "Сумма:\r\nДата оплаты:\r\nВремя оплаты:\r\nКуда оплатили:\r\nФИО плательщика:\r\n";
                                                          }
                                                        }
                                                    ),
                                                    if (![0, 1, 6].contains(support.type.value) && controller.user.value == null || support.type.value == null) h(16),
                                                    if (support.type.value == 1 && controller.user.value == null) Text.rich(
                                                        TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text: 'Для сервисного обращения необходимо ',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700,
                                                                      letterSpacing: 0.30
                                                                  )
                                                              ),
                                                              TextSpan(
                                                                  text: 'авторизироваться',
                                                                  recognizer: TapGestureRecognizer()..onTap = () {
                                                                    Get.toNamed('/login', parameters: {'route': '/support'});
                                                                  },
                                                                  style: TextStyle(
                                                                      color: primaryColor,
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.w700,
                                                                      letterSpacing: 0.30
                                                                  )
                                                              )
                                                            ]
                                                        )
                                                    ),
                                                    if (support.type.value == 1 && controller.user.value == null) h(16),
                                                    Form(
                                                        key: support.formKey,
                                                        child: Column(
                                                            children: [
                                                              if (![0, 1, 2, 3, 4, 5, 6, 7].contains(support.type.value) || controller.user.value == null) TextFormField(
                                                                  key: support.target,
                                                                  cursorHeight: 15,
                                                                  autofocus: support.orderId.value != null,
                                                                  controller: support.emailField,
                                                                  decoration: decorationInput(hint: 'E-mail *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                  onChanged: support.validateEmailX,
                                                                  validator: (value) {
                                                                    String? item;

                                                                    if (support.type.value != null && (value == null || value.isEmpty)) item = 'Введите email';
                                                                    if (support.type.value != null && value != null && !EmailValidator.validate(value)) item = 'Некорректный email';

                                                                    return item;
                                                                  },
                                                                  textInputAction: TextInputAction.next
                                                              ),
                                                              if (support.type.value != null && support.emailValidate.value) Padding(
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
                                                              if (![0, 1, 5, 6, 7].contains(support.type.value) || controller.user.value == null) h(16),
                                                              if (![0, 1, 2, 3, 4, 5, 6, 7].contains(support.type.value) || controller.user.value == null) TextFormField(
                                                                  cursorHeight: 15,
                                                                  controller: support.nameField,
                                                                  decoration: decorationInput(hint: 'Имя *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                  validator: (value) {
                                                                    String? item;

                                                                    if (support.type.value != null && (value == null || value.isEmpty)) item = 'Введите имя';

                                                                    return item;
                                                                  },
                                                                  textInputAction: TextInputAction.next
                                                              ),
                                                              if ((support.type.value == 0 || support.type.value == 6) && controller.user.value != null) h(16),
                                                              if ((support.type.value == 0 || support.type.value == 6) && controller.user.value != null) DropdownButtonFormField<String?>(
                                                                  value: support.orderId.value,
                                                                  isExpanded: true,
                                                                  validator: (val) {
                                                                    if (support.type.value != null && (val ?? '').isEmpty) {
                                                                      return ' ';
                                                                    }

                                                                    return null;
                                                                  },
                                                                  decoration: decorationInput(hint: '№ заказа*', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                                                  items: support.orderIds.map((item) {
                                                                    return DropdownMenuItem<String?>(
                                                                        value: item,
                                                                        child: Text(item, style: TextStyle(fontSize: 14))
                                                                    );
                                                                  }).toList(),
                                                                  onChanged: (newValue) {
                                                                    support.orderId.value = newValue;
                                                                    support.subjectField.text = '${support.types[0]} №${support.orderId.value}';
                                                                  }
                                                              ),
                                                              if (support.type.value == 1 && controller.user.value != null) h(16),
                                                              if (support.type.value == 1 && controller.user.value != null) DropdownButtonFormField<SernumSupportModel?>(
                                                                  value: support.sernum.value,
                                                                  isExpanded: true,
                                                                  validator: (val) {
                                                                    if (support.type.value != null && (val?.sernum ?? '').isEmpty) {
                                                                      return ' ';
                                                                    }

                                                                    return null;
                                                                  },
                                                                  decoration: decorationInput(hint: 'Серийный номер*', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                                                  items: support.sernums.map((item) {
                                                                    return DropdownMenuItem<SernumSupportModel?>(
                                                                        value: item,
                                                                        child: Text('${item.model} № ${item.sernum}', style: TextStyle(fontSize: 14))
                                                                    );
                                                                  }).toList(),
                                                                  onChanged: (newValue) {
                                                                    support.sernum.value = newValue;

                                                                    if (newValue != null) {
                                                                      support.subjectField.text = 'Вопрос по товару сер. номер ${newValue.sernum}';
                                                                    }
                                                                  }
                                                              ),
                                                              if ([0, 1, 5, 6, 7].contains(support.type.value) || controller.user.value == null || support.type.value == null) h(16),
                                                              if (support.type.value == 1) Row(
                                                                  children: [
                                                                    InkWell(
                                                                        onTap: () => Get.toNamed('/my_products', arguments: true),
                                                                        child: Text(
                                                                            'Зарегистрировать товар',
                                                                            style: TextStyle(color: primaryColor)
                                                                        )
                                                                    )
                                                                  ]
                                                              ),
                                                              if (support.type.value == 1) h(16),
                                                              TextFormField(
                                                                  cursorHeight: 15,
                                                                  readOnly: [0, 1, 6].contains(support.type.value),
                                                                  controller: support.subjectField,
                                                                  validator: (value) {
                                                                    String? item;

                                                                    if (value == null || value.isEmpty) item = 'Введите тему';

                                                                    return item;
                                                                  },
                                                                  decoration: decorationInput(hint: 'Тема*', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                  textInputAction: TextInputAction.next
                                                              ),
                                                              h(16),
                                                              TextFormField(
                                                                  cursorHeight: 15,
                                                                  controller: support.textField,
                                                                  maxLines: support.type.value == 6 ? 5 : 3,
                                                                  validator: (value) {
                                                                    String? item;

                                                                    if (support.type.value != null && (value == null || value.isEmpty)) item = 'Введите текст';

                                                                    return item;
                                                                  },
                                                                  decoration: decorationInput(hint: 'Текст*', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                  textInputAction: TextInputAction.done
                                                              )
                                                            ]
                                                        )
                                                    ),
                                                    h(16),
                                                    GestureDetector(
                                                        onTap: support.pickFile,
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(image: AssetImage('assets/image/dotted.png'), fit: BoxFit.fill)
                                                            ),
                                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                            width: double.infinity,
                                                            alignment: Alignment.center,
                                                            child: Column(
                                                                children: [
                                                                  support.file.value != null ? Icon(Icons.check, color: Colors.green) : Image.asset('assets/icon/download.png', width: 20),
                                                                  h(4),
                                                                  Text(
                                                                      support.file.value != null ? 'Файл загружен' : 'Загрузить файл',
                                                                      style: TextStyle(
                                                                          color: Color(0xFF8A95A8),
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                    ),
                                                    h(16),
                                                    Row(
                                                        children: [
                                                          Checkbox(
                                                              value: support.isAgree.value,
                                                              overlayColor: WidgetStatePropertyAll(primaryColor),
                                                              side: BorderSide(color: primaryColor, width: 2),
                                                              checkColor: Colors.white,
                                                              activeColor: primaryColor,
                                                              visualDensity: VisualDensity.compact,
                                                              onChanged: (bool? value) {
                                                                support.isAgree.value = value ?? false;
                                                              }
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
                                                                                    support.webPersonalController ??= WebViewController()
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
                                                                                                                    Expanded(child: WebViewWidget(controller: support.webPersonalController!))
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
                                                                                    support.webPersonalController ??= WebViewController()
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
                                                                                                                    Expanded(child: WebViewWidget(controller: support.webPersonalController!))
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
                                                    h(16),
                                                    PrimaryButton(text: 'Задать вопрос', onPressed: support.send, height: 40),
                                                    h(32),
                                                    if (support.contact.value != null) ModuleTitle(title: 'Мы на карте', type: true),
                                                    if (support.contact.value != null) Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(12)
                                                        ),
                                                        clipBehavior: Clip.antiAlias,
                                                        height: 200,
                                                        width: double.infinity,
                                                        child: YandexMap(
                                                            onMapCreated: (c) async {
                                                              support.map.value = c;

                                                              c.moveCamera(
                                                                  CameraUpdate.newCameraPosition(
                                                                      CameraPosition(
                                                                          target: support.contact.value?.map.center ?? const Point(latitude: 55.853593, longitude: 37.501265),
                                                                          zoom: 10
                                                                      )
                                                                  )
                                                              );
                                                            },
                                                            mapObjects: List.generate(support.contact.value!.map.mark.length, (index) {
                                                              final item = support.contact.value!.map.mark[index];

                                                              return PlacemarkMapObject(
                                                                  mapId: MapObjectId('pvz_$index'),
                                                                  point: item.coordinates,
                                                                  icon: PlacemarkIcon.single(
                                                                      PlacemarkIconStyle(
                                                                          image: BitmapDescriptor.fromAssetImage('assets/icon/map.png')
                                                                      )
                                                                  )
                                                              );
                                                            }).toList()
                                                        )
                                                    ),
                                                    if (support.contact.value != null) h(20),
                                                    if (support.contact.value != null) Wrap(
                                                        runSpacing: 16,
                                                        children: support.contact.value!.contacts.map((item) => GestureDetector(
                                                            child: Container(
                                                                width: double.infinity,
                                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                                                decoration: ShapeDecoration(
                                                                    color: Color(0x4CF0F0F0),
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                                                                        borderRadius: BorderRadius.circular(6)
                                                                    )
                                                                ),
                                                                child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                          item.title,
                                                                          style: TextStyle(
                                                                              color: Color(0xFF1E1E1E),
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w700,
                                                                              height: 1.40
                                                                          )
                                                                      ),
                                                                      h(24),
                                                                      Html(
                                                                          data: item.info.trim(),
                                                                          extensions: [
                                                                            IframeHtmlExtension()
                                                                          ],
                                                                          style: {
                                                                            '*': Style(
                                                                                margin: Margins.all(0),
                                                                                padding: HtmlPaddings.zero
                                                                            )
                                                                          },
                                                                          onLinkTap: (val, map, element) {
                                                                            if ((val ?? '').isNotEmpty) {
                                                                              Helper.openLink(val!);
                                                                            }
                                                                          }
                                                                      )
                                                                    ]
                                                                )
                                                            )
                                                        )).toList()
                                                    ),
                                                    h(20),
                                                    PrimaryButton(text: 'Вернуться на главную', height: 40, background: Colors.white, borderColor: primaryColor, borderWidth: 2, textStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w700), onPressed: () {
                                                      controller.onItemTapped(0);
                                                      Get.back();
                                                      Get.back();
                                                    }),
                                                    h(20 + MediaQuery.of(context).padding.bottom)
                                                  ]
                                              )
                                          )
                                        ]
                                    )
                                ),
                                SearchWidget()
                              ]
                          )
                      ),
                      if (!support.isLoading.value) Center(child: CircularProgressIndicator(color: primaryColor))
                    ]
                )
            )
        ))
    );
  }
}