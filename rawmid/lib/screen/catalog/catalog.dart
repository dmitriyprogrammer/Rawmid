import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/screen/catalog/banner.dart';
import 'package:rawmid/screen/catalog/slideshow.dart';
import 'package:rawmid/utils/constant.dart';
import '../../controller/catalog.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../home/shop.dart';
import '../../widget/h.dart';
import 'category.dart';

class CatalogView extends GetView<NavigationController> {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CatalogController>(
        init: CatalogController(),
        builder: (catalog) => Obx(() => SafeArea(
            child: catalog.isLoading.value ? SingleChildScrollView(
                child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                          children: [
                            h(20),
                            SearchBarView(),
                            h(20),
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  if (catalog.banners2.isNotEmpty) SlideshowCatalogView(banners: catalog.banners2),
                                  if (catalog.categories.isNotEmpty) CategorySection(categories: catalog.categories),
                                  if (catalog.specials.isNotEmpty) StoreSection(title: 'Товары со скидкой', products: catalog.specials, addWishlist: catalog.addWishlist, buy: (id) async {
                                    await controller.addCart(id);
                                    catalog.update();
                                  }),
                                  if (catalog.banners.isNotEmpty) BannerView(banners: catalog.banners, title: 'Особые предложения'),
                                  if (catalog.shopProducts.isNotEmpty) StoreSection(title: 'Рекомендуемые товары', products: catalog.shopProducts, addWishlist: catalog.addWishlist, buy: (id) async {
                                    await controller.addCart(id);
                                    catalog.update();
                                  }),
                                  h(40)
                                ]
                              )
                            )
                          ]
                      ),
                      SearchWidget()
                    ]
                )
            ) : Center(
                child: CircularProgressIndicator(color: primaryColor)
            )
        ))
    );
  }
}