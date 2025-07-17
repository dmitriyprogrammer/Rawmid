import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rawmid/controller/navigation.dart';
import '../../model/home/product.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../widget/h.dart';
import '../../widget/primary_button.dart';
import '../../widget/w.dart';
import 'package:get/get.dart';
import '../product/product.dart';
import '../reviews.dart';

class ProductCardList extends GetView<NavigationController> {
  const ProductCardList({super.key, required this.product, required this.addWishlist, required this.buy});

  final ProductModel product;
  final Function() addWishlist;
  final Function() buy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Get.to(() => ProductView(id: product.id)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 110,
                  child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: secondColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: CachedNetworkImage(
                                imageUrl: product.image,
                                errorWidget: (c, e, i) {
                                  return Image.asset('assets/image/no_image.png');
                                },
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover
                            )
                        ),
                        if (product.category.isNotEmpty) Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                                constraints: BoxConstraints(maxWidth: 70),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                                    ]
                                ),
                                child: Text(product.category, style: TextStyle(color: primaryColor, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis)
                            )
                        ),
                        Positioned(
                            top: 0,
                            right: -5,
                            child: InkWell(
                                onTap: addWishlist,
                                child: Icon(Helper.wishlist.value.contains(product.id) ? Icons.favorite : Icons.favorite_border, color: Helper.wishlist.value.contains(product.id) ? primaryColor : Colors.black, size: 28)
                            )
                        )
                      ]
                  )
              ),
              w(12),
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.title, style: TextStyle(fontSize: 14, height: 1.1, fontWeight: FontWeight.w500), maxLines: 3, overflow: TextOverflow.ellipsis),
                                  if ((product.colors ?? []).isNotEmpty) h(4),
                                  if ((product.colors ?? []).isNotEmpty) Row(
                                      spacing: 4,
                                      children: [
                                        Text(
                                            'Цвет:',
                                            style: TextStyle(color: Colors.black54, fontSize: 12)
                                        ),
                                        Expanded(
                                            child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                    spacing: 6,
                                                    children: List.generate(product.colors!.length, (index) {
                                                      final item = product.colors![index];
                                                      final color = int.tryParse('0xFF${item.color.replaceAll('#', '')}');

                                                      if (color == null) return SizedBox.shrink();

                                                      return GestureDetector(
                                                          onTap: () {
                                                            Get.to(() => ProductView(id: item.productId));
                                                          },
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Color(color),
                                                                  border: Border.all(color: color == 4294967295 ? primaryColor : Colors.transparent),
                                                                  borderRadius: BorderRadius.circular(20)
                                                              ),
                                                              width: 20,
                                                              height: 20
                                                          )
                                                      );
                                                    })
                                                )
                                            )
                                        )
                                      ]
                                  ),
                                  if ((product.colors ?? []).isEmpty && product.color.isNotEmpty) h(4),
                                  if ((product.colors ?? []).isEmpty && product.color.isNotEmpty) Text('Цвет: ${product.color}', style: TextStyle(color: Colors.grey)),
                                  h(4),
                                  InkWell(
                                      onTap: () => Helper.addCompare(product.id),
                                      child: Image.asset('assets/icon/rat${Helper.compares.value.contains(product.id) ? '2' : ''}.png', width: 20, fit: BoxFit.cover)
                                  ),
                                  Spacer(),
                                  InkWell(
                                      onTap: () => Get.to(() => ReviewsView(product: product)),
                                      child: Text('Отзывы', style: TextStyle(
                                          color: Color(0xFF8A95A8),
                                          fontSize: 13,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline
                                      ))
                                  )
                                ]
                            )
                        ),
                        w(12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  (product.special ?? '').isEmpty ? Text(product.price ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1)) : Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        if ((product.special ?? '').isNotEmpty) Text(product.special!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1)),
                                        if ((product.price ?? '').isNotEmpty) Text(product.price!, style: TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough))
                                      ]
                                  ),
                                  (product.rating ?? 0) > 0 ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [1,2,3,4,5].map((e) => Icon(e <= product.rating! ? Icons.star : Icons.star_half, color: Colors.amber, size: 16)).toList()
                                  ) : SizedBox(height: 16),
                                  h(8),
                                  PrimaryButton(text: controller.isCart(product.id) ? 'В корзине' : 'Купить', textStyle: TextStyle(fontSize: 16, color: Colors.white), loader: true, onPressed: buy, height: 38)
                                ]
                            )
                        )
                      ]
                  )
              )
            ]
        )
    );
  }
}