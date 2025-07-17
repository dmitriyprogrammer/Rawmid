import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/wishlist/product_card.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../controller/wishlist.dart';
import '../../utils/helper.dart';
import '../../widget/h.dart';
import '../../widget/product_card.dart';
import '../../widget/w.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WishlistController>(
        init: WishlistController(),
        builder: (controller) => ColoredBox(
            color: Colors.white,
            child: Obx(() => SafeArea(
                bottom: false,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h(20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Избранное',
                                    style: TextStyle(
                                        color: Color(0xFF1B1B1B),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600
                                    )
                                ),
                                if (controller.products.isNotEmpty) Row(
                                    children: [
                                      InkWell(
                                          onTap: () => controller.tab.value = 0,
                                          child: Image.asset('assets/icon/grid${controller.tab.value == 0 ? '_active' : ''}.png')
                                      ),
                                      w(10),
                                      InkWell(
                                          onTap: () => controller.tab.value = 1,
                                          child: Image.asset('assets/icon/list${controller.tab.value == 1 ? '_active' : ''}.png')
                                      )
                                    ]
                                )
                              ]
                          ),
                          h(10),
                          Divider(color: Color(0xFFDDE8EA), thickness: 1, height: 0.1),
                          if (controller.products.isEmpty && controller.isLoading.value) h(20),
                          if (controller.products.isEmpty && controller.isLoading.value) Text(
                            'Вы еще не добавляли в избранное',
                            style: TextStyle(fontWeight: FontWeight.w700)
                          ),
                          if (controller.products.isEmpty && controller.isLoading.value) h(20),
                          if (controller.products.isEmpty && controller.isLoading.value) PrimaryButton(text: 'Вернуться на главную', height: 40, background: Colors.white, borderColor: primaryColor, borderWidth: 2, textStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w700), onPressed: () => controller.navController.onItemTapped(0)),
                          Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  controller.isLoading.value ? Expanded(
                                      child: ValueListenableBuilder<int>(
                                          valueListenable: Helper.trigger,
                                          builder: (context, items, child) => controller.tab.value == 0 ? GridView.builder(
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 16,
                                                  mainAxisExtent: 364
                                              ),
                                              clipBehavior: Clip.none,
                                              itemCount: controller.products.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding: const EdgeInsets.only(top: 16),
                                                    child: ProductCard(
                                                        product: controller.products[index],
                                                        addWishlist: () => controller.removeWishlist(controller.products[index].id),
                                                        buy: () async {
                                                          await controller.navController.addCart(controller.products[index].id);
                                                          controller.update();
                                                        },
                                                        margin: false
                                                    )
                                                );
                                              }
                                          ) : ListView.builder(
                                              itemCount: controller.products.length,
                                              itemExtent: 126,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding: const EdgeInsets.only(top: 16),
                                                    child: ProductCardList(
                                                        product: controller.products[index],
                                                        addWishlist: () => controller.removeWishlist(controller.products[index].id),
                                                        buy: () => controller.navController.addCart(controller.products[index].id)
                                                    )
                                                );
                                              }
                                          )
                                      )
                                  ) : Container(
                                    width: Get.width,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(color: primaryColor)
                                  ),
                                  h(20)
                                ]
                            )
                          )
                        ]
                    )
                )
            ))
        )
    );
  }
}