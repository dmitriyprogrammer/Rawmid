import 'dart:async';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/model/profile/address.dart';
import '../api/home.dart';
import '../api/login.dart';
import '../model/country.dart';
import '../model/location.dart';
import '../model/profile/profile.dart';
import '../utils/helper.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool loadImage = false.obs;
  RxBool addressDef = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool changePassValid = false.obs;
  final TextEditingController changePasswordField = TextEditingController();
  final navController = Get.find<NavigationController>();
  Rxn<ProfileModel> user = Rxn<ProfileModel>();
  RxBool newsSubscription = false.obs;
  RxBool pushNotifications = false.obs;
  RxBool edit = false.obs;
  RxBool addAddress = false.obs;
  RxInt tab = 0.obs;
  RxInt addressId = 0.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyAddress = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'telephone': TextEditingController(),
    'email': TextEditingController(),
    'lastname': TextEditingController(),
    'firstname': TextEditingController()
  };
  final phoneField = PhoneController(initialValue: const PhoneNumber(isoCode: IsoCode.RU, nsn: ''));
  final phoneBuhField = PhoneController(initialValue: const PhoneNumber(isoCode: IsoCode.RU, nsn: ''));
  final Map<String, TextEditingController> controllersAddress = {
    'city': TextEditingController(),
    'postcode': TextEditingController(),
    'address_1': TextEditingController()
  };
  var controllersAddress2 = <String, Map<String, TextEditingController>>{}.obs;
  var focusNodeAddress2 = <String, Map<String, FocusNode>>{}.obs;
  var editAddress = <String, bool>{}.obs;
  var delAddress = <String, bool>{}.obs;
  final Map<String, TextEditingController> controllerUr = {
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
  final Map<String, FocusNode> focusNodeUrAddress = {
    'inn': FocusNode(),
    'company': FocusNode(),
    'ogrn': FocusNode(),
    'rs': FocusNode(),
    'bank': FocusNode(),
    'bik': FocusNode(),
    'kpp': FocusNode(),
    'uraddress': FocusNode(),
    'email_buh': FocusNode(),
    'phone_buh': FocusNode()
  };
  final Map<String, FocusNode> focusNodeAddress = {
    'city': FocusNode(),
    'postcode': FocusNode(),
    'address_1': FocusNode()
  };
  final Map<String, FocusNode> focusNodes = {
    'telephone': FocusNode(),
    'email': FocusNode(),
    'lastname': FocusNode(),
    'firstname': FocusNode()
  };
  RxString activeField = ''.obs;
  Rxn<String> region = Rxn<String>('2760');
  RxString country = '176'.obs;
  var address = <String, AddressModel>{}.obs;
  var addressFormKey = <String, GlobalKey<FormState>>{}.obs;
  var addressRegions = <String, List<ZoneModel>>{}.obs;
  RxList<CountryModel> countries = <CountryModel>[].obs;
  RxList<ZoneModel> regions = <ZoneModel>[].obs;
  Rxn<File> imageFile = Rxn<File>();
  final ImagePicker picker = ImagePicker();
  final scrollController = ScrollController();
  RxMap<String, String? Function(String?)> validators = <String, String? Function(String?)>{}.obs;
  RxBool usEmailValidate = false.obs;
  RxBool fizEmailValidate = false.obs;
  Rxn<String> edo = Rxn();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future validateEmailX(String val) async {
    if (val.isNotEmpty && EmailValidator.validate(val)) {
      final api = await LoginApi.checkEmail(val);

      if (tab.value == 1) {
        usEmailValidate.value = !api;
      } else {
        fizEmailValidate.value = !api;
      }
    } else {
      fizEmailValidate.value = false;
      usEmailValidate.value = false;
    }
  }

  @override
  void dispose() {
    changePasswordField.dispose();
    controllers.forEach((key, controller) => controller.dispose());
    controllersAddress.forEach((key, controller) => controller.dispose());
    controllerUr.forEach((key, controller) => controller.dispose());
    focusNodes.forEach((key, focusNode) => focusNode.dispose());
    focusNodeAddress.forEach((key, focusNode) => focusNode.dispose());
    focusNodeUrAddress.forEach((key, focusNode) => focusNode.dispose());
    address.clear();
    addressRegions.clear();
    controllersAddress2.forEach((key, map) => map.forEach((k, v) => v.dispose()));
    focusNodeAddress2.forEach((key, map) => map.forEach((k, v) => v.dispose()));
    super.dispose();
  }

  setTab(int index) {
    tab.value = index;

    scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut
    );
  }

  Future initialize() async {
    validators.value = {
      'telephone': (value) {
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
        String? item;

        if (value == null || value.isEmpty) item = 'Введите email';
        if (value != null && !EmailValidator.validate(value)) item = 'Некорректный email';

        return item;
      },
      'firstname': (value) {
        if (value == null || value.isEmpty) return 'Введите имя';
        return null;
      },
      'lastname': (value) {
        if (value == null || value.isEmpty) return 'Введите фамилию';
        return null;
      },
      'city': (value) {
        if (value == null || value.isEmpty) return 'Заполните город';
        return null;
      },
      'address_1': (value) {
        if (value == null || value.isEmpty) return 'Заполните адрес';
        return null;
      },
      'postcode': (value) {
        if (value == null || value.isEmpty) return 'Заполните индекс';
        return null;
      },
      'inn': (value) {
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
        if (value == null || value.isEmpty) return 'Поле Компания должно быть заполнено';
        return null;
      },
      'ogrn': (value) {
        if (value == null || value.isEmpty) return 'Поле ОГРН должно быть заполнено';
        return null;
      },
      'rs': (value) {
        if (value == null || value.isEmpty) return 'Поле "Номер расчетного счета" должно быть заполнено';
        return null;
      },
      'bank': (value) {
        if (value == null || value.isEmpty) return 'Поле банк должно быть заполнено';
        return null;
      },
      'bik': (value) {
        if (value == null || value.isEmpty) {
          return 'Поле БИК должно быть заполнено';
        } else if (value.length != 9) {
          return 'Поле БИК должно быть 9 символов';
        }
        return null;
      },
      'kpp': (value) {
        if (value == null || value.isEmpty) {
          return 'Поле КПП должно быть заполнено';
        } else if (value.length != 9) {
          return 'Поле КПП должно быть 9 символов. Укажите 000000000 (9 нулей) если нет КПП';
        }
        return null;
      },
      'uraddress': (value) {
        if (value == null || value.isEmpty) return 'Поле Юридический адрес должно быть заполнено';
        return null;
      },
      'email_buh': (value) {
        String? item;

        if (value == null || value.isEmpty) item = 'Введите email';
        if (value != null && !EmailValidator.validate(value)) item = 'Некорректный email';

        return item;
      },
      'phone_buh': (value) {
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

    focusNodes.forEach((key, focusNode) {
      focusNode.addListener(() {
        activeField.value = focusNode.hasFocus ? key : '';
      });
    });

    final api = await getUser();

    if (api != null) {
      user.value = api;
      newsSubscription.value = api.subscription;
      pushNotifications.value = api.push;
      try {
        phoneField.value = PhoneNumber.parse(api.phone);
        phoneBuhField.value = PhoneNumber.parse(api.ur.phoneBuh);
      } catch(_) {
        //
      }

      controllers['firstname']!.text = api.firstname;
      controllers['lastname']!.text = api.lastname;
      controllers['email']!.text = api.email;
      controllerUr['inn']!.text = api.ur.inn;
      controllerUr['company']!.text = api.ur.company;
      controllerUr['ogrn']!.text = api.ur.oGrn;
      controllerUr['rs']!.text = api.ur.rs;
      controllerUr['bank']!.text = api.ur.bank;
      controllerUr['bik']!.text = api.ur.bik;
      controllerUr['kpp']!.text = api.ur.kpp;
      controllerUr['uraddress']!.text = api.ur.urAddress;
      controllerUr['address_buh']!.text = api.ur.addressBuh;
      controllerUr['email_buh']!.text = api.ur.emailBuh;
      if (api.ur.edo.isNotEmpty && ['ДИАДОК', 'СБИС', 'НЕТ'].contains(api.ur.edo)) {
        edo.value = api.ur.edo;
      }
      tab.value = api.type ? 1 : 0;
    } else {
      Helper.prefs.setString('PHPSESSID', '');
      ProfileApi.logout();
      Get.offAllNamed('login');
    }

    ProfileApi.countries().then((val) {
      countries.value = val;
      regions.value = countries.firstWhereOrNull((e) => e.countryId == country.value)?.zone ?? <ZoneModel>[];

      address.clear();
      addressRegions.clear();
      controllersAddress2.clear();
      focusNodeAddress2.clear();

      if (user.value != null) {
        for (var i in user.value!.address) {
          editAddress.putIfAbsent('${i.id}', () => false);

          controllersAddress2.putIfAbsent('${i.id}', () => {
            'city': TextEditingController(),
            'postcode': TextEditingController(),
            'address_1': TextEditingController()
          });

          focusNodeAddress2.putIfAbsent('${i.id}', () => {
            'city': FocusNode(),
            'postcode': FocusNode(),
            'address_1': FocusNode()
          });

          address.putIfAbsent('${i.id}', () => i);
          addressFormKey.putIfAbsent('${i.id}', () => GlobalKey<FormState>());
          var zones = <ZoneModel>[];

          for (var e in countries.where((e) => e.countryId == i.countryId && (e.zone ?? []).isNotEmpty)) {
            zones.addAll(e.zone!);
          }

          addressRegions.putIfAbsent('${i.id}', () => zones);
        }
      }
    });

    isLoading.value = true;
  }

  Future setAddress(int id) async {
    addressId.value = id;
    final api = await ProfileApi.setAddress(id);

    if (api != null) {
      user.value = api;
    }
  }

  Future setCountry(String? id) async {
    if (id == null) return;
    country.value = id;
    region.value = null;
    regions.value = [];

    for (var e in countries.where((e) => e.countryId == id && (e.zone ?? []).isNotEmpty)) {
      regions.addAll(e.zone!);
    }

    if (regions.isNotEmpty) {
      region.value = regions.first.zoneId;
    }
  }

  Future setCountry2(String? id, String addressId) async {
    if (id == null) return;
    address[addressId]!.countryId = id;
    region.value = null;
    regions.value = [];

    for (var e in countries.where((e) => e.countryId == id && (e.zone ?? []).isNotEmpty)) {
      regions.addAll(e.zone!);
    }

    if (regions.isNotEmpty) {
      region.value = regions.first.zoneId;
    }
  }

  Future delete() async {
    final api = await ProfileApi.delete();

    if (!api) {
      Helper.snackBar(error: true, text: 'Ошибка удаления аккаунта');
    } else {
      Helper.prefs.setString('PHPSESSID', '');
      Get.offAllNamed('home');
    }
  }

  Future changePass() async {
    if (changePasswordField.text.isNotEmpty) {
      final api = await ProfileApi.changePass(changePasswordField.text);

      if (!api) {
        Helper.snackBar(error: true, text: 'Ошибка смены пароля');
      } else {
        Helper.snackBar(error: true, text: 'Пароль успешно изменен');
        changePasswordField.clear();
      }
    }
  }

  Future setNewsletter(bool val) async {
    final api = await ProfileApi.setNewsletter(val);

    if (!api) {
      if (val) {
        newsSubscription.value = !val;
      }

      Helper.snackBar(error: true, text: 'Произошла ошибка, попробуйте позже');
    }
  }

  Future setPush(bool val) async {
    final api = await ProfileApi.setPush(val);

    if (!api) {
      if (val) {
        pushNotifications.value = !val;
      }

      Helper.snackBar(error: true, text: 'Произошла ошибка, попробуйте позже');
    }
  }

  editAddr(String id) async {
    if (addressFormKey[id]?.currentState?.validate() ?? false) {
      Map<String, dynamic> body = {};

      controllersAddress2[id]?.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          body.putIfAbsent(key, () => controller.text);
        }
      });

      body.putIfAbsent('firstname', () => controllers['firstname']!.text);
      body.putIfAbsent('lastname', () => controllers['lastname']!.text);
      body.putIfAbsent('country_id', () => address[id]?.countryId);
      body.putIfAbsent('zone_id', () => address[id]?.zoneId);
      body.putIfAbsent('address_id', () => id);
      body.putIfAbsent('default', () => '${addressDef.value ? 1 : 0}');

      final api = await ProfileApi.saveAddress(body);

      if (api != null) {
        user.value = api;
        editAddress[id] = false;
      }
    }
  }

  deleteAddress(String id) async {
    delAddress.putIfAbsent(id, () => true);
    final api = await ProfileApi.deleteAddress(id);
    user.value = api;
    delAddress.putIfAbsent(id, () => false);
  }

  newAddress() async {
    if (addAddress.value) {
      if (formKeyAddress.currentState?.validate() ?? false) {
        Map<String, dynamic> body = {};

        controllersAddress.forEach((key, controller) {
          if (controller.text.isNotEmpty) {
            body.putIfAbsent(key, () => controller.text);
          }
        });

        body.putIfAbsent('firstname', () => controllers['firstname']!.text);
        body.putIfAbsent('lastname', () => controllers['lastname']!.text);
        body.putIfAbsent('country_id', () => country.value);
        body.putIfAbsent('zone_id', () => region.value);
        body.putIfAbsent('default', () => '${addressDef.value ? 1 : 0}');

        final api = await ProfileApi.saveAddress(body);

        if (api != null) {
          user.value = api;
          addAddress.value = false;
        }
      }
    } else {
      addAddress.value = true;
      controllersAddress.forEach((key, controller) => controller.clear());
    }
  }

  Future save() async {
    if (formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> body = {};
      controllers.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          if (key == 'telephone') {
            body.putIfAbsent(key, () => '+${phoneField.value.countryCode}${phoneField.value.nsn}');
          } else {
            body.putIfAbsent(key, () => controller.text);
          }
        }
      });
      body.putIfAbsent('customer_group_id', () => '8');
      Helper.closeKeyboard();

      final api = await ProfileApi.save(body);

      if (api != null) {
        user.value = api;
      }

      edit.value = false;
    }
  }

  Future saveUz() async {
    if (formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> body = {};
      controllerUr.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          if (key == 'telephone_buh') {
            body.putIfAbsent('telephone_buh', () => '+${phoneBuhField.value.countryCode}${phoneBuhField.value.nsn}');
          } else {
            body.putIfAbsent(key, () => controller.text);
          }
        }
      });
      body.putIfAbsent('customer_group_id', () => '9');
      Helper.closeKeyboard();
      final api = await ProfileApi.save(body);

      if (api != null) {
        user.value = api;
      }

      edit.value = false;
    }
  }

  Future<ProfileModel?> getUser() async {
    return await ProfileApi.user();
  }

  Future pickImage(ImageSource source) async {
    loadImage.value = true;
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final api = await ProfileApi.uploadImage(File(pickedFile.path));

      if (api) {
        imageFile.value = File(pickedFile.path);
      }
    }

    loadImage.value = false;
  }

  Future<List<Location>> suggestionsCallback(String pattern) async {
    if (pattern.isEmpty) return [];
    return await HomeApi.searchCity(pattern);
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

    return await HomeApi.searchAddress(pattern, c, countries.firstWhereOrNull((e) => e.countryId == country.value)?.name ?? 'Россия');
  }

  Future<List<String>> suggestionsCallback3(String pattern, String id) async {
    var c = '';

    if (controllersAddress2[id]?['city'] != null && controllersAddress2[id]!['city']!.text.isNotEmpty) {
      c = controllersAddress2[id]!['city']!.text;

      if (c.contains(', ')) {
        c = c.split(',').first.trim();
      }

      pattern = '$c $pattern'.trim();
    }

    return await HomeApi.searchAddress(pattern, c, countries.firstWhereOrNull((e) => e.countryId == country.value)?.name ?? 'Россия');
  }
}