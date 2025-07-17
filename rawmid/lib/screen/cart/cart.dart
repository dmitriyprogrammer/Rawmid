import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/cart.dart';
import 'package:rawmid/screen/product/product.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../model/cart.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../widget/h.dart';
import '../../widget/w.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
        init: CartController(),
        builder: (controller) => ColoredBox(
            color: Colors.white,
            child: Obx(() {
              if (!controller.isLoading.value) {
                return Center(
                    child: CircularProgressIndicator(color: primaryColor)
                );
              }

              return SafeArea(
                  bottom: false,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                h(20),
                                Text(
                                    'Корзина',
                                    style: TextStyle(
                                        color: Color(0xFF1B1B1B),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600
                                    )
                                ),
                                h(10),
                                Divider(color: Color(0xFFDDE8EA), thickness: 1, height: 0.1),
                                h(10),
                                controller.cartProducts.isNotEmpty ? Expanded(
                                    child: ValueListenableBuilder<int>(
                                        valueListenable: Helper.trigger,
                                        builder: (context, items, child) => ListView.builder(
                                            itemCount: controller.cartProducts.length,
                                            itemBuilder: (context, index) {
                                              return Obx(() => _cartItemTile(controller.cartProducts[index], controller.updateCart, controller.updateCart, controller.addWishlist));
                                            }
                                        )
                                    )
                                ) : Text('Корзина покупок пуста'),
                                h(80)
                              ]
                          ),
                          if (controller.cartProducts.isNotEmpty) Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: PrimaryButton(text: 'Оформить заказ', height: 50, onPressed: () => Get.toNamed('checkout'))
                          )
                        ]
                      )
                  )
              );
            })
        )
    );
  }

  Widget _cartItemTile(CartModel product, Function(CartModel) plus, Function(CartModel) minus, Function(String) addWishlist) {
    return Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    Get.to(() => ProductView(id: product.id));
                  },
                  child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: product.image.isNotEmpty ? CachedNetworkImageProvider(product.image) : AssetImage('assets/image/empty.png'),
                              fit: BoxFit.cover
                          )
                      )
                  )
              ),
              w(12),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Get.to(() => ProductView(id: product.id));
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                product.name,
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700
                                )
                            ),
                            if (product.hdd.isNotEmpty) h(4),
                            if (product.hdd.isNotEmpty) Text(
                                product.hdd,
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 11
                                )
                            ),
                            if (product.color.isNotEmpty) h(4),
                            if (product.color.isNotEmpty) Text(
                                'Цвет: ${product.color}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600])
                            ),
                            Text(
                                product.price,
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700
                                )
                            )
                          ]
                      )
                  )
              ),
              w(6),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () => addWishlist(product.id),
                        child: Icon(Helper.wishlist.value.contains(product.id) ? Icons.favorite : Icons.favorite_border, color: Helper.wishlist.value.contains(product.id) ? primaryColor : Colors.black, size: 18)
                    ),
                    h(28),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                            children: [
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      product.quantity = product.quantity! - 1;
                                      minus(product);
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Icon(Icons.remove, color: Colors.blue, size: 18),
                                  )
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  width: 35,
                                  child: Text(
                                      '${product.quantity}',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          height: 1.30
                                      )
                                  )
                              ),
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        product.quantity = product.quantity! + 1;
                                        plus(product);
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Icon(Icons.add, color: Colors.blue, size: 18)
                                  )
                              )
                            ]
                        )
                    )
                  ]
              )
            ]
        )
    );
  }
}