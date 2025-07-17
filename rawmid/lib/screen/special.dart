import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/screen/wishlist/product_card.dart';
import 'package:rawmid/utils/constant.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../../widget/h.dart';
import '../controller/special.dart';
import '../model/home/product.dart';
import '../utils/helper.dart';
import '../utils/utils.dart';
import '../widget/product_card.dart';
import '../widget/w.dart';
import 'home/city.dart';

class SpecialView extends GetView<NavigationController> {
  const SpecialView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpecialController>(
        init: SpecialController(),
        builder: (special) => Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                titleSpacing: 0,
                leadingWidth: 0,
                leading: SizedBox.shrink(),
                title: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 20),
                    child: Obx(() => Row(
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
                                    ).then((_) {
                                      controller.filteredCities.value = controller.cities;
                                      controller.filteredLocation.clear();
                                      if (city == nav.city.value) return;
                                      special.initialize();
                                      controller.initialize();
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
                    ))
                )
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
                bottom: false,
                child: Obx(() {
                  var count = 1;

                  if (special.isLoading.value) {
                    if (special.type.value == 0) {
                      count += (special.products.length / 2).ceil();
                    } else {
                      count += special.products.length;
                    }
                  }

                  return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        ListView.builder(
                            controller: special.scrollController,
                            itemCount: count,
                            itemBuilder: (ctx, index) {
                              if (index == 0) {
                                return Column(
                                    children: [
                                      ColoredBox(
                                          color: const Color(0xFFF0F0F0),
                                          child: Column(
                                              children: [
                                                h(20),
                                                SearchBarView(),
                                                h(20)
                                              ]
                                          )
                                      ),
                                      _buildProductList(special),
                                      if (!special.isLoading.value) Center(child: CircularProgressIndicator(color: primaryColor))
                                    ]
                                );
                              }

                              final gridIndex = index - 1;

                              return ValueListenableBuilder<int>(
                                  valueListenable: Helper.trigger,
                                  builder: (context, items, child) {
                                    if (special.type.value == 0) {
                                      final int first = gridIndex * 2;
                                      if (first >= special.products.length) return const SizedBox();

                                      final int? second =
                                      (first + 1 < special.products.length) ? first + 1 : null;

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Row(
                                            children: [
                                              Expanded(
                                                  child: _buildProductCard(special.products[first], special)
                                              ),
                                              Expanded(
                                                  child: second != null
                                                      ? _buildProductCard(special.products[second], special)
                                                      : SizedBox()
                                              )
                                            ]
                                        ),
                                      );
                                    } else {
                                      if (gridIndex >= special.products.length) return const SizedBox();
                                      return _buildList(special, gridIndex);
                                    }
                                  }
                              );
                            }
                        ),
                        const SearchWidget()
                      ]
                  );
                })
            )
        )
    );
  }

  Widget _buildProductList(SpecialController special) {
    return Obx(() => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 40,
                  padding: const EdgeInsets.all(4),
                  decoration: ShapeDecoration(
                      color: Color(0xFFEBF3F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ),
                  child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                                onTap: () async {
                                  if (special.tab.value == 0) return;
                                  special.tab.value = 0;
                                  await special.loadProducts(special.id.value, cat: false);
                                },
                                child: Container(
                                    height: 32,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: ShapeDecoration(
                                        color: Color(special.tab.value == 0 ? 0xFF80AEBF : 0xFFEBF3F6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                        'Скидки',
                                        style: TextStyle(
                                            color: special.tab.value != 0 ? Color(0xFF80AEBF) : Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.24
                                        )
                                    )
                                )
                            )
                        ),
                        Expanded(
                            child: GestureDetector(
                                onTap: () async {
                                  if (special.tab.value == 1) return;
                                  special.tab.value = 1;
                                  await special.loadProducts(special.id.value, cat: false);
                                },
                                child: Container(
                                    height: 32,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: ShapeDecoration(
                                        color: Color(special.tab.value == 1 ? 0xFF80AEBF : 0xFFEBF3F6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                        'Товары распродажи',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: special.tab.value != 1 ? Color(0xFF80AEBF) : Colors.white,
                                            fontSize: 12,
                                            height: 1,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.24
                                        )
                                    )
                                )
                            )
                        ),
                        Expanded(
                            child: GestureDetector(
                                onTap: () async {
                                  if (special.tab.value == 2) return;
                                  special.tab.value = 2;
                                  await special.loadProducts(special.id.value, cat: false);
                                },
                                child: Container(
                                    height: 32,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: ShapeDecoration(
                                        color: Color(special.tab.value == 2 ? 0xFF80AEBF : 0xFFEBF3F6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                        'Уценка',
                                        style: TextStyle(
                                            color: special.tab.value != 2 ? Color(0xFF80AEBF) : Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.24
                                        )
                                    )
                                )
                            )
                        )
                      ]
                  )
              ),
              h(10),
              if (special.banners.isNotEmpty && special.tab.value == 1) SizedBox(
                  height: 160,
                  child: PageView.builder(
                      controller: special.pageController,
                      onPageChanged: (val) => special.setTimer(val),
                      itemCount: special.banners.length,
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                    imageUrl: special.banners[index].image2,
                                    errorWidget: (c, e, i) {
                                      return Image.asset('assets/image/no_image.png');
                                    },
                                    width: double.infinity,
                                    fit: BoxFit.contain
                                )
                            )
                        );
                      }
                  )
              ),
              if (special.time.value.inSeconds > 0 && special.tab.value == 1) h(10),
              if (special.time.value.inSeconds > 0 && special.tab.value == 1) Text('До окончания акции:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              if (special.time.value.inSeconds > 0 && special.tab.value == 1) h(10),
              if (special.time.value.inSeconds > 0 && special.tab.value == 1) Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFF009FE6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTimerItem(special.time.value.inDays, Helper.getNoun(special.time.value.inDays, 'День', 'Дня', 'Дней', before: false)),
                        _buildTimerItem(special.time.value.inHours % 24, Helper.getNoun(special.time.value.inHours % 24, 'Час', 'Часа', 'Часов', before: false)),
                        _buildTimerItem(special.time.value.inMinutes % 24, Helper.getNoun(special.time.value.inMinutes % 24, 'Минута', 'Минуты', 'Минут', before: false))
                      ]
                  )
              ),
              if (special.time.value.inSeconds > 0 && special.tab.value == 1) h(10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      special.tab.value == 0 ? 'Акционные товары' : special.tab.value == 2 ? 'Учененные товары' : 'Товары',
                      style: TextStyle(color: Color(0xFF1B1B1B), fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    h(10),
                    const Divider(color: Color(0xFFDDE8EA), thickness: 1, height: 0.1),
                    if (special.products.isNotEmpty) Row(
                        children: [
                          InkWell(
                            onTap: () => special.type.value = 0,
                            child: Image.asset('assets/icon/grid${special.type.value == 0 ? '_active' : ''}.png'),
                          ),
                          w(10),
                          InkWell(
                              onTap: () => special.type.value = 1,
                              child: Image.asset('assets/icon/list${special.type.value == 1 ? '_active' : ''}.png')
                          )
                        ]
                    )
                  ]
              ),
              h(10),
              const Divider(color: Color(0xFFDDE8EA), thickness: 1, height: 0.1),
              if (special.categories.isNotEmpty) h(20),
              if (special.categories.isNotEmpty) DropdownButtonFormField<String?>(
                  value: special.categories.where((e) => e.id == special.id.value).isEmpty ? null : special.id.value,
                  isExpanded: true,
                  decoration: decorationInput(hint: 'Выберите категорию', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                  items: special.categories.map((item) {
                    return DropdownMenuItem<String?>(
                        value: item.id,
                        child: Text(item.name, style: TextStyle(fontSize: 14))
                    );
                  }).toList(),
                  onChanged: special.loadProducts
              ),
            ]
        )
    ));
  }

  Widget _buildProductCard(ProductModel product, SpecialController special) {
    return Container(
        constraints: BoxConstraints(maxHeight: 356, minHeight: 290),
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 8),
        child: ProductCard(
            product: product,
            addWishlist: () => special.addWishlist(product.id),
            buy: () async {
              await controller.addCart(product.id);
              special.update();
            },
            margin: false
        )
    );
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

  Widget _buildList(SpecialController special, int index) {
    return Container(
        height: 128,
        padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
        child: ProductCardList(
            product: special.products[index],
            addWishlist: () => special.addWishlist(special.products[index].id),
            buy: () async {
              await controller.addCart(special.products[index].id);
              special.update();
            }
        )
    );
  }
}