import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/product/product.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../controller/user_reviews.dart';
import '../../widget/h.dart';
import '../../widget/primary_button.dart';
import '../../widget/w.dart';

class MyReviewsView extends StatelessWidget {
  const MyReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserReviewsController>(
        init: UserReviewsController(),
        builder: (controller) => Scaffold(
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
                bottom: false,
                child: Obx(() => Stack(
                    children: [
                      Container(
                          height: Get.height,
                          alignment: controller.isLoading.value ? Alignment.topCenter : Alignment.center,
                          child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (controller.isLoading.value) ModuleTitle(title: 'Мои отзывы', type: true),
                                    if (controller.isLoading.value) h(16),
                                    !controller.isLoading.value ? Center(
                                        child: CircularProgressIndicator(color: primaryColor)
                                    ) : controller.products.isNotEmpty ? Wrap(
                                        runSpacing: 32,
                                        children: controller.products.map((item) {
                                          return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => Get.to(() => ProductView(id: item.id)),
                                                  child: Row(
                                                      children: [
                                                        ClipRRect(
                                                            borderRadius: BorderRadius.circular(8),
                                                            child: CachedNetworkImage(
                                                                imageUrl: item.image,
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
                                                                      item.title,
                                                                      style: TextStyle(
                                                                          color: Color(0xFF1E1E1E),
                                                                          fontSize: 15,
                                                                          fontWeight: FontWeight.w700
                                                                      )
                                                                  ),
                                                                  if (item.color.isNotEmpty) Text(
                                                                      'Цвет: ${item.color}',
                                                                      style: TextStyle(
                                                                          color: Color(0xFF8A95A8),
                                                                          fontSize: 12
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                        ),
                                                        w(12),
                                                        Text(
                                                            (item.special ?? '').isNotEmpty ? item.special! : item.price ?? '',
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
                                                Wrap(
                                                    runSpacing: 12,
                                                    children: List.generate((item.reviews ?? []).length, (index2) {
                                                      final review = item.reviews![index2];

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
                                                          child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Flexible(
                                                                          child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                    review.author,
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
                                                                                      if (review.rating > 0) Row(
                                                                                          children: [1,2,3,4,5].map((e) => Icon(e <= review.rating ? Icons.star : Icons.star_half, color: Colors.amber, size: 16)).toList()
                                                                                      ),
                                                                                      if (review.rating > 0) w(5),
                                                                                      if (review.rating > 0) Text(
                                                                                          '${item.rating}',
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)
                                                                                      )
                                                                                    ]
                                                                                )
                                                                              ]
                                                                          )
                                                                      ),
                                                                      if (review.date != null) Text(
                                                                          controller.formatDateCustom(review.date!),
                                                                          style: TextStyle(
                                                                              color: Color(0xFF8A95A8),
                                                                              fontSize: 11
                                                                          )
                                                                      )
                                                                    ]
                                                                ),
                                                                h(16),
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      Stack(
                                                                          children: [
                                                                            Text(review.text, style: TextStyle(), maxLines: review.checked && controller.isChecked.value == index2 ? null : 3, overflow: review.checked && controller.isChecked.value == index2 ? null : TextOverflow.ellipsis),
                                                                            if (review.text.length > 200 && !review.checked) Positioned(
                                                                                bottom: 0,
                                                                                right: 0,
                                                                                child: InkWell(
                                                                                    onTap: () {
                                                                                      review.checked = !review.checked;

                                                                                      if (review.checked) {
                                                                                        controller.isChecked.value = index2;
                                                                                      } else {
                                                                                        controller.isChecked.value = -1;
                                                                                      }

                                                                                      controller.products.refresh();
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
                                                                      if (review.checked) InkWell(
                                                                          onTap: () {
                                                                            review.checked = false;
                                                                            controller.isChecked.value = -1;
                                                                          },
                                                                          child: Container(
                                                                              padding: const EdgeInsets.only(left: 3),
                                                                              color: Colors.white,
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
                                                )
                                              ]
                                          );
                                        }).toList()
                                    ) : SizedBox(
                                        child: Text('Вы еще не оставляли отзывы', style: TextStyle(fontSize: 16))
                                    ),
                                    h(MediaQuery.of(context).padding.bottom + 70)
                                  ]
                              )
                          )
                      ),
                      Positioned(
                          bottom: 10 + MediaQuery.of(context).viewPadding.bottom,
                          left: 20,
                          right: 20,
                          child: PrimaryButton(text: 'Вернуться на главную', height: 40, background: Colors.white, borderColor: primaryColor, borderWidth: 2, textStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w700), onPressed: () {
                            controller.navController.onItemTapped(0);
                            Get.back();

                            if (Navigator.canPop(context)) {
                              Get.back();
                            }
                          })
                      )
                    ]
                ))
            )
        )
    );
  }
}