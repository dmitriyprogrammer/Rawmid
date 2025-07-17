import 'package:get/get.dart';
import 'package:rawmid/api/profile.dart';
import 'package:rawmid/controller/navigation.dart';
import '../model/home/product.dart';

class UserReviewsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxInt isChecked = (-1).obs;
  final navController = Get.find<NavigationController>();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    products.value = await ProfileApi.getReviews();
    isLoading.value = true;
  }

  String formatDateCustom(DateTime date) {
    List<String> months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];

    int day = date.day;
    String month = months[date.month - 1];
    int year = date.year;

    return "$day $month $year";
  }
}