import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/model/home/product.dart';
import 'package:rawmid/screen/product/product.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/module_title.dart';
import '../controller/reviews.dart';
import '../widget/h.dart';
import '../widget/w.dart';

class ReviewsView extends StatelessWidget {
  const ReviewsView({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewsController>(
        init: ReviewsController(product),
        builder: (controller) =>
            Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.white,
                    titleSpacing: 0,
                    leadingWidth: 0,
                    leading: SizedBox.shrink(),
                    title: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: Get.back,
                                  icon: Image.asset('assets/icon/left.png')
                              ),
                              Image.asset('assets/image/logo.png', width: 70)
                            ]
                        )
                    )
                ),
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() => Column(
                        children: [
                          ModuleTitle(title: 'Отзывы', type: true),
                          h(16),
                          GestureDetector(
                            onTap: () => Get.to(() => ProductView(id: product.id)),
                            child: Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                          imageUrl: product.image,
                                          errorWidget: (c, e, i) {
                                            return Image.asset('assets/image/no_image.png');
                                          },
                                          height: 64,
                                          width: 64,
                                          fit: BoxFit.cover
                                      )
                                  ),
                                  w(12),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                product.title,
                                                style: TextStyle(
                                                    color: Color(0xFF1E1E1E),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700
                                                )
                                            ),
                                            if (product.color.isNotEmpty) Text(
                                                'Цвет: ${product.color}',
                                                style: TextStyle(
                                                    color: Color(0xFF8A95A8),
                                                    fontSize: 10
                                                )
                                            )
                                          ]
                                      )
                                  ),
                                  w(12),
                                  Text(
                                      (product.special ?? '').isNotEmpty ? product.special! : product.price ?? '',
                                      style: TextStyle(
                                          color: Color(0xFF1E1E1E),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700
                                      )
                                  )
                                ]
                            )
                          ),
                          h(20),
                          !controller.isLoading.value ? Center(
                            child: CircularProgressIndicator(color: primaryColor)
                          ) : controller.reviews.isNotEmpty ? Wrap(
                            runSpacing: 12,
                            children: List.generate(controller.reviews.length, (index) {
                              final item = controller.reviews[index];

                              return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: ShapeDecoration(
                                      color: Color(0x4CF0F0F0),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                                          borderRadius: BorderRadius.circular(6)
                                      )
                                  ),
                                  key: controller.keys[index],
                                  child: Column(
                                      children: [
                                        SizedBox(
                                          height: 66,
                                          width: double.infinity,
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                              item.author,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color: Color(0xFF1E1E1E),
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w600
                                                              )
                                                          ),
                                                          h(6),
                                                          Row(
                                                              children: [
                                                                if (item.rating > 0) Row(
                                                                    children: [1,2,3,4,5].map((e) => Icon(e <= item.rating ? Icons.star : Icons.star_half, color: Colors.amber, size: 16)).toList()
                                                                ),
                                                                if (item.rating > 0) w(5),
                                                                if (item.rating > 0) Text(
                                                                    '${item.rating}',
                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)
                                                                )
                                                              ]
                                                          )
                                                        ]
                                                    )
                                                ),
                                                if (item.date != null) Flexible(
                                                    child: Text(
                                                        controller.formatDateCustom(item.date!),
                                                        style: TextStyle(
                                                            color: Color(0xFF8A95A8),
                                                            fontSize: 11
                                                        )
                                                    )
                                                )
                                              ]
                                          )
                                        ),
                                        h(16),
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Stack(
                                                  children: [
                                                    Text(item.text, style: TextStyle(), maxLines: item.checked ? null : 3, overflow: item.checked ? null : TextOverflow.ellipsis),
                                                    if (item.text.length > 200 && !item.checked) Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        child: InkWell(
                                                            onTap: () {
                                                              item.checked = !item.checked;
                                                              controller.update();
                                                            },
                                                            child: Container(
                                                                padding: const EdgeInsets.only(left: 3),
                                                                color: Colors.white,
                                                                child: Text(
                                                                    'читать далее...',
                                                                    style: TextStyle(color: Colors.blue, fontSize: 14)
                                                                )
                                                            )
                                                        )
                                                    )
                                                  ]
                                              ),
                                              if (item.checked) InkWell(
                                                  onTap: () {
                                                    item.checked = false;
                                                    controller.update();

                                                    Scrollable.ensureVisible(
                                                      controller.keys[index].currentContext!,
                                                      duration: Duration(seconds: 1),
                                                      curve: Curves.easeInOut
                                                    );
                                                  },
                                                  child: Container(
                                                      padding: const EdgeInsets.only(left: 3),
                                                      color: Color(0xFFDDE8EA),
                                                      child: Text(
                                                          'Свернуть',
                                                          style: TextStyle(color: Colors.blue, fontSize: 14)
                                                      )
                                                  )
                                              )
                                            ]
                                        )
                                      ]
                                  )
                              );
                            })
                          ) : Center(
                            child: Text('У этого товара нет отзывов', style: TextStyle(fontSize: 16))
                          )
                        ]
                    ))
                  )
                )
            )
    );
  }
}