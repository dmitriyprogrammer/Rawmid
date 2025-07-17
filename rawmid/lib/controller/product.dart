import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:rawmid/api/product.dart';
import 'package:rawmid/model/home/product.dart';
import 'package:rawmid/model/product/product_item.dart';
import 'package:rawmid/model/product/question.dart';
import 'package:rawmid/model/product/review.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ypay/ypay.dart';
import '../api/cart.dart';
import '../api/checkout.dart';
import '../api/home.dart';
import '../api/login.dart';
import '../api/profile.dart';
import '../model/cart.dart';
import '../model/home/news.dart';
import '../screen/product/zap.dart';
import '../utils/helper.dart';
import '../utils/notifications.dart';
import '../widget/h.dart';
import 'cart.dart';
import 'navigation.dart';

class ProductController extends GetxController {
  String id;
  ProductController(this.id);
  Rxn<ProductItemModel> product = Rxn<ProductItemModel>();
  RxBool isLoading = false.obs;
  RxBool isExpanded2 = false.obs;
  RxBool emailValidate = false.obs;
  RxBool isAgree = true.obs;
  RxBool isPreAgree = true.obs;
  RxBool isLoad = true.obs;
  RxString isComment = ''.obs;
  RxString isQuestionComment = ''.obs;
  RxInt isChecked = (-1).obs;
  RxString selectChild = ''.obs;
  RxDouble revHeight = 0.0.obs;
  RxDouble questionHeight = 0.0.obs;
  RxInt isQuestionChecked = (-1).obs;
  RxInt activeIndex = 0.obs;
  RxInt sale = 0.obs;
  RxDouble saleTransition = 0.0.obs;
  RxDouble saleTransitionEnd = 0.0.obs;
  RxInt activeReviewsIndex = 0.obs;
  RxInt activeQuestionsIndex = 0.obs;
  var chainAdd = <String>[].obs;
  final pageController = PageController();
  final reviewsController = PageController(viewportFraction: 1.06);
  final questionController = PageController(viewportFraction: 1.06);
  final chainController = PageController(viewportFraction: 0.6);
  final pageController2 = PageController(viewportFraction: 0.25);
  final childController = PageController(viewportFraction: 0.6);
  final accessoriesController = PageController(viewportFraction: 0.6);
  final videoController = PageController(viewportFraction: 0.9);
  final navController = Get.find<NavigationController>();
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  Timer? timer;
  Rx<Duration> time = Duration().obs;
  RxList<ProductModel> accessories = <ProductModel>[].obs;
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  RxList<ProductModel> zap = <ProductModel>[].obs;
  RxList<QuestionModel> questions = <QuestionModel>[].obs;
  RxList<NewsModel> recipes = <NewsModel>[].obs;
  RxList<NewsModel> surveys = <NewsModel>[].obs;
  RxList<NewsModel> rec = <NewsModel>[].obs;
  RxList<String> video = <String>[].obs;
  final serNumField = TextEditingController();
  final questionField = TextEditingController();
  final nameField = TextEditingController();
  final fioField = TextEditingController();
  final fioPreField = TextEditingController();
  final fioReviewField = TextEditingController();
  final textReviewField = TextEditingController();
  final emailField = TextEditingController();
  final emailReviewField = TextEditingController();
  final textField = TextEditingController();
  final textPreField = TextEditingController();
  final textXField = TextEditingController();
  final emailXField = TextEditingController();
  final fioXField = TextEditingController();
  final priceField = TextEditingController();
  final ucKey = GlobalKey();
  final attrKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();
  RxInt rating = 0.obs;
  final phoneField = PhoneController(initialValue: const PhoneNumber(isoCode: IsoCode.KZ, nsn: ''));
  final phonePreField = PhoneController(initialValue: const PhoneNumber(isoCode: IsoCode.KZ, nsn: ''));
  RxList<ProductModel> childProducts = <ProductModel>[].obs;
  WebViewController? webController;
  WebViewController? webPersonalController;
  var viewed = (Helper.prefs.getStringList('viewed') ?? <String>[]).obs;
  final yPlugin = YPay.instance;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  void onClose() {
    timer?.cancel();
    timer = null;
    pageController.dispose();
    reviewsController.dispose();
    questionController.dispose();
    chainController.dispose();
    pageController2.dispose();
    childController.dispose();
    accessoriesController.dispose();
    videoController.dispose();
    super.onClose();
  }

  setId(String val) {
    isLoading.value = false;
    id = val;
  }

  scrollToUc() {
    Scrollable.ensureVisible(
        ucKey.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut
    );
  }

  scrollToAttr() {
    Scrollable.ensureVisible(
        attrKey.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut
    );
  }

  Future getSerNum(String val, String id) async {
    final api = await ProductApi.getSerNum(val, id);

    if (api) {
      await navController.addCart(id);
      navController.update();
      serNumField.clear();
      Get.back();
      Get.back();
    }
  }

  Future initialize() async {
    isLoading.value = false;
    timer?.cancel();
    timer = null;
    CartApi.getProducts().then((e) => navController.cartProducts.value = e);

    if (!viewed.contains(id)) {
      viewed.add(id);
    }

    Helper.prefs.setStringList('viewed', viewed);

    final api = await ProductApi.getProduct(id);
    ProductApi.getAccessories(id).then((e) {
      accessories.value = e;
    });
    ProductApi.getReviews(id).then((e) {
      reviews.value = e;
    });
    fioField.text = navController.user.value?.firstname ?? '';
    nameField.text = navController.user.value?.firstname ?? '';
    fioReviewField.text = '${navController.user.value?.firstname ?? ''} ${navController.user.value?.lastname ?? ''}'.trim();
    emailReviewField.text = navController.user.value?.email ?? '';
    emailField.text = navController.user.value?.email ?? '';

    if (api != null) {
      product.value = api;
      video.value = api.video;
      questions.value = api.questions;
      childProducts.value = api.childProducts;
      selectChild.value = api.childProducts.firstOrNull?.id ?? '';
      recipes.value = api.recipes;
      surveys.value = api.surveys;
      rec.value = api.rec;
      zap.value = api.zap;
      final now = DateTime.now();

      try {
        phoneField.value = PhoneNumber.parse(navController.user.value!.phone);
        phonePreField.value = PhoneNumber.parse(navController.user.value!.phone);
      } catch(_) {
        //
      }

      if (api.text.isNotEmpty) {
        webController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) {
                final url = request.url;

                if (url.endsWith('.jpg') ||
                    url.endsWith('.jpeg') ||
                    url.endsWith('.png') ||
                    url.endsWith('.webp') ||
                    url.endsWith('.gif')) {

                  Navigator.push(
                      Get.context!,
                      PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: url),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          }
                      )
                  );

                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              }
            )
          )
          ..loadHtmlString('<style>#colorbox{scale:0.5!important}</style><meta name="viewport" content="width=device-width, initial-scale=1.0">${api.text}');
      }

      if (api.dateEnd != null && api.dateEnd!.millisecondsSinceEpoch > now.millisecondsSinceEpoch) {
        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          final difference = api.dateEnd!.difference(DateTime.now());
          time.value = difference.isNegative ? Duration.zero : difference;
        });
      }

      yPlugin.init(
        configuration: const Configuration(
          merchantId: '2c8f4476-a851-429e-89c6-f5ffef02a3f1',
          merchantName: 'RAWMID',
          merchantUrl: 'https://madeindream.com/',
          testMode: false
        )
      );

      isLoading.value = true;
    } else {
      Helper.snackBar(error: true, text: 'Не удалось загрузить данные, попробуйте позже', callback2: Get.back);
    }
  }

  String formatDateCustom(DateTime date) {
    List<String> months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];

    int day = date.day;
    String month = months[date.month - 1];
    int year = date.year;

    return '$day $month $year';
  }

  Future yPay(String id) async {
    if (navController.user.value == null) {
      isLoad.value = false;

      webController = WebViewController()
        ..setNavigationDelegate(
            NavigationDelegate(
                onPageFinished: (val) {
                  Future.delayed(Duration(seconds: 2), () {
                    isLoad.value = true;
                  });
                },
                onNavigationRequest: (NavigationRequest request) async {
                  if (request.url.contains('redirect_yandex=')) {
                    final uri = Uri.parse(request.url);
                    final code = uri.queryParameters['redirect_yandex'];

                    if (code != null) {
                      await Helper.prefs.setString('PHPSESSID', code);

                      ProfileApi.user().then((user) {
                        if (user != null) {
                          NotificationsService.getToken().then((token) {
                            if (token.isNotEmpty) {
                              HomeApi.saveToken(token);
                            }
                          });

                          final wishlist = Helper.prefs.getStringList('wishlist') ?? [];

                          if (wishlist.isNotEmpty) {
                            CartApi.addWishlist(wishlist);
                          }

                          final carts = navController.cartProducts;
                          List<CartModel> copy = List.from(carts);

                          navController.clear().then((_) {
                            if (copy.isNotEmpty) {
                              for (var cart in copy) {
                                navController.addCart(cart.id, c: true);
                              }
                            }
                          });

                          navController.user.value = user;
                          update();
                          Get.back();
                          yPay(id);
                        } else {
                          Helper.snackBar(error: true, text: 'Пользователь не найден');
                        }
                      });
                    }

                    return NavigationDecision.prevent;
                  }

                  return NavigationDecision.navigate;
                }
            )
        )
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse('https://oauth.yandex.ru/authorize?response_type=code&client_id=f9b68e69aabb4dcd90720917835dbd7c&redirect_uri=https://madeindream.com/index.php?route=api/app/yandex&lang=ru'));

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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Яндекс ID',
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
                        if (webController != null) Expanded(
                            child: Obx(() => !isLoad.value ? Center(child: CircularProgressIndicator(color: primaryColor)) : Container(
                                color: Colors.transparent,
                                child: WebViewWidget(
                                    controller: webController!
                                )
                            ))
                        )
                      ]
                  )
              )
          )
      );

      return;
    }

    List<CartModel> carts = navController.cartProducts;
    await navController.clear();

    final api = await CartApi.addCart({
      'product_id': id
    });

    if (api.isEmpty) {
      Helper.snackBar(error: true, text: 'Ошибка добавления товара в корзину');
      return;
    }

    final bodyCheckout = <String, dynamic>{};
    bodyCheckout.putIfAbsent('country_id', () => navController.countryId.value);
    bodyCheckout.putIfAbsent('city', () => navController.city.value);

    if (navController.user.value != null) {
      final user = navController.user.value;

      bodyCheckout.putIfAbsent('firstname', () => user!.firstname);
      bodyCheckout.putIfAbsent('lastname', () => user!.lastname);
      bodyCheckout.putIfAbsent('email', () => user!.email);
      bodyCheckout.putIfAbsent('telephone', () => '+${navController.user.value!.phone.replaceAll(RegExp(r'[^0-9]'), '')}'.replaceAll('+8', '8'));
    }

    final checkout = await CheckoutApi.checkout2(bodyCheckout);

    if (checkout != null) {
      final body = {
        'availablePaymentMethods': [
          'CARD', 'SPLIT'
        ],
        'cart': {
          'items': [
            {
              'description': product.value!.text2,
              'discountedUnitPrice': '${product.value!.special2}',
              'productId': id,
              'quantity': {
                'count': '1'
              },
              'receipt': {
                'tax': 1
              },
              'skuId': product.value!.sku,
              'subtotal': '${product.value!.price2}',
              'title': product.value!.name,
              'total': '${product.value!.special2 > 0 ? product.value!.special2 : product.value!.price2}',
              'unitPrice': '${product.value!.price2}'
            }
          ],
          'total': {
            'amount': '${product.value!.special2 > 0 ? product.value!.special2 : product.value!.price2}'
          }
        },
        'redirectUrls': {
          'onError': 'https://madeindream.com/index.php?route=api/app/yandex_callback',
          'onSuccess': 'https://madeindream.com/index.php?route=api/app/yandex_callback',
          'onAbort': 'https://madeindream.com/index.php?route=api/app/yandex_callback'
        },
        'orderSource': 'APP',
        'preferredPaymentMethod': 'FULLPAYMENT',
        'orderId': '${checkout.orderId}',
        'billingPhone': '${checkout.phone}',
        'currencyCode': product.value?.currency ?? 'RUB'
      };

      final api = await ProductApi.yPay(body);

      if (api.isNotEmpty) {
        yPlugin.startPayment(url: api);

        yPlugin.paymentResultStream().listen((e) {
          if (e == 'Finished with success') {
            Helper.snackBar(text: 'Ваш заказ успешно оформлен');
          } else if (e == 'Finished with cancelled event') {
            Helper.snackBar(error: true, text: 'Ваш заказ отменен');
          } else if (e == 'Finished with domain error') {
            Helper.snackBar(error: true, text: 'Произошла ошибка оплаты');
          } else {
            Helper.snackBar(error: true, text: 'Произошла ошибка оплаты');
          }

          if (carts.isNotEmpty) {
            CartApi.addCart({
              'ids': carts.map((e) => e.id).join(','),
              'qwe': carts.map((e) => e.quantity).join(','),
            }).then((api) {
              navController.cartProducts.value = api;

              if (Get.isRegistered<CartController>()) {
                final cart = Get.find<CartController>();
                cart.cartProducts.value = api;
                cart.update();
              }
            });

            carts = <CartModel>[];
          }
        });
      }
    }
  }

  Future addWishlist(String id) async {
    if (wishlist.contains(id)) {
      wishlist.remove(id);
    } else {
      wishlist.add(id);
    }

    Helper.prefs.setStringList('wishlist', wishlist);
    Helper.wishlist.value = wishlist;
    Helper.trigger.value++;
    navController.wishlist.value = wishlist;
    if (navController.user.value != null) {
      CartApi.addWishlist(wishlist);
    }
  }

  Future addChainCart(String id) async {
    final products = product.value!.chain!.products![id];
    Map<String, dynamic> body = {'chain_id': id};

    for (var i in products!) {
      body.putIfAbsent('chain_product_id[${i.productId}]', () => i.productId);
      body.putIfAbsent('chain_quantity[${i.productId}]', () => '1');
    }

    body.putIfAbsent('mult', () => '1');

    final api = await navController.addChainCart(body);

    if (api) {
      chainAdd.add(id);
    }
  }

  Future validateEmailX(String val) async {
    if (val.isNotEmpty && EmailValidator.validate(val)) {
      LoginApi.checkEmail(val).then((e) {
        emailValidate.value = !e;
      });
    } else {
      emailValidate.value = false;
    }
  }

  Future addQuestion() async {
    if (navController.user.value == null) {
      Helper.snackBar(error: true, text: 'Необходимо авторизироваться');
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      final api = await ProductApi.addQuestion({
        'product_id': id,
        'text': questionField.text,
        'name': nameField.text,
        'email': emailField.text
      });

      if (api) {
        Timer.periodic(const Duration(seconds: 3), (t) {
          Get.back();
          questionField.clear();
          emailField.clear();
          nameField.clear();

          t.cancel();
        });
      }
    }
  }

  Future addQuestionOther() async {
    if ((formKey2.currentState?.validate() ?? false) && !isAgree.value) {
      Helper.snackBar(error: true, text: 'Необходимо ознакомиться с обработкой персональных данных');
      return;
    }

    if (formKey2.currentState?.validate() ?? false) {
      final api = await ProductApi.addQuestionOther({
        'product': product.value!.name,
        'model': product.value!.sku,
        'fio': fioField.text,
        'text': textField.text,
        'email': emailField.text,
        'phone': '+${phoneField.value.countryCode}${phoneField.value.nsn}',
        'agree': '1'
      });

      if (api) {
        Timer.periodic(const Duration(seconds: 7), (t) {
          textField.clear();
          fioField.clear();
          emailField.clear();
          phoneField.value = PhoneNumber(isoCode: Helper.isoCodeConversionMap[navController.countryCode.value] ?? IsoCode.KZ, nsn: '');

          t.cancel();
        });
      }
    }
  }

  Future addPreOrder() async {
    if ((formKey5.currentState?.validate() ?? false) && !isPreAgree.value) {
      Helper.snackBar(error: true, text: 'Необходимо ознакомиться с обработкой персональных данных');
      return;
    }

    if (formKey5.currentState?.validate() ?? false) {
      final api = await ProductApi.addQuestionOther({
        'product': product.value!.name,
        'model': product.value!.sku,
        'fio': fioPreField.text,
        'text': textPreField.text,
        'email': '',
        'phone': '+${phonePreField.value.countryCode}${phonePreField.value.nsn}',
        'agree': '1'
      });

      if (api) {
        Timer.periodic(const Duration(seconds: 7), (t) {
          textField.clear();
          fioField.clear();
          emailField.clear();
          phonePreField.value = PhoneNumber(isoCode: Helper.isoCodeConversionMap[navController.countryCode.value] ?? IsoCode.KZ, nsn: '');

          t.cancel();
        });
      }
    }
  }

  Future addReview() async {
    if (rating.value == 0 && isComment.isEmpty && isQuestionComment.isEmpty) {
      Helper.snackBar(error: true, text: 'Выберите оценку');
      return;
    }

    if (formKey3.currentState?.validate() ?? false) {
      bool api;

      if (isQuestionComment.isNotEmpty) {
        api = await ProductApi.addQuestionComment({
          'product_id': id,
          'qa_id': isQuestionComment.value,
          'name': fioReviewField.text,
          'text': textReviewField.text,
          'email': navController.user.value?.email ?? emailReviewField.text
        });
      } else if (isComment.isNotEmpty) {
        api = await ProductApi.addComment({
          'product_id': id,
          'parent_id': isComment.value,
          'name': fioReviewField.text,
          'text': textReviewField.text,
          'email': navController.user.value?.email ?? emailReviewField.text,
          'rating': '${rating.value}'
        });
      } else {
        api = await ProductApi.addReview({
          'product_id': id,
          'name': fioReviewField.text,
          'text': textReviewField.text,
          'email': navController.user.value?.email ?? emailReviewField.text,
          'rating': '${rating.value}'
        });
      }

      if (api) {
        isComment.value = '';
        isQuestionComment.value = '';

        Timer.periodic(const Duration(seconds: 3), (t) {
          Get.back();
          textReviewField.clear();
          fioReviewField.clear();
          rating.value = 0;
          emailReviewField.clear();

          t.cancel();
        });
      }
    }
  }

  Future addX() async {
    if (formKey4.currentState?.validate() ?? false) {
      final api = await ProductApi.addX({
        'product_id': id,
        'price_field': priceField.text,
        'customer_name': fioXField.text,
        'customer_email': navController.user.value?.email ?? emailXField.text,
        'customer_telephone': navController.user.value?.phone ?? '',
        'customer_opinion': textXField.text,
        'percent': '${sale.value}'
      });

      if (api) {
        Timer.periodic(const Duration(seconds: 7), (t) {
          priceField.clear();
          fioXField.clear();
          textXField.clear();
          emailXField.clear();
          sale.value = 0;
          saleTransition.value = 0;
          saleTransitionEnd.value = 0;

          t.cancel();
        });
      }
    }
  }

  setSale(int val) {
    if (val == 0) {
      sale.value = 0;
      return;
    }

    String currencySymbol = product.value!.price.replaceAll(RegExp(r'[\d\s]+'), '').trim();
    double price = double.tryParse((product.value!.special.isNotEmpty ? product.value!.special : product.value!.price).replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    price -= (price * val / 100).ceilToDouble();
    saleTransition.value = double.tryParse(priceField.text) ?? 0;
    priceField.text = Helper.formatPrice(price, symbol: currencySymbol);
    saleTransitionEnd.value = price;
    sale.value = val;
  }
}