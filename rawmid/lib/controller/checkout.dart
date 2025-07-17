import 'dart:async';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:rawmid/api/checkout.dart';
import 'package:rawmid/api/order.dart';
import 'package:rawmid/controller/cart.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/model/checkout/order.dart';
import 'package:rawmid/model/checkout/payment.dart';
import 'package:rawmid/model/checkout/total.dart';
import 'package:rawmid/model/home/product.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api/cart.dart';
import '../api/home.dart';
import '../api/login.dart';
import '../api/profile.dart';
import '../model/cart.dart';
import '../model/checkout/bb_item.dart';
import '../model/checkout/pvz.dart';
import '../model/checkout/shipping.dart';
import '../model/country.dart';
import '../model/location.dart';
import '../model/order_history.dart';
import '../screen/checkout/payment.dart';
import '../utils/helper.dart';

class CheckoutController extends GetxController {
  final navController = Get.find<NavigationController>();
  RxBool isLoading = false.obs;
  RxBool preload = false.obs;
  RxBool isPayLoad = false.obs;
  RxBool emailValidate = false.obs;
  RxBool addAddress = false.obs;
  RxBool cDek = false.obs;
  RxString searchC = ''.obs;
  RxBool success = false.obs;
  RxBool agree = false.obs;
  RxBool suggestionSelected = false.obs;
  RxBool isLoading2 = false.obs;
  RxBool courier = false.obs;
  RxInt prepayment = (Helper.prefs.getInt('prepayment') ?? 0).obs;
  final GlobalKey<FormState> formKeyAddress = GlobalKey<FormState>();
  RxList<ProductModel> acc = <ProductModel>[].obs;
  RxList<ShippingModel> shipping = <ShippingModel>[].obs;
  RxList<PaymentModel> payment = <PaymentModel>[].obs;
  RxList<TotalModel> totals = <TotalModel>[].obs;
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  final pageController = PageController(viewportFraction: 0.20);
  RxInt tab = 0.obs;
  RxMap<String, int> accAdd = <String, int>{}.obs;
  Rxn<Pvz> selectedPvz = Rxn<Pvz>();
  Rxn<BBItemModel> selectedBBPvz = Rxn<BBItemModel>();
  Rxn<Point> userLocation = Rxn<Point>();
  Rxn<String> region = Rxn<String>('2760');
  Rxn<String> edo = Rxn();
  var country = Rxn<String>('176');
  RxList<CountryModel> countries = <CountryModel>[].obs;
  RxList<ZoneModel> regions = <ZoneModel>[].obs;
  RxInt addressId = 0.obs;
  final commentField = TextEditingController();
  final Map<String, TextEditingController> fizControllers = {
    'firstname': TextEditingController(),
    'lastname': TextEditingController(),
    'email': TextEditingController(),
    'telephone': TextEditingController()
  };
  final phoneField = PhoneController(initialValue: const PhoneNumber(isoCode: IsoCode.KZ, nsn: ''));
  final phoneBuhField = PhoneController(initialValue: const PhoneNumber(isoCode: IsoCode.KZ, nsn: ''));
  final Map<String, TextEditingController> controllersAddress = {
    'city': TextEditingController(),
    'postcode': TextEditingController(),
    'address_1': TextEditingController()
  };
  final Map<String, TextEditingController> urControllers = {
    'inn': TextEditingController(),
    'company': TextEditingController(),
    'ogrn': TextEditingController(),
    'rs': TextEditingController(),
    'bank': TextEditingController(),
    'bik': TextEditingController(),
    'kpp': TextEditingController(),
    'uraddress': TextEditingController(),
    'address_buh': TextEditingController(),
    'email_buh': TextEditingController(),
    'phone_buh': TextEditingController()
  };
  final Map<String, String> controllerHints = {
    'telephone': '+7 (___) ___ __ __',
    'email': 'E-mail',
    'lastname': 'Фамилия',
    'firstname': 'Имя',
    'inn': 'Инн *',
    'company': 'Компания *',
    'ogrn': ' ОГРН *',
    'rs': 'Номер р/с *',
    'bank': 'Банк *',
    'bik': 'БИК *',
    'kpp': 'КПП *',
    'uraddress': 'Юридический адрес *',
    'address_buh': 'Почтовый адрес организации *',
    'email_buh': 'E-mail бухгалтерии *',
    'phone_buh': '+7 (___) ___ __ __'
  };
  RxMap<String, String? Function(String?)> validators = <String, String? Function(String?)>{}.obs;
  RxString selectedShipping = ''.obs;
  RxString selectedPayment = ''.obs;
  RxBool usePrepayment = false.obs;
  Rxn<OrderModel> order = Rxn<OrderModel>();
  Rxn<OrdersModel> setOrder = Rxn<OrdersModel>();
  RxList<Pvz> pvz = <Pvz>[].obs;
  final formKey = GlobalKey<FormState>();
  WebViewController? webController;
  WebViewController? webPersonalController;
  RxMap<String, GlobalKey<FormFieldState>> errors = <String, GlobalKey<FormFieldState>>{}.obs;
  RxList<BBItemModel> bbItems = <BBItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  @override
  void onClose() {
    pageController.dispose();
    fizControllers.forEach((key, controller) => controller.dispose());
    controllersAddress.forEach((key, controller) => controller.dispose());
    urControllers.forEach((key, controller) => controller.dispose());
    super.onClose();
  }

  Future addCartAcc(String id, int index) async {
    if (accAdd[id] == null) {
      accAdd.putIfAbsent(id, () => index);
      await navController.addCart(id, c: true);

      if (navController.cartProducts.where((e) => e.id == id).isNotEmpty) {
        acc.removeWhere((e) => e.id == id);
      }
    }
  }

  setValidation() {
    validators.value = {
      'telephone': (value) {
        if (tab.value == 1) return null;
        if (value == null || value.isEmpty) {
          return 'Введите номер телефона';
        }

        String digits = value.replaceAll(RegExp(r'\D'), '');

        if (digits.length != 11 || !digits.startsWith('7')) {
          return 'Введите корректный номер';
        }

        return null;
      },
      'email': (value) {
        if (tab.value == 1) return null;
        String? item;

        if (value == null || value.isEmpty) item = 'Введите email';
        if (value != null && !EmailValidator.validate(value)) item = 'Некорректный email';

        return item;
      },
      'firstname': (value) {
        if (tab.value == 1) return null;
        if (value == null || value.isEmpty) return 'Введите имя';
        return null;
      },
      'lastname': (value) {
        if (tab.value == 1) return null;
        if (value == null || value.isEmpty) return 'Введите фамилию';
        return null;
      },
      'city': (value) {
        if ((value ?? '').isEmpty && (cDek.value || selectedShipping.value.isEmpty)) return 'Заполните город';
        return null;
      },
      'address_1': (value) {
        if ((value ?? '').isEmpty && (cDek.value || selectedShipping.value.isEmpty)) return 'Заполните адрес';
        return null;
      },
      'postcode': (value) {
        if ((value ?? '').isEmpty && cDek.value) return 'Заполните индекс';
        return null;
      },
      'inn': (value) {
        if (tab.value == 0) return null;
        if (value == null || value.isEmpty) {
          return 'Введите ИНН';
        } else if (value.length < 10 || value.length > 12) {
          return 'ИНН должно быть от 10 до 12 символов!';
        } else if (!RegExp(r'^\d+$').hasMatch(value)) {
          return 'ИНН должен содержать только цифры!';
        }
        return null;
      },
      'company': (value) {
        if (tab.value == 0) return null;
        if (value == null || value.isEmpty) return 'Поле Компания должно быть заполнено';
        return null;
      },
      'ogrn': (value) {
        if (tab.value == 0) return null;
        if (value == null || value.isEmpty) return 'Поле ОГРН должно быть заполнено';
        return null;
      },
      'rs': (value) {
        if (tab.value == 0) return null;
        if (value == null || value.isEmpty) return 'Поле "Номер расчетного счета" должно быть заполнено';
        return null;
      },
      'bank': (value) {
        if (tab.value == 0) return null;
        if (value == null || value.isEmpty) return 'Поле банк должно быть заполнено';
        return null;
      },
      'bik': (value) {
        if (tab.value == 0) return null;
        if (value == null || value.isEmpty) {
          return 'Поле БИК должно быть заполнено';
        } else if (value.length != 9) {
          return 'Поле БИК должно быть 9 символов';
        }
        return null;
      },
      'kpp': (value) {
        if (tab.value == 0) return null;
        if (value == null || value.isEmpty) {
          return 'Поле КПП должно быть заполнено';
        } else if (value.length != 9) {
          return 'Поле КПП должно быть 9 символов. Укажите 000000000 (9 нулей) если нет КПП';
        }
        return null;
      },
      'uraddress': (value) {
        if (tab.value == 0) return null;
        if (value == null || value.isEmpty) return 'Поле Юридический адрес должно быть заполнено';
        return null;
      },
      'email_buh': (value) {
        if (tab.value == 0) return null;
        String? item;

        if (value == null || value.isEmpty) item = 'Введите email';
        if (value != null && !EmailValidator.validate(value)) item = 'Некорректный email';

        return item;
      },
      'phone_buh': (value) {
        if (tab.value == 0) return null;
        if (value == null || value.isEmpty) {
          return 'Введите номер телефона';
        }

        String digits = value.replaceAll(RegExp(r'\D'), '');

        if (digits.length != 11 || !digits.startsWith('7')) {
          return 'Введите корректный номер';
        }

        return null;
      }
    };
  }

  saveField(String key, String val) {
    if (key == 'city') {
      searchC.value = val;
    }

    final fields = Helper.prefs.getString('checkout_fields') ?? '';
    Map<String, dynamic> items = {};

    if (fields.isEmpty) {
      items = {key: val};
    } else {
      items = jsonDecode(fields);

      if (items[key] != null) {
        items[key] = val;
      } else {
        items.putIfAbsent(key, () => val);
      }
    }

    Helper.prefs.setString('checkout_fields', jsonEncode(items));
  }

  Future initialize({bool update = false}) async {
    country.value = navController.countryId.value;

    if (update) {
      preload.value = true;
    }

    CheckoutApi.getCityCoordinates(navController.city.value).then((c) {
      if (c != null) {
        userLocation.value = c;
      }
    });

    isLoading2.value = false;
    isLoading.value = false;
    setValidation();

    final fields = Helper.prefs.getString('checkout_fields') ?? '';

    Map<String, dynamic> items = {};

    if (fields.isNotEmpty) {
      items = jsonDecode(fields);
    }

    errors.clear();

    fizControllers.forEach((e, v) {
      errors.putIfAbsent(e, () => GlobalKey<FormFieldState>());

      if (items[e] != null && e == 'telephone') {
        phoneField.value = PhoneNumber.parse(items[e]!);
      } else if (items[e] != null) {
        v.text = items[e]!;
      }
    });

    controllersAddress.forEach((e, v) {
      if (items[e] != null) {
        v.text = items[e]!;
      }
    });

    urControllers.forEach((e, v) {
      if (items[e] != null && e == 'phone_buh') {
        phoneBuhField.value = PhoneNumber.parse(items[e]!);
      } else if (items[e] != null) {
        v.text = items[e]!;
      }
    });

    acc.value = await CheckoutApi.getAccProducts();
    isLoading.value = true;

    CheckoutApi.getCheckout(navController.city.value, update, countryId: navController.countryId.value).then((e) {
      if (update) {
        preload.value = false;
      }

      if (e != null) {
        shipping.value = e.shipping;

        if (e.shipping.where((e) => e.code == 'bb').isNotEmpty) {
          CheckoutApi.getBBPvz().then((e) {
            bbItems.value = e;
          });
        }

        payment.value = e.payment;
        totals.value = e.totals;
        selectedShipping.value = e.shippingMethod;
        selectedPayment.value = e.paymentMethod;
        usePrepayment.value = e.usePrepayment;
        controllersAddress['city']?.text = navController.city.value;

        if (e.zoneId.isNotEmpty) {
          region.value = e.zoneId;
        }

        for (var s in shipping) {
          for (var i in s.quote) {
            if (e.shippingMethod == i.code && i.title.contains('пункта выдачи')) {
              cDek.value = true;
            }

            if (e.shippingMethod == i.code && (i.title.contains('о дверей') || i.title.contains('Курьерская доставка') || i.title.contains('курьером'))) {
              courier.value = true;
            }
          }
        }

        if (courier.value) {
          controllersAddress.forEach((e, v) {
            errors.putIfAbsent(e, () => GlobalKey<FormFieldState>());
          });
        }

        if (e.shipping.isNotEmpty && selectedShipping.value.isEmpty && e.shipping.first.quote.isNotEmpty) {
          selectedShipping.value = e.shipping.first.quote.first.code;
        }

        if (e.payment.isNotEmpty && selectedPayment.value.isEmpty) {
          selectedPayment.value = e.payment.first.code;
        }

        final more = e.shipping.firstWhereOrNull((e) => (e.more ?? []).isNotEmpty);

        if (more != null) {
          pvz.value = more.more ?? [];
        }
      } else {
        Helper.snackBar(error: true, text: 'Оформление заказа невозможно, попробуйте позже', callback2: () {
          navController.cartProducts.clear();
          final cart = Get.find<CartController>();
          cart.cartProducts.clear();
          CartApi.clear();
          Get.back();
        });
      }

      isLoading2.value = true;
    });

    final user = navController.user.value;

    if (user != null) {
      try {
        phoneField.value = PhoneNumber.parse(user.phone);
        phoneBuhField.value = PhoneNumber.parse(user.ur.phoneBuh);
      } catch(_) {
        //
      }

      fizControllers['firstname']!.text = user.firstname;
      fizControllers['lastname']!.text = user.lastname;
      fizControllers['email']!.text = user.email;
      urControllers['inn']!.text = user.ur.inn;
      urControllers['company']!.text = user.ur.company;
      urControllers['ogrn']!.text = user.ur.oGrn;
      urControllers['rs']!.text = user.ur.rs;
      urControllers['bank']!.text = user.ur.bank;
      urControllers['bik']!.text = user.ur.bik;
      urControllers['kpp']!.text = user.ur.kpp;
      urControllers['uraddress']!.text = user.ur.urAddress;
      urControllers['address_buh']!.text = user.ur.addressBuh;
      urControllers['email_buh']!.text = user.ur.emailBuh;

      if (user.ur.edo.isNotEmpty && ['ДИАДОК', 'СБИС', 'НЕТ'].contains(user.ur.edo)) {
        edo.value = user.ur.edo;
      }
    }

    ProfileApi.countries().then((val) {
      countries.value = val;
      regions.value = countries.firstWhereOrNull((e) => e.countryId == country.value)?.zone ?? <ZoneModel>[];
    });
  }

  Future setAddress(int id) async {
    addAddress.value = false;

    if (addressId.value == id) {
      return;
    }

    addressId.value = id;

    final api = await ProfileApi.setAddress(id);

    if (api != null) {
      navController.user.value = api;
      await setShipping();
    }
  }

  Future setCountry(String? id) async {
    if (id == null) return;
    country.value = id;
    region.value = null;
    regions.value = [];
    controllersAddress['city']!.text = '';
    controllersAddress['postcode']!.text = '';
    controllersAddress['address_1']!.text = '';

    for (var e in countries.where((e) => e.countryId == id && (e.zone ?? []).isNotEmpty)) {
      regions.addAll(e.zone!);
    }

    if (regions.isNotEmpty) {
      region.value = regions.first.zoneId;
      saveField('zone_id', regions.first.zoneId ?? '');
    }

    saveField('country_id', id);
  }

  Future updateCart(CartModel cart) async {
    preload.value = true;
    CartApi.updateCart({
      'key': cart.key,
      'quantity': '${cart.quantity}'
    }).then((e) {
      preload.value = false;
      navController.cartProducts.value = e;
      final cartC = Get.find<CartController>();
      cartC.cartProducts.value = e;

      if (cart.quantity == 0 && accAdd[cart.id] != null) {
        acc.insert(accAdd[cart.id] ?? 0, ProductModel(id: cart.id, title: cart.name, image: cart.image, category: '', model: '', color: cart.color));
        accAdd.remove(cart.id);
      }

      if (e.isEmpty) {
        Get.back();
      }
    });
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

  setTab(int index) {
    tab.value = index;
    setValidation();

    errors.clear();

    if (index == 0) {
      fizControllers.forEach((e, v) {
        errors.putIfAbsent(e, () => GlobalKey<FormFieldState>());
      });
    } else {
      urControllers.forEach((e, v) {
        errors.putIfAbsent(e, () => GlobalKey<FormFieldState>());
      });
    }
  }

  Future validateEmailX(String val) async {
    if (val.isNotEmpty && EmailValidator.validate(val)) {
      final api = await LoginApi.checkEmail(val);
      emailValidate.value = !api;
    } else {
      emailValidate.value = false;
    }
  }

  Future setPvz(Pvz val) async {
    selectedPvz.value = val;
    Quote? quote;

    for (var s in shipping) {
      if (quote != null) break;

      for (var i in s.quote) {
        if (i.code == selectedShipping.value) {
          quote = i;
          break;
        }
      }
    }

    if (quote != null) {
      setShipping();
    }

    Get.back();
    Get.back();
  }

  newAddress() async {
    if (addAddress.value) {
      if (formKeyAddress.currentState?.validate() ?? false) {
        if ((controllersAddress['city']?.text ?? '') != searchC.value || searchC.isEmpty) {
          Helper.snackBar(error: true, text: 'Выберите город из списка');
          return;
        }

        Map<String, dynamic> body = {};

        controllersAddress.forEach((key, controller) {
          if (controller.text.isNotEmpty) {
            body.putIfAbsent(key, () => controller.text);
          }
        });

        body.putIfAbsent('firstname', () => fizControllers['firstname']!.text);
        body.putIfAbsent('lastname', () => fizControllers['lastname']!.text);
        body.putIfAbsent('country_id', () => country.value);
        body.putIfAbsent('zone_id', () => region.value);
        body.putIfAbsent('default', () => '0');

        final api = await ProfileApi.saveAddress(body);

        if (api != null) {
          navController.user.value = api;
          addAddress.value = false;
          await setShipping();
        }
      }
    } else {
      addAddress.value = true;
      controllersAddress.forEach((key, controller) => controller.clear());
    }
  }

  Future setPrepayment(int val) async {
    if (prepayment.value == val) {
      return;
    }

    preload.value = true;
    prepayment.value = val;
    Helper.prefs.setInt('prepayment', val);

    CheckoutApi.setCheckout({
      'payment_method': selectedPayment.value,
      'prepayment': '${prepayment.value}',
      'countryId': navController.countryId.value,
      'shipping_method': selectedShipping.value,
      'bb_pvz_id': selectedBBPvz.value?.pvzId ?? '',
      'sdek_city': selectedPvz.value?.city ?? '',
      'sdek_pvz': selectedPvz.value?.code ?? '',
      'sdek_pvzinfo': (selectedPvz.value?.address ?? '') + ((selectedPvz.value?.phone ?? '').isNotEmpty ? ' tel:${selectedPvz.value!.phone}' : '')
    }).then((e) {
      preload.value = false;

      if (e != null) {
        shipping.value = e.shipping;
        payment.value = e.payment;
        totals.value = e.totals;
        usePrepayment.value = e.usePrepayment;

        if (e.zoneId.isNotEmpty) {
          region.value = e.zoneId;
        }

        for (var s in shipping) {
          for (var i in s.quote) {
            if (e.shippingMethod == i.code && i.title.contains('пункта выдачи')) {
              cDek.value = true;
            }

            if (e.shippingMethod == i.code && (i.title.contains('о дверей') || i.title.contains('Курьерская доставка') || i.title.contains('курьером'))) {
              courier.value = true;
            }
          }
        }

        if (!cDek.value) {
          selectedPvz.value = null;
          selectedBBPvz.value = null;
        }

        if (courier.value) {
          controllersAddress.forEach((e, v) {
            errors.putIfAbsent(e, () => GlobalKey<FormFieldState>());
          });
        }
      } else {
        Helper.snackBar(error: true, text: 'Сессия истекла, вам необходимо по новой добавить товары в корзину', callback2: () {
          Get.back();
        });
      }
    });
  }

  Future setShipping({bool address = false}) async {
    preload.value = true;
    cDek.value = false;
    courier.value = false;
    errors.clear();

    if (tab.value == 0) {
      fizControllers.forEach((e, v) {
        errors.putIfAbsent(e, () => GlobalKey<FormFieldState>());
      });
    } else {
      urControllers.forEach((e, v) {
        errors.putIfAbsent(e, () => GlobalKey<FormFieldState>());
      });
    }

    if (address) {
      controllersAddress.forEach((e, v) {
        errors.putIfAbsent(e, () => GlobalKey<FormFieldState>());
      });
    }

    if (errors.isNotEmpty) {
      Map<String, dynamic> body = {
        'payment_method': selectedPayment.value,
        'shipping_method': selectedShipping.value,
        'bb_pvz_id': selectedBBPvz.value?.pvzId ?? '',
        'sdek_city': selectedPvz.value?.city ?? '',
        'sdek_pvz': selectedPvz.value?.code ?? '',
        'sdek_pvzinfo': (selectedPvz.value?.address ?? '') + ((selectedPvz.value?.phone ?? '').isNotEmpty ? ' tel:${selectedPvz.value!.phone}' : '')
      };

      if (address) {
        controllersAddress.forEach((key, controller) {
          if (controller.text.isNotEmpty) {
            body.putIfAbsent(key, () => controller.text);
          }
        });

        body.putIfAbsent('firstname', () => fizControllers['firstname']!.text);
        body.putIfAbsent('lastname', () => fizControllers['lastname']!.text);
        body.putIfAbsent('country_id', () => country.value);
        body.putIfAbsent('zone_id', () => region.value);
        body.putIfAbsent('default', () => '0');
      }

      if (usePrepayment.value) {
        body.putIfAbsent('prepayment', () => '${prepayment.value}');
      }

      CheckoutApi.setCheckout(body).then((e) {
        preload.value = false;

        if (e != null) {
          shipping.value = e.shipping;
          payment.value = e.payment;
          totals.value = e.totals;
          usePrepayment.value = e.usePrepayment;

          if (e.zoneId.isNotEmpty) {
            region.value = e.zoneId;
          }

          for (var s in shipping) {
            for (var i in s.quote) {
              if (e.shippingMethod == i.code && i.title.contains('пункта выдачи')) {
                cDek.value = true;
              }

              if (e.shippingMethod == i.code && (i.title.contains('о дверей') || i.title.contains('Курьерская доставка') || i.title.contains('курьером'))) {
                courier.value = true;
              }
            }
          }

          if (!cDek.value) {
            selectedPvz.value = null;
            selectedBBPvz.value = null;
          }

          if (courier.value) {
            controllersAddress.forEach((e, v) {
              errors.putIfAbsent(e, () => GlobalKey<FormFieldState>());
            });
          }
        } else {
          Helper.snackBar(error: true, text: 'Сессия истекла, вам необходимо по новой добавить товары в корзину', callback2: () {
            Get.back();
          });
        }
      });
    }
  }

  Future bbCallback(BBItemModel pvz) async {
    selectedPvz.value = null;
    final api = await CheckoutApi.setBbPvz(pvz.pvzId);

    if (api != null) {
      selectedBBPvz.value = pvz;
      controllersAddress['city']!.text = api.city;
      region.value = '${api.zoneId}';
      controllersAddress['address_1']!.text = api.address;
      await setShipping();
      Get.back();
      Get.back();
    } else {
      Helper.snackBar(error: true, text: 'Невозможно выбрать данный ПВЗ', callback2: Get.back);
    }
  }

  Future setPayment(PaymentModel val) async {
    if (selectedPayment.value == val.code) {
      return;
    }

    preload.value = true;
    selectedPayment.value = val.code;

    Map<String, dynamic> body = {
      'payment_method': val.code,
      'shipping_method': selectedShipping.value,
      'bb_pvz_id': selectedBBPvz.value?.pvzId ?? '',
      'countryId': navController.countryId.value,
      'sdek_city': selectedPvz.value?.city ?? '',
      'sdek_pvz': selectedPvz.value?.code ?? '',
      'sdek_pvzinfo': (selectedPvz.value?.address ?? '') + ((selectedPvz.value?.phone ?? '').isNotEmpty ? ' tel:${selectedPvz.value!.phone}' : '')
    };

    if (usePrepayment.value) {
      body.putIfAbsent('prepayment', () => '${prepayment.value}');
    }

    CheckoutApi.setCheckout(body).then((e) {
      preload.value = false;

      if (e != null) {
        shipping.value = e.shipping;
        payment.value = e.payment;
        totals.value = e.totals;
        usePrepayment.value = e.usePrepayment;

        if (e.zoneId.isNotEmpty) {
          region.value = e.zoneId;
        }

        for (var s in shipping) {
          for (var i in s.quote) {
            if (e.shippingMethod == i.code && i.title.contains('пункта выдачи')) {
              cDek.value = true;
            }

            if (e.shippingMethod == i.code && (i.title.contains('о дверей') || i.title.contains('Курьерская доставка') || i.title.contains('курьером'))) {
              courier.value = true;
            }
          }
        }

        if (!cDek.value) {
          selectedPvz.value = null;
          selectedBBPvz.value = null;
        }

        if (courier.value) {
          controllersAddress.forEach((e, v) {
            errors.putIfAbsent(e, () => GlobalKey<FormFieldState>());
          });
        }
      } else {
        Helper.snackBar(error: true, text: 'Сессия истекла, вам необходимо по новой добавить товары в корзину', callback2: () {
          Get.back();
        });
      }
    });
  }

  Future checkout() async {
    if (!agree.value) {
      Helper.snackBar(error: true, text: 'Необходимо принять условия и политику обработки');
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      if (cDek.value && selectedPvz.value == null && selectedBBPvz.value == null) {
        Helper.snackBar(error: true, text: 'Выберите ПВЗ');
        return;
      }

      var courier = false;

      for (var i in shipping) {
        for (var e in i.quote) {
          if (selectedShipping.value == e.code && (e.title.contains('о дверей') || e.title.contains('урьером'))) {
            courier = true;
            break;
          }
        }

        if (courier) break;
      }

      if (courier && ((navController.user.value != null && addressId.value == 0) || (country.value == null && region.value == null && (controllersAddress['city']?.text ?? '').isEmpty) && (controllersAddress['address_1']?.text ?? '').isEmpty)) {
        Helper.snackBar(error: true, text: navController.user.value == null ? 'Добавьте адрес' : 'Выберите или создайте новый адрес');
        return;
      }

      Map<String, dynamic> body = {};

      controllersAddress.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          body.putIfAbsent(key, () => controller.text);
        }
      });
      fizControllers.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          body.putIfAbsent(key, () => controller.text);
        }
        if (key == 'telephone') {
          body.putIfAbsent(key, () => '+${phoneField.value.countryCode}${phoneField.value.nsn}');
        }
      });
      urControllers.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          body.putIfAbsent(key, () => controller.text);
        }
        if (key == 'phone_buh' && phoneBuhField.value.nsn.isNotEmpty) {
          body.putIfAbsent(key, () => '+${phoneBuhField.value.countryCode}${phoneBuhField.value.nsn}');
        }
      });

      body.putIfAbsent('customer_group_id', () => tab.value == 0 ? '8' : '9');
      body.putIfAbsent('country_id', () => country.value);
      body.putIfAbsent('zone_id', () => region.value);
      body.putIfAbsent('comment', () => commentField.text);
      body.putIfAbsent('shipping_method', () => selectedShipping.value);
      body.putIfAbsent('payment_method', () => selectedPayment.value);

      if (addressId.value > 0) {
        body.putIfAbsent('address_id', () => '${addressId.value}');
      }

      if (usePrepayment.value) {
        body.putIfAbsent('prepayment', () => '${prepayment.value}');
      }

      final api = await CheckoutApi.checkout(body);

      if (api != null) {
        order.value = api;
        isPayLoad.value = false;

        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            child: PaymentView(order: order.value!)
          )
        );
      }
    } else {
      bool errVisible = false;

      errors.forEach((e, v) {
        if ((v.currentState?.hasError ?? false) && !errVisible) {
          errVisible = true;

          Scrollable.ensureVisible(
            v.currentContext!,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut
          );
        }
      });
    }
  }

  setSuccess() async {
    success.value = true;
    setOrder.value = await OrderApi.getOrder(order.value!.orderId);
    CartApi.clear();
    navController.cartProducts.clear();
    final cart = Get.find<CartController>();
    cart.cartProducts.clear();
    Get.back();
  }

  Future<List<Location>> suggestionsCallback(String pattern) async {
    if (pattern.isEmpty || suggestionSelected.value) return [];
    return await HomeApi.searchCity(pattern, countryId: country.value ?? navController.countryId.value, level: 1);
  }

  Future getPayStatus(String id) async {
    final api = await CheckoutApi.getPayStatus(id);

    if (api) {
      setSuccess();
    }
  }

  Future<List<String>> suggestionsCallback2(String pattern) async {
    var c = '';

    if (controllersAddress['city'] != null && controllersAddress['city']!.text.isNotEmpty) {
      c = controllersAddress['city']!.text;

      if (c.contains(', ')) {
        c = c.split(',').first.trim();
      }

      pattern = '$c $pattern'.trim();
    }

    return await HomeApi.searchAddress(pattern, c, countries.firstWhereOrNull((e) => e.countryId == (country.value ?? navController.countryId.value))?.name ?? 'Россия');
  }
}