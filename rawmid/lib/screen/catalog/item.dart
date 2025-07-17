import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/model/catalog/category.dart';
import 'package:rawmid/screen/catalog/slideshow.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../controller/category.dart';
import '../../model/home/product.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../widget/h.dart';
import '../../widget/module_title.dart';
import '../../widget/nav_menu.dart';
import '../../widget/product_card.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../../widget/w.dart';
import '../wishlist/product_card.dart';
import 'filter.dart';

class CategoryItemView extends StatelessWidget {
  const CategoryItemView({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
        init: CategoryController(category),
        builder: (controller) => Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                titleSpacing: 0,
                leadingWidth: 0,
                leading: const SizedBox.shrink(),
                title: Padding(
                  padding: const EdgeInsets.only(left: 2, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: Get.back,
                          icon: Image.asset('assets/icon/left.png'),
                        ),
                        Image.asset('assets/image/logo.png', width: 70)
                      ]
                  )
                )
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
                bottom: false,
                child: Obx(() {
                  if (!controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: primaryColor));
                  }

                  int count = 1;

                  if (controller.tab.value == 0) {
                    count += (controller.products.length / 2).ceil();
                  } else {
                    count += controller.products.length;
                  }

                  return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        ListView.builder(
                            controller: controller.scrollController,
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
                                      controller.banners.isNotEmpty ? Container(
                                          color: Colors.white,
                                          child: SlideshowCatalogView(title: category.name, banners: controller.banners)
                                      ) : Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          child: ModuleTitle(title: category.name, type: true)
                                      ),
                                      _buildProductList(controller)
                                    ]
                                );
                              }

                              if (index == count + 1 && controller.load.value) {
                                return Obx(() => Center(child: CircularProgressIndicator(color: primaryColor)));
                              }

                              final gridIndex = index - 1;

                              return ValueListenableBuilder<int>(
                                valueListenable: Helper.trigger,
                                builder: (context, items, child) {
                                  if (controller.tab.value == 0) {
                                    final int first = gridIndex * 2;
                                    if (first >= controller.products.length) return const SizedBox();

                                    final int? second =
                                    (first + 1 < controller.products.length) ? first + 1 : null;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: _buildProductCard(
                                                controller.products[first], controller)
                                          ),
                                          Expanded(
                                            child: second != null
                                                ? _buildProductCard(
                                                controller.products[second], controller)
                                                : SizedBox()
                                          )
                                        ]
                                      ),
                                    );
                                  } else {
                                    if (gridIndex >= controller.products.length) return const SizedBox();
                                    return _buildList(controller, gridIndex);
                                  }
                                }
                              );
                            }
                        ),
                        const SearchWidget()
                      ]
                  );
                })
            ),
            bottomNavigationBar: NavMenuView(nav: true)
        )
    );
  }

  Widget _buildProductList(CategoryController controller) {
    return Obx(() => Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FilterView(),
              h(20),
              Row(
                  key: controller.targetKey,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Товары',
                      style: TextStyle(color: Color(0xFF1B1B1B), fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    if (controller.products.isNotEmpty) Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: Get.context!,
                                  useSafeArea: false,
                                  useRootNavigator: true,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                  ),
                                  builder: (context) {
                                    return Container(
                                      height: Get.height * 0.6,
                                      padding: EdgeInsets.only(
                                        left: 8, right: 16, top: 20, bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(left: 12),
                                                  child: Text(
                                                      'Сортировка',
                                                      style: TextStyle(
                                                          color: Color(0xFF1E1E1E),
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600
                                                      )
                                                  )
                                              ),
                                              h(20),
                                              Obx(() => Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: controller.sorts.map((item) {
                                                    return RadioListTile(
                                                        onChanged: (val) {
                                                          controller.sort.value = val ?? '';
                                                        },
                                                        activeColor: primaryColor,
                                                        value: item.key,
                                                        groupValue: controller.sort.value,
                                                        contentPadding: EdgeInsets.zero,
                                                        visualDensity: VisualDensity.compact,
                                                        title: Text(
                                                            item.value
                                                        )
                                                    );
                                                  }).toList()
                                              )),
                                              h(20),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 12, right: 4),
                                                child: PrimaryButton(text: 'Применить', height: 40, onPressed: () {
                                                  controller.getSortedProducts();
                                                  Get.back();
                                                })
                                              )
                                            ]
                                        )
                                      )
                                    );
                                  }
                              );
                            },
                            icon: Image.asset('assets/icon/sort${controller.sort.value.contains('ASC') ? '_active' : ''}.png', width: 32)
                        ),
                        Row(
                            children: [
                              InkWell(
                                onTap: () => controller.tab.value = 0,
                                child: Image.asset('assets/icon/grid${controller.tab.value == 0 ? '_active' : ''}.png'),
                              ),
                              w(10),
                              InkWell(
                                  onTap: () => controller.tab.value = 1,
                                  child: Image.asset('assets/icon/list${controller.tab.value == 1 ? '_active' : ''}.png')
                              )
                            ]
                        )
                      ]
                    )
                  ]
              ),
              h(10),
              const Divider(color: Color(0xFFDDE8EA), thickness: 1, height: 0.1),
              if (controller.products.isEmpty && controller.filter.isNotEmpty) Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: const Text(
                      'По заданным параметрам ничего не найдено',
                      style: TextStyle(fontWeight: FontWeight.w400)
                  )
              )
            ]
        )
    ));
  }

  Widget _buildProductCard(ProductModel product, CategoryController controller) {
    return Container(
        constraints: BoxConstraints(maxHeight: 356, minHeight: 290),
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 8),
        child: ProductCard(
            product: product,
            addWishlist: () => controller.addWishlist(product.id),
            buy: () async {
              await controller.navController.addCart(product.id);
              controller.update();
            },
            margin: false
        )
    );
  }

  Widget _buildList(CategoryController controller, int index) {
    return Container(
        height: 128,
        padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
        margin: EdgeInsets.only(bottom: 10),
        child: ProductCardList(
            product: controller.products[index],
            addWishlist: () => controller.addWishlist(controller.products[index].id),
            buy: () async {
              await controller.navController.addCart(controller.products[index].id);
              controller.update();
            }
        )
    );
  }
}