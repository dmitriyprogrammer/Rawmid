import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/utils/helper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api/home.dart';
import '../api/login.dart';
import '../model/product/product_autocomplete.dart';
import '../model/profile/sernum.dart';

class MyProductController extends GetxController {
  var products = <SernumModel>[].obs;
  final lastnameField = TextEditingController();
  final nameField = TextEditingController();
  final emailField = TextEditingController();
  final dateField = TextEditingController();
  final productField = TextEditingController();
  final modelField = TextEditingController();
  final numberField = TextEditingController();
  var phoneField = PhoneController(initialValue: const PhoneNumber(isoCode: IsoCode.RU, nsn: ''));
  var validateEmail = false.obs;
  var commerce = false.obs;
  var noSerCheck = false.obs;
  var noOrderId = false.obs;
  var agree = false.obs;
  var noSer = false.obs;
  var place = Rxn<String>();
  var orderId = Rxn<String>();
  var productId = Rxn<String>();
  var orderIds = <String>[].obs;
  final List<String> places = [
    'madeindream.com',
    'WildBerries',
    'OZON',
    '4fresh.ru',
    '21vek.by',
    '220.lv',
    'Aliexpress',
    'amazingraw.com',
    'Amazon',
    'atmkuhni.ru',
    'cluboz56.ru',
    'device32.ru',
    'dustbuster.ru',
    'eco-sp.ru',
    'ecomir32.ru',
    'ecostoria.ru',
    'ecotopia.ru',
    'elektroteremok.ru',
    'globoteh.ru',
    'greendreamshop.ru',
    'greenshopks.ru',
    'happytehnika.ru',
    'Kaspi',
    'Kaup',
    'kompas96.ru',
    'kompotrnd.ru',
    'koptil.ru',
    'letmarket.ru',
    'nicemark.ru',
    'obs-dv.ru',
    'ocean-wave.ru',
    'ooont.ru',
    'Pigu',
    'prosushka.ru',
    'protech.in.ua mto.in.ua',
    'restor.restorator.by',
    'restorator.pro',
    'robotvsem.com',
    'Sbermegamarket',
    'ss-store.ru',
    'su-vide.ru',
    'syroeshka.ru',
    'tdinteres.ru',
    'termix.kz',
    'vegetus.by',
    'vsesoki.ru',
    'yogafood-krasnodar.ru',
    'zdorovlegko.ru',
    'Яндекс маркет',
    'магазиндляжизни.рф',
    'экомагазин1.рф',
    'Другое',
  ];
  var selectedDate = Rxn<DateTime>();
  WebViewController? webPersonalController;
  final main = Get.find<NavigationController>();
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    HomeApi.getSernum().then((e) {
      products.value = e;
    });

    lastnameField.text = main.user.value?.lastname ?? '';
    nameField.text = main.user.value?.firstname ?? '';
    emailField.text = main.user.value?.email ?? '';
    phoneField.value = PhoneNumber.parse(main.user.value?.phone ?? '');

    if (Get.arguments ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed('/add_product')?.then((_) {
          Get.back();
        });
      });
    }
  }

  Future getOrderIds() async {
    HomeApi.getOrderIds().then((e) {
      orderIds.value = e;
    });
  }

  Future validateEmailX() async {
    if (emailField.text.isNotEmpty && EmailValidator.validate(emailField.text)) {
      final api = await LoginApi.checkEmail(emailField.text);
      validateEmail.value = !api;
    } else {
      validateEmail.value = false;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: Locale('ru', 'RU'),
        initialDate: selectedDate.value ?? DateTime.now(),
        firstDate: DateTime(1960),
        lastDate: DateTime(2100)
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dateField.text = DateFormat('yyyy-MM-dd', 'ru').format(picked);
    }
  }

  Future register() async {
    if (place.value == null) {
      Helper.snackBar(error: true, text: 'Выберите место покупки');
      return;
    }

    if (!agree.value) {
      Helper.snackBar(error: true, text: 'Необходимо принять условия и политику обработки');
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      var rawData = {
        'sernum': numberField.text,
        'no_sernum': noSerCheck.value ? 1 : 0,
        'commercial': commerce.value ? 1 : 0,
        'firstname': nameField.text,
        'lastname': lastnameField.text,
        'date_ordered': dateField.text,
        'model': modelField.text,
        'product': productField.text,
        'product_id': productId.value,
        'email': emailField.text,
        'place': place.value,
        'telephone': '+${phoneField.value.countryCode}${phoneField.value.nsn}',
      };

      if ((orderId.value ?? '').isNotEmpty) {
        rawData.putIfAbsent('order_id', () => orderId.value);
      }

      if (noOrderId.value) {
        rawData.putIfAbsent('no_order_id', () => 1);
      }

      final body = rawData.map((key, value) => MapEntry(key, value.toString()));
      final api = await HomeApi.registerProduct(body);

      if (api) {
        Helper.snackBar(text: 'Вы успешно зарегистрировали товар', callback2: () {
          Get.back();
        });
      }
    }
  }

  Future warranty() async {
    if (formKey2.currentState?.validate() ?? false) {
      var rawData = {
        'sernum': numberField.text,
        'commercial': commerce.value ? 1 : 0,
        'firstname': nameField.text,
        'lastname': lastnameField.text,
        'date_ordered': dateField.text,
        'model': modelField.text,
        'product': productField.text,
        'product_id': productId.value,
        'email': emailField.text,
        'place': place.value,
        'telephone': '+${phoneField.value.countryCode}${phoneField.value.nsn}',
      };

      final body = rawData.map((key, value) => MapEntry(key, value.toString()));
      final api = await HomeApi.warrantyProduct(body);

      if (api.isNotEmpty) {
        Helper.snackBar(text: api, callback2: () {
          Get.back();
        });
      }
    }
  }

  Future<List<ProductAutocompleteModel>> suggestionsCallback(String pattern) async {
    return await HomeApi.getAutocomplete({'fn': pattern});
  }

  Future<List<ProductAutocompleteModel>> suggestionsCallback2(String pattern) async {
    return await HomeApi.getAutocomplete({'fm': pattern});
  }

  Future<List<ProductAutocompleteModel>> suggestionsCallback3(String pattern) async {
    return await HomeApi.getAutocomplete({'fm': pattern});
  }
}