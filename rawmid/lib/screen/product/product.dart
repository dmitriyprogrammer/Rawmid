import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:rawmid/model/product/question.dart';
import 'package:rawmid/screen/product/zap.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:rawmid/widget/module_title.dart';
import 'package:rawmid/widget/primary_button.dart';
import 'package:rawmid/widget/product_card.dart';
import 'package:rawmid/widget/tooltip.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../controller/product.dart';
import '../../model/product/review.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';
import '../../widget/nav_menu.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../../widget/video.dart';
import '../../widget/w.dart';
import '../home/city.dart';
import '../home/news.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        init: ProductController(id),
        builder: (controller) => Scaffold(
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
                        if (controller.navController.city.value.isNotEmpty) w(10),
                        if (controller.navController.city.value.isNotEmpty) Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  final city = controller.navController.city.value;

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
                                  ).then((_) {
                                    controller.navController.filteredCities.value = controller.navController.cities;
                                    controller.navController.filteredLocation.clear();
                                    if (city == controller.navController.city.value) return;
                                    controller.initialize();
                                    controller.update();
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
                                                  controller.navController.city.value,
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
            backgroundColor: Colors.white,
            body: Obx(() => SafeArea(
              bottom: false,
              child: controller.isLoading.value ? Stack(
                children: [
                  SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 60 + MediaQuery.of(context).padding.bottom),
                      child: Stack(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                h(8),
                                SearchBarView(),
                                h(20),
                                Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                          controller.product.value!.name,
                                          style: TextStyle(
                                              color: Color(0xFF1E1E1E),
                                              fontSize: 21,
                                              fontWeight: FontWeight.w600
                                          )
                                      ),
                                      h(16),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Text(
                                                    'Артикул товара: ${controller.product.value!.sku}',
                                                    style: TextStyle(
                                                        color: Color(0xFF8A95A8),
                                                        fontSize: 13
                                                    )
                                                )
                                            ),
                                            Flexible(
                                                child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                    decoration: ShapeDecoration(
                                                        color: controller.product.value!.status.contains('редзаказ') || controller.product.value!.quantity <= 0 ? Color(0x1903A34B) : Color(0xFFEBF3F6),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                                                    ),
                                                    child: Text(
                                                        controller.product.value!.status.contains('редзаказ') || controller.product.value!.quantity <= 0 ? 'Предзаказ' : controller.product.value!.status,
                                                        style: TextStyle(
                                                            color: controller.product.value!.status.contains('редзаказ') || controller.product.value!.quantity <= 0 ? Color(0xFF03A34B) : Color(0xFF0D80D9),
                                                            fontSize: 14
                                                        )
                                                    )
                                                )
                                            )
                                          ]
                                      ),
                                      h(22),
                                      _imageCard(controller),
                                      if (controller.product.value!.hdd.isNotEmpty) h(20),
                                      if (controller.product.value!.hdd.isNotEmpty) Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: primaryColor),
                                          borderRadius: BorderRadius.circular(12),
                                          color: primaryColor.withOpacityX(0.2)
                                        ),
                                        padding: EdgeInsets.all(8),
                                        alignment: Alignment.center,
                                        child: Row(
                                          spacing: 4,
                                          children: [
                                            Icon(Icons.info, color: dangerColor, size: 30),
                                            Expanded(
                                              child: Html(
                                                  data: controller.product.value!.hdd,
                                                  extensions: [
                                                    IframeHtmlExtension()
                                                  ],
                                                  style: {
                                                    '*': Style(
                                                        margin: Margins.all(0),
                                                        padding: HtmlPaddings.zero,
                                                        textAlign: TextAlign.center
                                                    )
                                                  },
                                                  onLinkTap: (val, map, element) {
                                                    if ((val ?? '').isNotEmpty) {
                                                      Helper.openLink(val!);
                                                    }
                                                  }
                                              )
                                            )
                                          ]
                                        )
                                      ),
                                      if (controller.product.value!.hdd.isNotEmpty) h(20),
                                      if (controller.webController != null) PrimaryButton(text: 'Описание товара', height: 40, onPressed: () {
                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                opaque: false,
                                                pageBuilder: (context, animation, secondaryAnimation) {
                                                  return Scaffold(
                                                      backgroundColor: Colors.black.withOpacityX(0.5),
                                                      body: SafeArea(
                                                          child: Stack(
                                                              children: [
                                                                Positioned(
                                                                    top: 10,
                                                                    right: 0,
                                                                    child: IconButton(
                                                                        onPressed: Get.back,
                                                                        icon: Icon(Icons.close, size: 24, color: Colors.white)
                                                                    )
                                                                ),
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        borderRadius: BorderRadius.circular(20)
                                                                    ),
                                                                    height: Get.height * 0.8,
                                                                    clipBehavior: Clip.antiAlias,
                                                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                    margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40, left: 20, right: 20),
                                                                    child: WebViewWidget(controller: controller.webController!)
                                                                )
                                                              ]
                                                          )
                                                      )
                                                  );
                                                },
                                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                  return SlideTransition(
                                                      position: Tween<Offset>(
                                                        begin: const Offset(0, 1),
                                                        end: Offset.zero,
                                                      ).animate(animation),
                                                      child: child
                                                  );
                                                }
                                            )
                                        );
                                      }),
                                      if (controller.product.value!.schema.isNotEmpty || controller.product.value!.childProducts.where((e) => e.color.isNotEmpty).isNotEmpty) Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            h(32),
                                            if (controller.product.value!.childProducts.where((e) => e.color.isNotEmpty).isNotEmpty) Text(
                                                'Доступные варианты',
                                                style: TextStyle(
                                                    color: Color(0xFF1E1E1E),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700
                                                )
                                            ),
                                            h(16),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  if (controller.product.value!.childProducts.where((e) => e.color.isNotEmpty).isNotEmpty) Flexible(
                                                      child: Wrap(
                                                          runSpacing: 8,
                                                          spacing: 8,
                                                          children: List.generate(controller.product.value!.childProducts.length, (index) {
                                                            final child = controller.product.value!.childProducts[index];

                                                            return GestureDetector(
                                                                onTap: () => controller.selectChild.value = child.id,
                                                                child: SizedBox(
                                                                  width: 70,
                                                                  child: Column(
                                                                      children: [
                                                                        Container(
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                color: controller.selectChild.value == child.id || controller.selectChild.isEmpty && index == 0 ? primaryColor : Colors.grey
                                                                            ),
                                                                            clipBehavior: Clip.antiAlias,
                                                                            padding: EdgeInsets.all(3),
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(4),
                                                                                child: CachedNetworkImage(
                                                                                    imageUrl: child.image,
                                                                                    errorWidget: (c, e, i) {
                                                                                      return Image.asset('assets/image/no_image.png');
                                                                                    },
                                                                                    height: 40,
                                                                                    width: 40,
                                                                                    fit: BoxFit.cover
                                                                                )
                                                                            )
                                                                        ),
                                                                        h(4),
                                                                        Text(
                                                                            child.color,
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                                color: Color(0xFF8A95A8),
                                                                                height: 1.1,
                                                                                fontSize: 11
                                                                            )
                                                                        )
                                                                      ]
                                                                  )
                                                                )
                                                            );
                                                          })
                                                      )
                                                  ),
                                                  if (controller.product.value!.schema.isNotEmpty) Flexible(
                                                      child: SizedBox(
                                                          width: 106,
                                                          child: InkWell(
                                                              onTap: () {
                                                                showModalBottomSheet(
                                                                    context: Get.context!,
                                                                    isScrollControlled: true,
                                                                    useSafeArea: true,
                                                                    useRootNavigator: true,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                                    ),
                                                                    builder: (context) {
                                                                      return _openZap(controller);
                                                                    }
                                                                );
                                                              },
                                                              child: Text(
                                                                  'Схема товара',
                                                                  style: TextStyle(
                                                                      color: Color(0xFF14BFFF),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w700,
                                                                      decoration: TextDecoration.underline,
                                                                      decorationColor: Color(0xFF14BFFF),
                                                                      height: 1.30
                                                                  )
                                                              )
                                                          )
                                                      )
                                                  )
                                                ]
                                            )
                                          ]
                                      ),
                                      h(32),
                                      if (controller.product.value!.attributes.isNotEmpty) _attributes(controller),
                                      h(30),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (controller.childProducts.isNotEmpty) Expanded(
                                                child: PrimaryButton(text: 'Уцененные товары', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: controller.scrollToUc)
                                            ),
                                            if (controller.childProducts.isNotEmpty) w(10),
                                            Expanded(
                                                child: PrimaryButton(text: 'Поторговаться', height: 40, onPressed: () {
                                                  showModalBottomSheet(
                                                      context: Get.context!,
                                                      isScrollControlled: true,
                                                      useSafeArea: true,
                                                      useRootNavigator: true,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                      ),
                                                      builder: (context) {
                                                        return _openX(controller);
                                                      }
                                                  );
                                                })
                                            )
                                          ]
                                      ),
                                      h(30),
                                      if (controller.time.value.inSeconds > 0) Text('До окончания акции:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                      if (controller.time.value.inSeconds > 0) h(10),
                                      if (controller.time.value.inSeconds > 0) _buildTimerBox(controller),
                                      if (controller.time.value.inSeconds > 0) h(20),
                                      if (controller.time.value.inSeconds > 0) PrimaryButton(text: 'Посмотреть все акции', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () => Get.toNamed('/specials')),
                                      if (controller.reviews.isNotEmpty) _buildReviews(controller),
                                      if (controller.product.value?.chain?.products != null) _buildChains(controller),
                                      if (controller.childProducts.isNotEmpty) _buildChilds(controller),
                                      if (controller.accessories.isNotEmpty) _buildAccessories(controller),
                                      if (controller.video.isNotEmpty) _buildVideo(controller),
                                      if (controller.questions.isNotEmpty) _buildQuestion(controller),
                                      if (controller.recipes.isNotEmpty) NewsSection(news: controller.recipes, title: 'Рецепты', recipe: true),
                                      if (controller.surveys.isNotEmpty) NewsSection(news: controller.surveys, title: 'Обзоры'),
                                      if (controller.rec.isNotEmpty) NewsSection(news: controller.rec, title: 'Советы'),
                                      if (controller.questions.isNotEmpty) h(20),
                                      if (controller.questions.isNotEmpty) PrimaryButton(text: 'Остались вопросы к товару', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () {
                                        showModalBottomSheet(
                                            context: Get.context!,
                                            isScrollControlled: true,
                                            useSafeArea: true,
                                            useRootNavigator: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                            ),
                                            builder: (context) {
                                              return _openQuestion(controller);
                                            }
                                        );
                                      }),
                                      h(30)
                                    ]
                                  )
                                )
                              ]
                          ),
                          SearchWidget()
                        ]
                      )
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)
                          ),
                          border: Border(
                            left: BorderSide(color: Color(0xFFDDE8EA)),
                            top: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                            right: BorderSide(color: Color(0xFFDDE8EA)),
                            bottom: BorderSide(color: Color(0xFFDDE8EA))
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            controller.product.value!.special.isNotEmpty ? controller.product.value!.special : controller.product.value!.price,
                                            style: TextStyle(
                                                color: Color(0xFF1E1E1E),
                                                fontSize: 20,
                                                fontFamily: 'Roboto',
                                                height: 1,
                                                fontWeight: FontWeight.w700
                                            )
                                        ),
                                        if (controller.product.value!.special.isNotEmpty) Text(
                                            'Вместо ${controller.product.value!.price}',
                                            style: TextStyle(
                                                color: Color(0xFF0D80D9),
                                                fontSize: 11,
                                                fontFamily: 'Roboto'
                                            )
                                        )
                                      ]
                                  ),
                                  w(15),
                                  Expanded(
                                      child: Row(
                                          children: [
                                            Expanded(
                                                child: PrimaryButton(text: controller.navController.isCart(controller.selectChild.isNotEmpty && controller.product.value!.childProducts.where((e) => e.color.isNotEmpty).isNotEmpty ? controller.selectChild.value : id, k: true) ? 'В корзине' : 'В рассрочку', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () async {
                                                  String idNew = id;

                                                  if (controller.product.value?.isZap ?? false) {
                                                    sernumPop(controller, idNew);
                                                    return;
                                                  }

                                                  if (controller.selectChild.isNotEmpty && controller.product.value!.childProducts.where((e) => e.color.isNotEmpty).isNotEmpty) {
                                                    idNew = controller.selectChild.value;
                                                  }

                                                  await controller.navController.addCart(idNew, k: true);
                                                })
                                            ),
                                            w(10),
                                            Expanded(
                                                child: PrimaryButton(text: controller.navController.isCart(controller.selectChild.isNotEmpty && controller.product.value!.childProducts.where((e) => e.color.isNotEmpty).isNotEmpty ? controller.selectChild.value : id, k: false) ? 'В корзине' : controller.product.value!.status.contains('редзаказ') || controller.product.value!.quantity <= 0 ? 'Предзаказ' : 'Купить', height: 40, onPressed: () async {
                                                  String idNew = id;

                                                  if (controller.product.value?.isZap ?? false) {
                                                    sernumPop(controller, idNew);
                                                    return;
                                                  }

                                                  if (controller.selectChild.isNotEmpty && controller.product.value!.childProducts.where((e) => e.color.isNotEmpty).isNotEmpty) {
                                                    idNew = controller.selectChild.value;
                                                  }

                                                  await controller.navController.addCart(idNew);
                                                })
                                            )
                                          ]
                                      )
                                  )
                                ]
                            ),
                            h(6),
                            PrimaryButton(height: 42, loader: true, onPressed: () async {
                              String idNew = id;

                              if (controller.selectChild.isNotEmpty && controller.product.value!.childProducts.where((e) => e.color.isNotEmpty).isNotEmpty) {
                                idNew = controller.selectChild.value;
                              }

                              await controller.yPay(idNew);
                            }, child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                Text(
                                  'Оплатить с',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600
                                  )
                                ),
                                Image.asset('assets/icon/yandex_pay.png', width: 40)
                              ]
                            )),
                            if ((controller.product.value?.allowCredit ?? false) || (controller.product.value?.allowCreditKz ?? false)) h(6),
                            if (controller.product.value?.allowCredit ?? false) Row(
                              children: [
                                Expanded(
                                    child: Row(
                                        spacing: 8,
                                        children: [
                                          Image.asset('assets/icon/tb.png', width: 24),
                                          Text(
                                              controller.product.value?.textKvcproPeriod ?? '',
                                              style: TextStyle(
                                                  color: const Color(0xFF1E1E1E),
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500
                                              )
                                          ),
                                          Text(
                                              '${(controller.product.value?.kvcproPrice ?? 0).ceil()} ₽/мес ',
                                              style: TextStyle(
                                                  color: const Color(0xFF0D80D9),
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500
                                              )
                                          )
                                        ]
                                    )
                                ),
                                Expanded(
                                    child: Row(
                                        spacing: 8,
                                        children: [
                                          Image.asset('assets/icon/sb.png', width: 24),
                                          Text(
                                              '9 мес.',
                                              style: TextStyle(
                                                  color: const Color(0xFF1E1E1E),
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500
                                              )
                                          ),
                                          Text(
                                              '${(controller.product.value?.sbcreditPrice ?? 0).ceil()} ₽/мес ',
                                              style: TextStyle(
                                                  color: const Color(0xFF0D80D9),
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500
                                              )
                                          ),
                                        ]
                                    )
                                )
                              ]
                            ),
                            if (controller.product.value?.allowCreditKz ?? false) Row(
                              children: [
                                Expanded(
                                    child: Row(
                                        spacing: 8,
                                        children: [
                                          Image.asset('assets/icon/k1.png', width: 24),
                                          Text(
                                              '4 мес.',
                                              style: TextStyle(
                                                  color: const Color(0xFF1E1E1E),
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500
                                              )
                                          ),
                                          Text(
                                              '${((double.tryParse('${controller.product.value?.price.replaceAll(RegExp(r'\D'), '').replaceAll('.0', '') ?? 0}') ?? 0) / 4).ceil()} ₸/мес',
                                              style: TextStyle(
                                                  color: const Color(0xFF0D80D9),
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500
                                              )
                                          ),
                                        ]
                                    )
                                ),
                                Expanded(
                                    child: Row(
                                        spacing: 8,
                                        children: [
                                          Image.asset('assets/icon/k2.png', width: 24),
                                          Text(
                                              '24 мес.',
                                              style: TextStyle(
                                                  color: const Color(0xFF1E1E1E),
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500
                                              )
                                          ),
                                          Text(
                                              '${((double.tryParse('${controller.product.value?.price.replaceAll(RegExp(r'\D'), '').replaceAll('.0', '') ?? 0}') ?? 0) / 24).ceil()} ₸/мес',
                                              style: TextStyle(
                                                  color: const Color(0xFF0D80D9),
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500
                                              )
                                          ),
                                        ]
                                    )
                                )
                              ]
                            )
                          ]
                        )
                    )
                  )
                ],
              ) : Center(
                child: CircularProgressIndicator(color: primaryColor)
              )
            )),
            bottomNavigationBar: NavMenuView(nav: true)
        )
    );
  }

  Widget _openX(ProductController controller) {
    final product = controller.product.value!;
    final focus = FocusNode();

    return Padding(
        padding: EdgeInsets.only(
            left: 16, right: 16, top: 20, bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20
        ),
        child: Form(
            key: controller.formKey4,
            child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Хотите дешевле?',
                      style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      )
                  ),
                  h(16),
                  Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                                imageUrl: product.image,
                                errorWidget: (c, e, i) {
                                  return Image.asset('assets/image/no_image.png');
                                },
                                height: 64,
                                width: 64,
                                fit: BoxFit.cover
                            )
                        ),
                        w(12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      product.name,
                                      style: TextStyle(
                                          color: Color(0xFF1E1E1E),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700
                                      )
                                  ),
                                  if (product.color.isNotEmpty) Text(
                                      'Цвет: ${product.color}',
                                      style: TextStyle(
                                          color: Color(0xFF8A95A8),
                                          fontSize: 10
                                      )
                                  )
                                ]
                            )
                        ),
                        w(12),
                        Text(
                            product.special.isNotEmpty ? product.special : product.price,
                            style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 18,
                                fontWeight: FontWeight.w700
                            )
                        )
                      ]
                  ),
                  h(20),
                  Stack(
                    children: [
                      TextFormField(
                          controller: controller.priceField,
                          focusNode: focus,
                          cursorHeight: 15,
                          decoration: decorationInput(hint: 'Ваша цена', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (val) => controller.setSale(0),
                          validator: (val) {
                            if ((val ?? '').isEmpty) {
                              return 'Напишите вашу цену';
                            }

                            return null;
                          }
                      ),
                      if (controller.saleTransition.value > 0) Positioned(
                        left: 16,
                        top: 13,
                        child: Obx(() => GestureDetector(
                          onTap: () {
                            controller.saleTransition.value = 0;
                            focus.requestFocus();
                          },
                          child: Container(
                              color: Colors.white,
                              width: 100,
                              height: 20,
                              child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: controller.saleTransition.value, end: controller.saleTransitionEnd.value),
                                  duration: Duration(milliseconds: 500),
                                  builder: (context, value, child) {
                                    String currencySymbol = controller.product.value!.price.replaceAll(RegExp(r'[\d\s]+'), '').trim();

                                    return Text(
                                        Helper.formatPrice(value, symbol: currencySymbol),
                                        style: TextStyle(color: firstColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)
                                    );
                                  }
                              )
                          )
                        ))
                      )
                    ]
                  ),
                  h(10),
                  Obx(() => Row(
                      children: [
                        GestureDetector(
                            onTap: () => controller.setSale(3),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: controller.sale.value == 3 ? primaryColor : Colors.grey
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: Text('-3%', style: TextStyle(color: Colors.white))
                            )
                        ),
                        w(8),
                        GestureDetector(
                            onTap: () => controller.setSale(5),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: controller.sale.value == 5 ? primaryColor : Colors.grey
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: Text('-5%', style: TextStyle(color: Colors.white))
                            )
                        ),
                        w(8),
                        GestureDetector(
                            onTap: () => controller.setSale(8),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: controller.sale.value == 8 ? primaryColor : Colors.grey
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: Text('-8%', style: TextStyle(color: Colors.white))
                            )
                        ),
                        w(8),
                        GestureDetector(
                            onTap: () => controller.setSale(10),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: controller.sale.value == 10 ? primaryColor : Colors.grey
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: Text('-10%', style: TextStyle(color: Colors.white))
                            )
                        )
                      ]
                  )),
                  h(20),
                  TextFormField(
                      controller: controller.fioXField,
                      cursorHeight: 15,
                      decoration: decorationInput(hint: 'Имя', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите ваше ФИО';
                        }

                        return null;
                      }
                  ),
                  h(10),
                  TextFormField(
                      cursorHeight: 15,
                      controller: controller.emailXField,
                      decoration: decorationInput(error: controller.emailValidate.value ? dangerColor : null, hint: 'E-mail', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: controller.validateEmailX,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите E-mail';
                        } else if ((val ?? '').isNotEmpty && !EmailValidator.validate(val!)) {
                          return 'E-mail заполнен некорректно';
                        }

                        return null;
                      }
                  ),
                  if (controller.navController.user.value == null && controller.emailValidate.value) Padding(
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
                  h(10),
                  TextFormField(
                      controller: controller.textXField,
                      decoration: decorationInput(hint: 'Обоснование для получения скидки', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 3,
                      cursorHeight: 15,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите текст';
                        }

                        return null;
                      }
                  ),
                  h(20),
                  PrimaryButton(text: 'Отправить заявку', loader: true, height: 50, onPressed: controller.addX),
                  h(10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Отправляя запрос, Я соглашаюсь с условиями ',
                          style: TextStyle(
                            color: Color(0xFF8A95A8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {
                            Get.back();

                            showAdaptiveDialog(
                                context: Get.context!,
                                useRootNavigator: true,
                                useSafeArea: true,
                                builder: (c) {
                                  controller.webPersonalController ??= WebViewController()
                                      ..setJavaScriptMode(
                                          JavaScriptMode.unrestricted)
                                      ..loadRequest(Uri.parse(personalDataUrl));

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
                          text: 'обработки персональных данных',
                          style: TextStyle(
                            color: Color(0xFF14BFFF),
                            fontSize: 11,
                            fontWeight: FontWeight.w500
                          )
                        )
                      ]
                    ),
                    textAlign: TextAlign.center
                  ),
                  h(20)
                ]
            ))
        )
    );
  }

  Widget _openComments(ProductController controller, ReviewModel review) {
    return SizedBox(
      height: Get.height * 0.8,
      child: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: 16, right: 16, top: 40, bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    review.author,
                                    style: TextStyle(
                                        color: Color(0xFF1E1E1E),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                    )
                                ),
                                h(10),
                                if (review.rating > 0) Row(
                                    children: [
                                      Row(
                                          children: [1,2,3,4,5].map((e) => Icon(e <= review.rating ? Icons.star : Icons.star_half, color: Colors.amber, size: 16)).toList()
                                      ),
                                      w(5),
                                      Text(
                                          '${review.rating}',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)
                                      )
                                    ]
                                )
                              ]
                          )
                      ),
                      if (review.date != null) Text(
                          controller.formatDateCustom(review.date!),
                          style: TextStyle(
                              color: Color(0xFF8A95A8),
                              fontSize: 11
                          )
                      )
                    ]
                ),
                h(16),
                Text(
                    review.text,
                    style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 14,
                        height: 1.40
                    )
                ),
                h(32),
                if (review.comments.isNotEmpty) Wrap(
                    runSpacing: 12,
                    children: List.generate(review.comments.length, (index) {
                      final item = review.comments[index];

                      return !item.parent ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: ShapeDecoration(
                              color: Color(0x4CF0F0F0),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                                  borderRadius: BorderRadius.circular(6)
                              )
                          ),
                          child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Row(
                                              children: [
                                                Image.asset('assets/icon/chat.png', width: 16),
                                                w(6),
                                                Text(
                                                    item.author,
                                                    style: TextStyle(
                                                        color: Color(0xFF1E1E1E),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600
                                                    )
                                                )
                                              ]
                                          )
                                      ),
                                      if (item.date != null) Text(
                                          controller.formatDateCustom(item.date!),
                                          style: TextStyle(
                                              color: Color(0xFF8A95A8),
                                              fontSize: 11
                                          )
                                      )
                                    ]
                                ),
                                h(16),
                                Text(
                                    item.text,
                                    style: TextStyle(
                                        color: Color(0xFF1E1E1E),
                                        fontSize: 14,
                                        height: 1.40
                                    )
                                )
                              ]
                          )
                      ) : Text(
                          item.text,
                          style: TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 14,
                              height: 1.40
                          )
                      );
                    })
                ),
                h(20),
                PrimaryButton(text: 'Оставить комментарий', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () {
                  controller.isComment.value = review.id;
                  Get.back();

                  showModalBottomSheet(
                      context: Get.context!,
                      isScrollControlled: true,
                      useSafeArea: true,
                      useRootNavigator: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                      ),
                      builder: (context) {
                        return _openReview(controller);
                      }
                  );
                }),
                h(20)
              ]
          )
      )
    );
  }

  Widget _openReview(ProductController controller) {
    final product = controller.product.value!;

    return Padding(
        padding: EdgeInsets.only(
            left: 16, right: 16, top: 20, bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20
        ),
        child: Form(
            key: controller.formKey3,
            child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      controller.isComment.isNotEmpty || controller.isQuestionComment.isNotEmpty ? 'Оставьте комментарий' : 'Оставьте отзыв',
                      style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      )
                  ),
                  if (controller.isComment.isEmpty && controller.isQuestionComment.isEmpty || controller.isQuestionComment.isEmpty && controller.isComment.isEmpty) h(16),
                  if (controller.isComment.isEmpty && controller.isQuestionComment.isEmpty || controller.isQuestionComment.isEmpty && controller.isComment.isEmpty) Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                                imageUrl: product.image,
                                errorWidget: (c, e, i) {
                                  return Image.asset('assets/image/no_image.png');
                                },
                                height: 64,
                                width: 64,
                                fit: BoxFit.cover
                            )
                        ),
                        w(12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      product.name,
                                      style: TextStyle(
                                          color: Color(0xFF1E1E1E),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700
                                      )
                                  ),
                                  if (product.color.isNotEmpty) Text(
                                      'Цвет: ${product.color}',
                                      style: TextStyle(
                                          color: Color(0xFF8A95A8),
                                          fontSize: 12
                                      )
                                  )
                                ]
                            )
                        ),
                        w(12),
                        Text(
                            product.special.isNotEmpty ? product.special : product.price,
                            style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 18,
                                fontWeight: FontWeight.w700
                            )
                        )
                      ]
                  ),
                  if (controller.isComment.isEmpty) h(20),
                  if (controller.isComment.isEmpty) Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(Icons.star, color: index < controller.rating.value ? Colors.amber : Color(0x4CFFCC00), size: 40),
                          onPressed: () => controller.rating.value = index+1,
                          padding: EdgeInsets.zero,
                        );
                      })
                  ),
                  h(20),
                  TextFormField(
                      cursorHeight: 15,
                      controller: controller.fioReviewField,
                      decoration: decorationInput(hint: 'Имя', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите ваше ФИО';
                        }

                        return null;
                      }
                  ),
                  h(10),
                  if (controller.navController.user.value == null) TextFormField(
                      controller: controller.emailReviewField,
                      cursorHeight: 15,
                      decoration: decorationInput(error: controller.emailValidate.value ? dangerColor : null, hint: 'E-mail', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: controller.validateEmailX,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите E-mail';
                        } else if ((val ?? '').isNotEmpty && !EmailValidator.validate(val!)) {
                          return 'E-mail заполнен некорректно';
                        }

                        return null;
                      }
                  ),
                  if (controller.navController.user.value == null && controller.emailValidate.value) Padding(
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
                  if (controller.navController.user.value == null) h(10),
                  TextFormField(
                      controller: controller.textReviewField,
                      decoration: decorationInput(hint: 'Текст', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 3,
                      cursorHeight: 15,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите ваш отзыв';
                        }

                        return null;
                      }
                  ),
                  h(12),
                  Row(
                      children: [
                        Checkbox(
                            value: controller.isAgree.value,
                            overlayColor: WidgetStatePropertyAll(primaryColor),
                            side: BorderSide(color: primaryColor, width: 2),
                            checkColor: Colors.white,
                            activeColor: primaryColor,
                            visualDensity: VisualDensity.compact,
                            onChanged: (bool? value) {
                              controller.isAgree.value = value ?? false;
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
                  h(20),
                  PrimaryButton(text: controller.isComment.isNotEmpty || controller.isQuestionComment.isNotEmpty ? 'Отправить комментарий' : 'Опубликовать отзыв', loader: true, height: 50, onPressed: controller.addReview),
                  h(20)
                ]
            ))
        )
    );
  }

  Widget _openQuestion(ProductController controller) {
    return Padding(
        padding: EdgeInsets.only(
            left: 16, right: 16, top: 20, bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20
        ),
        child: Form(
            key: controller.formKey2,
            child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Нужна помощь?',
                      style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      )
                  ),
                  h(12),
                  Text(
                      'Для получения помощи заполните форму ниже.',
                      style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 14
                      )
                  ),
                  h(20),
                  TextFormField(
                      controller: controller.fioField,
                      cursorHeight: 15,
                      decoration: decorationInput(hint: 'Ваше имя*', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите ваше ФИО';
                        }

                        return null;
                      }
                  ),
                  h(10),
                  Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                              height: 49,
                              child: PhoneFormField(
                                controller: controller.phoneField,
                                validator: PhoneValidator.compose([PhoneValidator.required(Get.context!, errorText: 'Номер телефона обязателен'), PhoneValidator.validMobile(Get.context!, errorText: 'Номер телефона некорректен')]),
                                countrySelectorNavigator: const CountrySelectorNavigator.draggableBottomSheet(),
                                isCountrySelectionEnabled: true,
                                isCountryButtonPersistent: true,
                                autofillHints: const [AutofillHints.telephoneNumber],
                                cursorHeight: 15,
                                countryButtonStyle: const CountryButtonStyle(
                                    showDialCode: true,
                                    showIsoCode: false,
                                    showFlag: true,
                                    padding: EdgeInsets.only(left: 14),
                                    showDropdownIcon: false,
                                    flagSize: 20
                                ),
                                decoration: decorationInput(contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
                              )
                            )
                        ),
                        w(10),
                        Expanded(
                            child: Column(
                                children: [
                                  TextFormField(
                                      cursorHeight: 15,
                                      controller: controller.emailField,
                                      decoration: decorationInput(error: controller.emailValidate.value ? dangerColor : null, hint: 'E-mail', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: controller.validateEmailX,
                                      validator: (val) {
                                        if ((val ?? '').isEmpty) {
                                          return 'Напишите E-mail';
                                        } else if ((val ?? '').isNotEmpty && !EmailValidator.validate(val!)) {
                                          return 'E-mail заполнен некорректно';
                                        }

                                        return null;
                                      }
                                  ),
                                  if (controller.emailValidate.value) Padding(
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
                            )
                        )
                      ]
                  ),
                  h(10),
                  TextFormField(
                      controller: controller.textField,
                      decoration: decorationInput(hint: 'Текст', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 3,
                      cursorHeight: 15,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите ваш вопрос';
                        }

                        return null;
                      }
                  ),
                  h(12),
                  Row(
                      children: [
                        Checkbox(
                            value: controller.isAgree.value,
                            overlayColor: WidgetStatePropertyAll(primaryColor),
                            side: BorderSide(color: primaryColor, width: 2),
                            checkColor: Colors.white,
                            activeColor: primaryColor,
                            visualDensity: VisualDensity.compact,
                            onChanged: (bool? value) {
                              controller.isAgree.value = value ?? false;
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
                  h(20),
                  PrimaryButton(text: 'Отправить заявку', loader: true, height: 50, onPressed: controller.addQuestionOther),
                  h(12),
                  Row(
                      children: [
                        Checkbox(
                            value: controller.isAgree.value,
                            overlayColor: WidgetStatePropertyAll(primaryColor),
                            side: BorderSide(color: primaryColor, width: 2),
                            checkColor: Colors.white,
                            activeColor: primaryColor,
                            visualDensity: VisualDensity.compact,
                            onChanged: (bool? value) {
                              controller.isAgree.value = value ?? false;
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
                  h(20)
                ]
            ))
        )
    );
  }

  Widget _buildQuestion(ProductController controller) {
    return Column(
        children: [
          h(30),
          ModuleTitle(title: 'Вопрос-ответ', type: true),
          SizedBox(
              height: controller.isQuestionChecked.value == controller.activeQuestionsIndex.value ? 122 + controller.questionHeight.value : 120,
              child: PageView.builder(
                  controller: controller.questionController,
                  itemCount: controller.product.value!.questions.length,
                  onPageChanged: (index) {
                    controller.activeQuestionsIndex.value = index;
                    final rev = controller.product.value!.questions[index];

                    if (!rev.checked) {
                      controller.questionHeight.value = 0;
                    }
                  },
                  clipBehavior: Clip.none,
                  padEnds: false,
                  itemBuilder: (context, index) {
                    return Obx(() => _buildQuestionCard(controller.product.value!.questions[index], controller, index));
                  }
              )
          ),
          h(10),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(controller.product.value!.questions.length, (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.activeQuestionsIndex.value == index ? primaryColor : Colors.blue[100]
                  )
              ))
          ),
          h(10),
          PrimaryButton(text: 'Задать вопрос', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () {
            showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                useSafeArea: true,
                useRootNavigator: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                builder: (context) {
                  return openQuestion(controller);
                }
            );
          })
        ]
    );
  }

  Widget openQuestion(ProductController controller) {
    final product = controller.product.value!;

    return Padding(
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 20, bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Задайте вопрос о товаре',
                  style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  )
              ),
              h(16),
              Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                            imageUrl: product.image,
                            errorWidget: (c, e, i) {
                              return Image.asset('assets/image/no_image.png');
                            },
                            height: 64,
                            width: 64,
                            fit: BoxFit.cover
                        )
                    ),
                    w(12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  product.name,
                                  style: TextStyle(
                                      color: Color(0xFF1E1E1E),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700
                                  )
                              ),
                              if (product.color.isNotEmpty) Text(
                                  'Цвет: ${product.color}',
                                  style: TextStyle(
                                      color: Color(0xFF8A95A8),
                                      fontSize: 12
                                  )
                              )
                            ]
                        )
                    ),
                    w(12),
                    Text(
                        product.special.isNotEmpty ? product.special : product.price,
                        style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                        )
                    )
                  ]
              ),
              h(20),
              TextFormField(
                  cursorHeight: 15,
                  controller: controller.emailField,
                  decoration: decorationInput(error: controller.emailValidate.value ? dangerColor : null, hint: 'E-mail*', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: controller.validateEmailX,
                  validator: (val) {
                    if ((val ?? '').isEmpty) {
                      return 'Напишите E-mail';
                    } else if ((val ?? '').isNotEmpty && !EmailValidator.validate(val!)) {
                      return 'E-mail заполнен некорректно';
                    }

                    return null;
                  }
              ),
              if (controller.emailValidate.value) Padding(
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
              h(20),
              TextFormField(
                  controller: controller.nameField,
                  cursorHeight: 15,
                  decoration: decorationInput(hint: 'Ваше имя*', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if ((val ?? '').isEmpty) {
                      return 'Напишите ваше ФИО';
                    }

                    return null;
                  }
              ),
              h(20),
              TextFormField(
                  controller: controller.questionField,
                  maxLines: 3,
                  cursorHeight: 15,
                  decoration: decorationInput(hint: 'Текст', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6)),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if ((val ?? '').isEmpty) {
                      return 'Напишите ваш вопрос';
                    }

                    return null;
                  }
              ),
              h(12),
              Row(
                  children: [
                    Checkbox(
                        value: controller.isAgree.value,
                        overlayColor: WidgetStatePropertyAll(primaryColor),
                        side: BorderSide(color: primaryColor, width: 2),
                        checkColor: Colors.white,
                        activeColor: primaryColor,
                        visualDensity: VisualDensity.compact,
                        onChanged: (bool? value) {
                          controller.isAgree.value = value ?? false;
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
              h(20),
              PrimaryButton(text: 'Задать вопрос', loader: true, height: 50, onPressed: controller.addQuestion),
              h(20)
            ]
        )
      )
    );
  }

  Widget _buildVideo(ProductController controller) {
    return Column(
        children: [
          h(30),
          ModuleTitle(title: 'Видео', type: true),
          SizedBox(
              height: 180,
              child: PageView.builder(
                  controller: controller.videoController,
                  itemCount: controller.video.length,
                  padEnds: false,
                  clipBehavior: Clip.none,
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        clipBehavior: Clip.antiAlias,
                        padding: const EdgeInsets.only(right: 12),
                        child: VideoPlayerPage(
                            videoUrl: controller.video[index]
                        )
                    );
                  }
              )
          )
        ]
    );
  }

  Widget _buildAccessories(ProductController controller) {
    return Column(
        children: [
          h(30),
          ModuleTitle(title: 'Аксессуары', type: true),
          SizedBox(
              height: 340,
              child: PageView.builder(
                  controller: controller.accessoriesController,
                  itemCount: controller.accessories.length,
                  padEnds: false,
                  clipBehavior: Clip.none,
                  itemBuilder: (context, index) {
                    return Obx(() => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ProductCard(product: controller.accessories[index], addWishlist: () => controller.addWishlist(controller.accessories[index].id), buy: () async {
                          await controller.navController.addCart(controller.accessories[index].id);
                        }, margin: false)
                    ));
                  }
              )
          )
        ]
    );
  }

  Widget _buildChilds(ProductController controller) {
    return Column(
        key: controller.ucKey,
        children: [
          h(30),
          ModuleTitle(title: 'Уцененные товары', type: true),
          SizedBox(
              height: 428,
              child: ValueListenableBuilder<int>(
                  valueListenable: Helper.trigger,
                  builder: (context, items, child) => PageView.builder(
                      controller: controller.childController,
                      itemCount: controller.childProducts.length,
                      padEnds: false,
                      clipBehavior: Clip.none,
                      itemBuilder: (context, index) {
                        return Obx(() => Padding(
                            padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                            child: ProductCard(product: controller.childProducts[index], addWishlist: () => controller.addWishlist(controller.childProducts[index].id), buy: () async {
                              await controller.navController.addCart(controller.childProducts[index].id);
                            }, margin: false)
                        ));
                      }
                  )
              )
          )
        ]
    );
  }

  Widget _buildChains(ProductController controller) {
    final keys = controller.product.value!.chain!.products!.keys.toList();

    return Column(
      children: [
        ModuleTitle(title: 'Специальное предложение', type: true),
        SizedBox(
            height: 234,
            child: PageView.builder(
                controller: controller.chainController,
                itemCount: keys.length,
                padEnds: false,
                clipBehavior: Clip.none,
                itemBuilder: (context, index) {
                  final key = keys[index];
                  final items = controller.product.value!.chain!.products![key];

                  return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        color: Color(0xFFF6F8F9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      margin: const EdgeInsets.only(right: 8),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Комплект ${index + 1}',
                            style: TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 16
                            )
                        ),
                        h(8),
                        Row(
                          children: items!.map((product) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                    imageUrl: product.image,
                                    errorWidget: (c, e, i) {
                                      return Image.asset('assets/image/no_image.png');
                                    },
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover
                                )
                              )
                            );
                          }).toList()
                        ),
                        h(8),
                        Text(
                            items.map((e) => e.name).join(' + '),
                            style: TextStyle(
                                color: Color(0xFF8A95A8),
                                fontSize: 11,
                                height: 1.2
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis
                        ),
                        h(8),
                        Row(
                          children: [
                            FittedBox(
                                child: Text(
                                    controller.product.value?.chain?.totalPrice?[key] ?? '',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                )
                            ),
                            w(10),
                            FittedBox(
                                child: Text(
                                    controller.product.value?.chain?.totalPrev?[key] ?? '',
                                    style: TextStyle(fontSize: 14, color: primaryColor, decoration: TextDecoration.lineThrough)
                                )
                            )
                          ]
                        ),
                        Spacer(),
                        PrimaryButton(text: controller.chainAdd.contains(key) ? 'В корзине' : 'Купить', loader: true, onPressed: () => controller.addChainCart(key), height: 40)
                      ]
                    )
                  );
                }
            )
        )
      ]
    );
  }

  Widget _buildReviews(ProductController controller) {
    return Column(
      children: [
        h(30),
        ModuleTitle(title: 'Отзывы', type: true),
        SizedBox(
          height: controller.isChecked.value == controller.activeReviewsIndex.value ? 215 + controller.revHeight.value : 180,
          child: PageView.builder(
            controller: controller.reviewsController,
            itemCount: controller.reviews.length,
            onPageChanged: (index) {
              controller.activeReviewsIndex.value = index;
              final rev = controller.reviews[index];

              if (!rev.checked) {
                controller.revHeight.value = 0;
              }
            },
            clipBehavior: Clip.none,
            padEnds: false,
            itemBuilder: (context, index) {
              return Obx(() => _buildReviewCard(controller.reviews[index], controller, index));
            }
          )
        ),
        h(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(controller.reviews.length, (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.activeReviewsIndex.value == index ? primaryColor : Colors.blue[100]
              )
            )
          )
        ),
        h(10),
        PrimaryButton(text: 'Оставить отзыв', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () {
          controller.isComment.value = '';
          controller.isQuestionComment.value = '';

          showModalBottomSheet(
              context: Get.context!,
              isScrollControlled: true,
              useSafeArea: true,
              useRootNavigator: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))
              ),
              builder: (context) {
                return _openReview(controller);
              }
          );
        }),
        h(10)
      ]
    );
  }

  Widget _buildReviewCard(ReviewModel review, ProductController controller, int index) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: Get.context!,
            isScrollControlled: true,
            useSafeArea: true,
            useRootNavigator: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))
            ),
            builder: (context) {
              return _openComments(controller, review);
            }
        );
      },
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    review.author,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
                h(20),
                Row(
                    children: [
                      if (review.rating > 0) Row(
                          children: [1,2,3,4,5].map((e) => Icon(e <= review.rating ? Icons.star : Icons.star_half, color: Colors.amber, size: 16)).toList()
                      ),
                      if (review.rating > 0) w(5),
                      if (review.rating > 0) Text(
                          '${review.rating}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)
                      ),
                      if (review.date != null) Spacer(),
                      if (review.date != null) Text(controller.formatDateCustom(review.date!), style: TextStyle(color: Colors.grey))
                    ]
                ),
                h(10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Stack(
                              children: [
                                Text(review.text, style: TextStyle(), maxLines: review.checked && controller.isChecked.value == index ? null : 3, overflow: review.checked && controller.isChecked.value == index ? null : TextOverflow.ellipsis),
                                if (review.text.length > 200 && !review.checked) Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                        onTap: () {
                                          review.checked = !review.checked;
                                          controller.revHeight.value = Helper.getTextHeight(review.text, TextStyle(), Get.width - 44);

                                          if (review.checked) {
                                            controller.isChecked.value = index;
                                          } else {
                                            controller.isChecked.value = -1;
                                          }
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.only(left: 3),
                                            color: Colors.white,
                                            child: Text(
                                                'читать далее...',
                                                style: TextStyle(color: Colors.blue, fontSize: 14)
                                            )
                                        )
                                    )
                                )
                              ]
                          ),
                          if (review.checked) InkWell(
                              onTap: () {
                                review.checked = false;
                                controller.isChecked.value = -1;
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(left: 3),
                                  color: Colors.white,
                                  child: Text(
                                      'Свернуть',
                                      style: TextStyle(color: Colors.blue, fontSize: 14)
                                  )
                              )
                          )
                        ]
                    )
                )
              ]
          )
      )
    );
  }

  Widget _openCommentQuestion(ProductController controller, QuestionModel question) {
    return SizedBox(
        height: Get.height * 0.8,
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                left: 16, right: 16, top: 40, bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      question.author,
                                      style: TextStyle(
                                          color: Color(0xFF1E1E1E),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600
                                      )
                                  ),
                                  h(10),
                                  if (question.rating > 0) Row(
                                      children: [
                                        Row(
                                            children: [1,2,3,4,5].map((e) => Icon(e <= question.rating ? Icons.star : Icons.star_half, color: Colors.amber, size: 16)).toList()
                                        ),
                                        w(5),
                                        Text(
                                            '${question.rating}',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)
                                        )
                                      ]
                                  )
                                ]
                            )
                        ),
                        Text(
                            controller.formatDateCustom(question.date),
                            style: TextStyle(
                                color: Color(0xFF8A95A8),
                                fontSize: 11
                            )
                        )
                      ]
                  ),
                  h(16),
                  Text(
                      question.text,
                      style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 14,
                          height: 1.40
                      )
                  ),
                  h(32),
                  if (question.comments.isNotEmpty) Wrap(
                      runSpacing: 12,
                      children: List.generate(question.comments.length, (index) {
                        final item = question.comments[index];

                        return !item.parent ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                                color: Color(0x4CF0F0F0),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                                    borderRadius: BorderRadius.circular(6)
                                )
                            ),
                            child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            child: Row(
                                                children: [
                                                  Image.asset('assets/icon/chat.png', width: 16),
                                                  w(6),
                                                  Text(
                                                      item.author,
                                                      style: TextStyle(
                                                          color: Color(0xFF1E1E1E),
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600
                                                      )
                                                  )
                                                ]
                                            )
                                        ),
                                        Text(
                                            controller.formatDateCustom(item.date),
                                            style: TextStyle(
                                                color: Color(0xFF8A95A8),
                                                fontSize: 11
                                            )
                                        )
                                      ]
                                  ),
                                  h(16),
                                  Text(
                                      item.text,
                                      style: TextStyle(
                                          color: Color(0xFF1E1E1E),
                                          fontSize: 14,
                                          height: 1.40
                                      )
                                  )
                                ]
                            )
                        ) : Text(
                            item.text,
                            style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 14,
                                height: 1.40
                            )
                        );
                      })
                  ),
                  h(20),
                  PrimaryButton(text: 'Оставить комментарий', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () {
                    controller.isQuestionComment.value = question.id;
                    Get.back();

                    showModalBottomSheet(
                        context: Get.context!,
                        isScrollControlled: true,
                        useSafeArea: true,
                        useRootNavigator: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                        ),
                        builder: (context) {
                          return _openReview(controller);
                        }
                    );
                  }),
                  h(20)
                ]
            )
        )
    );
  }

  Widget _buildQuestionCard(QuestionModel question, ProductController controller, int index) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: Get.context!,
            isScrollControlled: true,
            useSafeArea: true,
            useRootNavigator: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))
            ),
            builder: (context) {
              return _openCommentQuestion(controller, question);
            }
        );
      },
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text(
                              question.author,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          )
                      ),
                      Text(controller.formatDateCustom(question.date), style: TextStyle(color: Colors.grey))
                    ]
                ),
                h(10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Stack(
                              children: [
                                Text(question.text, style: TextStyle(), maxLines: question.checked && controller.isQuestionChecked.value == index ? null : 3, overflow: question.checked && controller.isQuestionChecked.value == index ? null : TextOverflow.ellipsis),
                                if (question.text.length > 200 && !question.checked) Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                        onTap: () {
                                          question.checked = !question.checked;
                                          controller.questionHeight.value = Helper.getTextHeight(question.text, TextStyle(), Get.width - 44);

                                          if (question.checked) {
                                            controller.isQuestionChecked.value = index;
                                          } else {
                                            controller.isQuestionChecked.value = -1;
                                          }
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.only(left: 3),
                                            color: Colors.white,
                                            child: Text(
                                                'читать далее...',
                                                style: TextStyle(color: Colors.blue, fontSize: 14)
                                            )
                                        )
                                    )
                                )
                              ]
                          ),
                          if (question.checked) InkWell(
                              onTap: () {
                                question.checked = false;
                                controller.isQuestionChecked.value = -1;
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(left: 3),
                                  color: Colors.white,
                                  child: Text(
                                      'Свернуть',
                                      style: TextStyle(color: Colors.blue, fontSize: 14)
                                  )
                              )
                          )
                        ]
                    )
                )
              ]
          )
      )
    );
  }

  Widget _buildTimerBox(ProductController controller) {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFF009FE6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTimerItem(controller.time.value.inDays, Helper.getNoun(controller.time.value.inDays, 'День', 'Дня', 'Дней', before: false)),
          _buildTimerItem(controller.time.value.inHours % 24, Helper.getNoun(controller.time.value.inHours % 24, 'Час', 'Часа', 'Часов', before: false)),
          _buildTimerItem(controller.time.value.inMinutes % 24, Helper.getNoun(controller.time.value.inMinutes % 24, 'Минута', 'Минуты', 'Минут', before: false))
        ]
      )
    ));
  }

  Widget _buildTimerItem(int value, String label) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Text('$value', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))
        ),
        w(5),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.white))
      ]
    );
  }

  Widget _openZap(ProductController controller) {
    final zap = controller.product.value!.zap;
    final count = (zap.length / 4).ceil();

    return Padding(
        padding: EdgeInsets.only(
            left: 16, right: 16, top: 20, bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20
        ),
        child: Form(
            key: controller.formKey4,
            child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            Get.context!,
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: controller.product.value!.schema),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              }
                            )
                          );
                        },
                        child: CachedNetworkImage(
                            imageUrl: controller.product.value!.schema,
                            errorWidget: (c, e, i) {
                              return Image.asset('assets/image/no_image.png');
                            },
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.contain
                        )
                      )
                  ),
                  h(20),
                  if (zap.isNotEmpty) ModuleTitle(title: 'Запчасти', type: true),
                  if (zap.isNotEmpty) Column(
                    children: [
                      SizedBox(
                        height: zap.length >= 4 ? 190 : zap.length * 64,
                        child: PageView.builder(
                          itemCount: count,
                          padEnds: false,
                          itemBuilder: (context, index) {
                            return Obx(() => Wrap(
                                runSpacing: 10,
                                children: List.generate(4, (colIndex) {
                                  int productIndex = index * 4 + colIndex;

                                  if (productIndex < zap.length) {
                                    return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: Colors.grey.withOpacityX(0.13))
                                              ),
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              clipBehavior: Clip.antiAlias,
                                              child: CachedNetworkImage(
                                                  imageUrl: zap[productIndex].image,
                                                  errorWidget: (c, e, i) {
                                                    return Image.asset('assets/image/no_image.png');
                                                  },
                                                  height: 54,
                                                  width: 50,
                                                  fit: BoxFit.contain
                                              )
                                          ),
                                          w(8),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        zap[productIndex].title,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: Color(0xFF1E1E1E),
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w600
                                                        )
                                                    ),
                                                    Text(
                                                      ((zap[productIndex].special ?? '').isNotEmpty ? zap[productIndex].special : zap[productIndex].price) ?? '',
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(
                                                          color: Color(0xFF1E1E1E),
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w700
                                                      )
                                                    )
                                                  ]
                                              )
                                          ),
                                          w(8),
                                          PrimaryButton(text: controller.navController.isCart(zap[productIndex].id) ? 'В корзине' : 'Купить', width: 97, height: 44, onPressed: () async {
                                            sernumPop(controller, zap[productIndex].id);
                                          })
                                        ]
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                })
                            ));
                          }
                        )
                      ),
                      if (count > 1) Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(count, (index) {
                            return Container(
                              margin: EdgeInsets.all(4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: index == 0 ? Colors.blue : Colors.grey,
                                shape: BoxShape.circle
                              )
                            );
                          })
                        )
                      )
                    ]
                  ),
                  h(20)
                ]
            ))
        )
    );
  }

  Widget _imageCard(ProductController controller) {
    List<String> images = controller.product.value!.images;
    
    if (controller.selectChild.isNotEmpty) {
      final child = controller.childProducts.where((e) => e.id == controller.selectChild.value && (e.images ?? []).isNotEmpty);

      if (child.where((e) => e.color.isNotEmpty).isNotEmpty) {
        images.clear();
      }

      for (var i in child) {
        images.addAll(i.images!);
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<int>(
            valueListenable: Helper.trigger,
            builder: (context, items, child) => Stack(
                children: [
                  SizedBox(
                      height: 208,
                      child: PageView.builder(
                          clipBehavior: Clip.none,
                          controller: controller.pageController,
                          onPageChanged: (val) async {
                            await controller.pageController2.animateToPage(val, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            controller.activeIndex.value = val;
                          },
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            final item = images[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    Get.context!,
                                    PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: item),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(opacity: animation, child: child);
                                        }
                                    )
                                );
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.withOpacityX(0.13))
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                      imageUrl: item,
                                      errorWidget: (c, e, i) {
                                        return Image.asset('assets/image/no_image.png');
                                      },
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.contain
                                  )
                              )
                            );
                          }
                      )
                  ),
                  Positioned(
                      left: 18,
                      top: 10,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.product.value!.category.isNotEmpty) Container(
                                constraints: BoxConstraints(maxWidth: 100),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                                    ]
                                ),
                                child: Text(controller.product.value!.category, style: TextStyle(color:primaryColor, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)
                            ),
                            if (controller.product.value!.category.isNotEmpty) h(8),
                            if (controller.product.value!.reward > 0) TooltipWidget(
                                message: 'Количество бонусных баллов за покупку',
                                child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: ShapeDecoration(
                                        color: Color(0xFF009FE6),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16)
                                        )
                                    ),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              '${controller.product.value!.reward}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600
                                              )
                                          ),
                                          w(2),
                                          Image.asset('assets/icon/rang.png')
                                        ]
                                    )
                                )
                            )
                          ]
                      )
                  ),
                  Positioned(
                      right: 18,
                      top: 10,
                      child: Column(
                          children: [
                            InkWell(
                                onTap: () => controller.addWishlist(controller.product.value!.id),
                                child: Icon(Helper.wishlist.value.contains(controller.product.value!.id) ? Icons.favorite : Icons.favorite_border, color: Helper.wishlist.value.contains(controller.product.value!.id) ? primaryColor : Colors.black, size: 28)
                            ),
                            h(8),
                            InkWell(
                                onTap: () => Helper.addCompare(controller.product.value!.id),
                                child: Image.asset('assets/icon/rat${Helper.compares.value.contains(controller.product.value!.id) ? '2' : ''}.png', width: 24, fit: BoxFit.cover)
                            ),
                            h(8),
                            InkWell(
                                onTap: () async {
                                  SharePlus.instance.share(
                                    ShareParams(uri: Uri.parse(controller.product.value!.url), title: controller.product.value!.name),
                                  );
                                },
                                child: Icon(Icons.share)
                            )
                          ]
                      )
                  )
                ]
            )
        ),
        h(16),
        SizedBox(
            height: 64,
            child: PageView.builder(
                clipBehavior: Clip.none,
                controller: controller.pageController2,
                onPageChanged: (val) async {
                  await controller.pageController.animateToPage(val, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  controller.activeIndex.value = val;
                },
                padEnds: false,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final item = images[index];

                  return Obx(() => Container(
                      width: 79,
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                          onTap: () async {
                            await controller.pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            controller.activeIndex.value = index;
                          },
                          child: Stack(
                              children: [
                                Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(color: primaryColor.withOpacityX(0.01), width: 2),
                                            borderRadius: BorderRadius.circular(8)
                                        )
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                            imageUrl: item,
                                            errorWidget: (c, e, i) {
                                              return Image.asset('assets/image/no_image.png');
                                            },
                                            height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.contain
                                        )
                                    )
                                ),
                                if (controller.activeIndex.value != index) Positioned(
                                    left: 0,
                                    top: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: primaryColor.withOpacityX(0.1),
                                            borderRadius: BorderRadius.circular(8)
                                        )
                                    )
                                )
                              ]
                          )
                      )
                  ));
                }
            )
        ),
        h(24)
      ]
    );
  }

  Widget _attributes(ProductController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModuleTitle(title: 'Характеристики', type: true),
          AnimatedContainer(
              duration: Duration(milliseconds: 300),
              clipBehavior: Clip.hardEdge,
              key: controller.attrKey,
              decoration: BoxDecoration(),
              constraints: controller.isExpanded2.value ? null : BoxConstraints(maxHeight: 20 * (controller.product.value!.attributes.length / 5)),
              child: Wrap(
                  children: controller.product.value!.attributes.map((item) => _buildSpecRow(item.name, item.text)).toList()
              )
          ),
          if (controller.product.value!.attributes.length > 5) h(10),
          if (controller.product.value!.attributes.length > 5) GestureDetector(
            onTap: () {
              if (controller.isExpanded2.value) {
                controller.scrollToAttr();
              }

              controller.isExpanded2.value = !controller.isExpanded2.value;
            },
            child: Text(
              controller.isExpanded2.value ? 'Свернуть' : 'Все характеристики',
              style: TextStyle(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600
              )
            )
          )
        ]
      )
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Positioned(
                  bottom: -3,
                  left: 0,
                  right: 0,
                  child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1
                  )
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(right: 2),
                  child: Text(
                      label,
                      style: TextStyle(
                        color: Color(0xFF8A95A8),
                        fontSize: 14,
                        height: 1.40
                      )
                  )
                )
              ]
            )
          ),
          w(10),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 14,
                height: 1.40
              )
            )
          )
        ]
      )
    );
  }

  void sernumPop(ProductController controller, String id) {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) => Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            backgroundColor: Colors.white,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)
                ),
                height: Get.height * 0.8,
                clipBehavior: Clip.antiAlias,
                child: Stack(
                    children: [
                      Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                          'Серийный номер',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: Get.back
                                      )
                                    ]
                                )
                            ),
                            const Divider(height: 1),
                            h(16),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                    spacing: 15,
                                    children: [
                                      TextFormField(
                                          controller: controller.serNumField,
                                          cursorHeight: 15,
                                          validator: (value) {
                                            if ((value ?? '').isEmpty) {
                                              return 'Заполните серийный номер';
                                            }

                                            return null;
                                          },
                                          decoration: decorationInput(hint: 'Серийный номер *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (val) {

                                          }
                                      ),
                                      PrimaryButton(text: 'Купить', height: 44, loader: true, onPressed: () async {
                                        final serNum = controller.serNumField.text.trim();

                                        if (serNum.isEmpty) {
                                          Helper.snackBar(error: true, text: 'Укажите серийный номер товара для которого покупаете запчасть');
                                          return;
                                        }

                                        await controller.getSerNum(serNum, id);
                                      })
                                    ]
                                )
                            )
                          ]
                      )
                    ]
                )
            )
        )
    );
  }
}