import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawmid/api/cart.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/controller/cart.dart';
import 'package:rawmid/controller/club.dart';
import 'package:rawmid/controller/home.dart';
import 'package:rawmid/controller/wishlist.dart';
import 'package:rawmid/model/catalog/category.dart';
import 'package:rawmid/model/city.dart';
import 'package:rawmid/model/location.dart';
import 'package:rawmid/screen/product/product.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/home.dart';
import '../api/product.dart';
import '../model/cart.dart';
import '../model/home/news.dart';
import '../model/home/product.dart';
import '../model/profile/profile.dart';
import '../screen/cart/cart.dart';
import '../screen/catalog/catalog.dart';
import '../screen/club/club.dart';
import '../screen/home/home.dart';
import '../screen/wishlist/wishlist.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'catalog.dart';

class NavigationController extends GetxController {
  TabController? tabController;
  RxInt activeTab = 0.obs;
  final List<Widget> widgetOptions = <Widget>[
    const HomeView(),
    const CatalogView(),
    const WishlistView(),
    const CartView(),
    const ClubView()
  ];
  final List<String> titles = [
    'Главная',
    'Каталог',
    'Избранное',
    'Корзина',
    'Клуб'
  ];
  RxBool reset = false.obs;
  Rxn<ProfileModel> user = Rxn<ProfileModel>();
  RxInt fId = (Helper.prefs.getInt('fias_id') ?? 0).obs;
  RxString city = (Helper.prefs.getString('city') ?? '').obs;
  RxString countryCode = (Helper.prefs.getString('countryCode') ?? '').obs;
  RxString countryId = (Helper.prefs.getString('countryId') ?? '').obs;
  RxString zoneId = (Helper.prefs.getString('zoneId') ?? '').obs;
  RxString searchCity = ''.obs;
  RxList<CityModel> filteredCities = <CityModel>[].obs;
  RxList<Location> filteredLocation = <Location>[].obs;
  RxList<CityModel> cities = <CityModel>[].obs;
  RxList<CartModel> cartProducts = <CartModel>[].obs;
  RxList<ProductModel> searchProducts = <ProductModel>[].obs;
  RxList<CategoryModel> searchCategories = <CategoryModel>[].obs;
  RxList<NewsModel> searchNews = <NewsModel>[].obs;
  late stt.SpeechToText speech;
  RxBool isListening = false.obs;
  RxBool isAvailable = false.obs;
  RxBool loadImage = false.obs;
  RxBool isSearch = false.obs;
  RxString searchText = ''.obs;
  RxList<String> wishlist = (Helper.prefs.getStringList('wishlist') ?? <String>[]).obs;
  Rxn<File> imageFile = Rxn<File>();
  final ImagePicker picker = ImagePicker();

  onItemTapped(int index) {
    searchProducts.clear();
    searchNews.clear();
    searchCategories.clear();
    activeTab.value = index;

    if (tabController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tabController?.animateTo(index);
      });
    }
  }

  void resetV() {
    reset.value = true;
  }

  Future changeCity(CityModel val, {bool not = true}) async {
    if (fId.value == val.id && not) {
      Get.back();
      return;
    }

    final code = await HomeApi.changeCity(val.id);

    if (code['code'] != null) {
      countryCode.value = code['code'];
      Helper.prefs.setString('countryCode', code['code']);
    }

    if (code['zone_id'] != null) {
      zoneId.value = code['zone_id'];
      Helper.prefs.setString('zoneId', code['zone_id']);
    }

    if (code['country_id'] != null) {
      countryId.value = code['country_id'];
      Helper.prefs.setString('countryId', code['country_id']);
    }

    Helper.prefs.setString('city', val.name);
    Helper.prefs.setInt('fias_id', val.id);
    fId.value = val.id;
    city.value = val.name;

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().initialize();
    }

    if (Get.isRegistered<CatalogController>()) {
      Get.find<CatalogController>().initialize();
    }

    if (Get.isRegistered<WishlistController>()) {
      Get.find<WishlistController>().initialize();
    }

    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().initialize();
    }

    if (Get.isRegistered<ClubController>()) {
      Get.find<ClubController>().initialize();
    }

    if (not) {
      Get.back();
    }
  }

  Future filterCities(String val) async {
    searchCity.value = val;

    if (val.isNotEmpty) {
      final query = val.toLowerCase();
      final api = await HomeApi.searchCity(query, level: 1);
      filteredLocation.value = api;
      filteredCities.value = [];
    } else {
      filteredLocation.value = [];
      filteredCities.value = cities;
    }
  }

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    if (Get.parameters['tab'] != null) {
      onItemTapped(int.tryParse('${Get.parameters['tab']}') ?? 0);
      return;
    }

    CartApi.getProducts().then((e) => cartProducts.value = e);

    if (city.isEmpty) {
      if (Get.arguments != null) {
        city.value = Get.arguments['city'] ?? '';
        countryCode.value = Get.arguments['countryCode'] ?? 'KZ';
      } else {
        final api = await HomeApi.getCityByIP();

        if (api.isNotEmpty) {
          city.value = api['city'] ?? '';
          countryCode.value = api['countryCode'] ?? 'KZ';
        }
      }

      if (countryId.isEmpty && city.isNotEmpty) {
        final code = await HomeApi.changeCityByCity(city.value);

        if (code['code'] != null) {
          countryCode.value = code['code'];
          Helper.prefs.setString('countryCode', code['code']);
        }

        if (code['zone_id'] != null) {
          zoneId.value = code['zone_id'];
          Helper.prefs.setString('zoneId', code['zone_id']);
        }

        if (code['country_id'] != null) {
          countryId.value = code['country_id'];
          Helper.prefs.setString('countryId', code['country_id']);
        }
      }
    } else if (fId.value > 0) {
      final code = await HomeApi.changeCity(fId.value);

      if (code['code'] != null) {
        countryCode.value = code['code'];
        Helper.prefs.setString('countryCode', code['code']);
      }

      if (code['zone_id'] != null) {
        zoneId.value = code['zone_id'];
        Helper.prefs.setString('zoneId', code['zone_id']);
      }

      if (code['country_id'] != null) {
        countryId.value = code['country_id'];
        Helper.prefs.setString('countryId', code['country_id']);
      }
    }

    user.value = await ProfileApi.user();

    if (user.value != null) {
      CartApi.getWishlist().then((e) {
        if (e.isNotEmpty || wishlist.isEmpty) {
          wishlist.value = e;
          Helper.prefs.setStringList('wishlist', e);
        }
      });
    }

    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();

      if (home.achieviment.value != null) {
        home.achieviment.value!.rang = user.value?.rang ?? 0;
      }
    }

    await loadJsonFromAssets();
    filteredCities.value = cities;

    speech = stt.SpeechToText();

    bool available = await speech.initialize(
        onStatus: (status) {
          isListening.value = status == 'listening';

          if (status == 'done') {
            search(searchText.value);
          }
        },
        onError: (error) => debugPrint('Ошибка: $error')
    );

    if (available) {
      isAvailable.value = true;
    }
  }

  Future addCart(String id, {bool k = false, bool c = false}) async {
    if (Get.currentRoute != '/ProductView' && !c) {
      final colors = await CartApi.getColors(id);

      if (colors) {
        Get.to(() => ProductView(id: id));
        return;
      }
    }

    final api = await CartApi.addCart({
      'product_id': id
    });
    cartProducts.value = api;

    if (k) {
      final kre = Helper.prefs.getStringList('product_kre') ?? [];
      kre.add(id);
      Helper.prefs.setStringList('product_kre', kre);
    }

    if (Get.isRegistered<CartController>()) {
      final cart = Get.find<CartController>();
      cart.cartProducts.value = api;
      cart.update();
    }
  }

  bool isCart(String id, {bool? k}) {
    if (k != null) {
      final kre = Helper.prefs.getStringList('product_kre') ?? [];

      if (k) {
        return cartProducts.where((e) => e.id == id).isNotEmpty && kre.contains(id);
      } else {
        return cartProducts.where((e) => e.id == id).isNotEmpty && !kre.contains(id);
      }
    }
    
    return cartProducts.where((e) => e.id == id).isNotEmpty;
  }

  Future clear() async {
    await CartApi.clear();
    cartProducts.clear();

    if (Get.isRegistered<CartController>()) {
      final cart = Get.find<CartController>();
      cart.cartProducts.clear();
      cart.update();
    }
  }

  Future<bool> addChainCart(Map<String, dynamic> body) async {
    final api = await ProductApi.addChainCart(body);
    cartProducts.value = api;
    return api.isNotEmpty;
  }

  Future search(String val) async {
    if (!isSearch.value) {
      if (val.isEmpty) {
        searchProducts.clear();
        searchNews.clear();
        searchCategories.clear();
        return;
      }

      final api = await HomeApi.search(val);

      if (api != null) {
        searchCategories.value = api.categories;
        searchProducts.value = api.products;
        searchNews.value = api.news;

        Future.delayed(Duration(seconds: 2), () {
          if (searchCategories.isEmpty && searchProducts.isEmpty && searchNews.isEmpty) {
            searchText.value = '';
          }
        });
      }
    }
  }

  clearSearch() {
    searchCategories.clear();
    searchProducts.clear();
    searchNews.clear();
    searchText.value = '';
    Helper.closeKeyboard();
  }

  Future<void> startListening(TextEditingController c, FocusNode f, BuildContext context) async {
    searchText.value = '';
    isSearch.value = true;

    if (isAvailable.value) {
      isListening.value = true;

      speech.listen(
          onResult: (result) {
            searchText.value = result.recognizedWords;

            if (result.finalResult) {
              if (searchText.value.isEmpty) {
                searchCategories.clear();
                searchProducts.clear();
                searchNews.clear();
                Helper.snackBar(error: true, text: 'Текст не распознан, попробуйте еще раз');
                return;
              }

              HomeApi.search(searchText.value).then((api) {
                if (api != null) {
                  searchCategories.value = api.categories;
                  searchProducts.value = api.products;
                  searchNews.value = api.news;

                  if (context.mounted) {
                    FocusScope.of(context).requestFocus(f);
                    isSearch.value = false;
                    c.text = searchText.value;
                  }

                  Future.delayed(Duration(seconds: 2), () {
                    if (searchCategories.isEmpty && searchProducts.isEmpty && searchNews.isEmpty) {
                      searchText.value = '';
                      c.text = '';
                    }
                  });
                }
              });
            }
          }
      );
    }
  }

  Future stopListening() async {
    speech.stop();
    isListening.value = false;
    isSearch.value = false;
  }

  Future loadJsonFromAssets() async {
    final String jsonString = await rootBundle.loadString('assets/city.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);

    for (var i in jsonData) {
      cities.add(CityModel.fromJson(i));
    }
  }

  Future logout() async {
    ProfileApi.logout();
    user.value = null;
    cartProducts.clear();
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().cartProducts.clear();
    }
    await Helper.prefs.setString('PHPSESSID', '');
    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      home.initialize();
    }
    onItemTapped(0);
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
}