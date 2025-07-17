import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../api/product.dart';
import '../model/home/product.dart';
import '../model/product/review.dart';

class ReviewsController extends GetxController {
  ProductModel product;
  ReviewsController(this.product);
  RxBool isLoading = false.obs;
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  RxInt isChecked = (-1).obs;
  var keys = <GlobalKey>[].obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    reviews.value = await ProductApi.getReviews(product.id, mes: false);

    for (var _ in reviews) {
      keys.add(GlobalKey());
    }

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