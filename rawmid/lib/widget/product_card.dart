import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/controller/product.dart';
import 'package:rawmid/screen/product/product.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../widget/h.dart';
import '../model/home/product.dart';
import '../utils/helper.dart';
import 'package:get/get.dart';

class ProductCard extends GetView<NavigationController> {
  const ProductCard({super.key, required this.product, required this.addWishlist, required this.buy, required this.margin});

  final ProductModel product;
  final Function() addWishlist;
  final Function() buy;
  final bool margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Get.currentRoute == '/ProductView') {
          final id = Get.find<ProductController>().id;
          Get.delete<ProductController>();
          Get.put(ProductController(product.id));
          Get.find<ProductController>().setId(product.id);
          Get.find<ProductController>().initialize();
          Get.to(() => ProductView(id: product.id), preventDuplicates: false)?.then((_) {
            Get.delete<ProductController>();
            Get.put(ProductController(product.id));
            Get.find<ProductController>().setId(id);
            Get.find<ProductController>().initialize();
          });
        } else {
          Get.to(() => ProductView(id: product.id));
        }
      },
      child: Container(
          margin: EdgeInsets.only(left: margin ? 16 : 0),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
              ]
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                              imageUrl: product.image,
                              errorWidget: (c, e, i) {
                                return Image.asset('assets/image/no_image.png');
                              },
                              height: 112,
                              width: double.infinity,
                              fit: BoxFit.contain
                          )
                      ),
                      if (product.category.isNotEmpty) Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                              constraints: BoxConstraints(maxWidth: 100),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                                  ]
                              ),
                              child: Text(product.category, style: TextStyle(color:primaryColor, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)
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
                ),
                h(8),
                Text(
                    product.title,
                    style: TextStyle(fontWeight: FontWeight.bold, height: 1.36, fontSize: 14),
                    maxLines: product.color.isEmpty ? 3 : 2,
                    overflow: TextOverflow.ellipsis
                ),
                h(4),
                if ((product.hdd ?? '').isNotEmpty) Html(
                    data: product.hdd!,
                    style: {
                      '*': Style(
                          margin: Margins.all(0),
                          fontSize: FontSize(11),
                          padding: HtmlPaddings.zero
                      )
                    },
                    onLinkTap: (val, map, element) {
                      if ((val ?? '').isNotEmpty) {
                        Helper.openLink(val!);
                      }
                    }
                ),
                if ((product.hdd ?? '').isNotEmpty) Spacer(),
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
                                      if (Get.currentRoute == '/ProductView') {
                                        final id = Get.find<ProductController>().id;
                                        Get.find<ProductController>().setId(item.productId);
                                        Get.find<ProductController>().initialize();
                                        Get.to(() => ProductView(id: item.productId), preventDuplicates: false)?.then((_) {
                                          Get.find<ProductController>().setId(id);
                                          Get.find<ProductController>().initialize();
                                        });
                                      } else {
                                        Get.to(() => ProductView(id: item.productId));
                                      }
                                    },
                                    child: InnerShadow(
                                        shadows: [
                                          Shadow(
                                              color: Colors.black.withOpacityX(0.2),
                                              offset: Offset(0, 3.56),
                                              blurRadius: 7.65
                                          )
                                        ],
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(color),
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            width: 20,
                                            height: 20
                                        )
                                    )
                                );
                              })
                          )
                      )
                    )
                  ]
                ),
                if ((product.colors ?? []).isEmpty && product.color.isNotEmpty) Text(
                    'Цвет: ${product.color}',
                    style: TextStyle(color: Colors.black54, fontSize: 12)
                ),
                h(4),
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        if ((product.rating ?? 0) > 0) Row(
                            children: [1,2,3,4,5].map((e) => Icon(e <= product.rating! ? Icons.star : Icons.star_half, color: Colors.amber, size: 16)).toList()
                        ),
                        InkWell(
                            onTap: () => Helper.addCompare(product.id),
                            child: Image.asset('assets/icon/rat${Helper.compares.value.contains(product.id) ? '2' : ''}.png', width: 24, fit: BoxFit.cover)
                        )
                      ]
                  )
                ),
                Container(
                    alignment: Alignment.bottomLeft,
                    height: 47,
                    child: (product.special ?? '').isEmpty ? Text(product.price ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)) : Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.spaceBetween,
                        spacing: 10,
                        children: [
                          if ((product.special ?? '').isNotEmpty) Text(product.special!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          if ((product.price ?? '').isNotEmpty) Text(
                              product.price!,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: primaryColor,
                                  decoration: TextDecoration.lineThrough)
                          )
                        ]
                    )
                ),
                Spacer(),
                PrimaryButton(text: controller.isCart(product.id) ? 'В корзине' : 'Купить', loader: true, onPressed: buy, height: 40)
              ]
          )
      )
    );
  }
}