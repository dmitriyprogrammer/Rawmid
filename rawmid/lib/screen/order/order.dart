import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/product/product.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../controller/order.dart';
import '../../model/order_history.dart';
import '../../utils/constant.dart';
import '../../widget/h.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../../widget/w.dart';
import 'info.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
        init: OrderController(),
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
                      SingleChildScrollView(
                          child: Stack(
                              children: [
                                if (controller.isLoading.value) Container(
                                    color: Colors.white,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ColoredBox(
                                              color: Color(0xFFF0F0F0),
                                              child: Column(
                                                  children: [
                                                    h(20),
                                                    SearchBarView(),
                                                    h(20)
                                                  ]
                                              )
                                          ),
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          h(20),
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              spacing: 10,
                                                              children: [
                                                                Flexible(
                                                                    child: Text(
                                                                        'Мои заказы',
                                                                        style: TextStyle(
                                                                            color: Color(0xFF1E1E1E),
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.w700
                                                                        )
                                                                    )
                                                                ),
                                                                if (controller.orders.isNotEmpty) Flexible(
                                                                    flex: 2,
                                                                    child: Container(
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
                                                                                      onTap: () => controller.tab.value = 0,
                                                                                      child: Container(
                                                                                          height: 32,
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 6),
                                                                                          decoration: ShapeDecoration(
                                                                                              color: Color(controller.tab.value == 0 ? 0xFF80AEBF : 0xFFEBF3F6),
                                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                                                          ),
                                                                                          alignment: Alignment.center,
                                                                                          child: Text(
                                                                                              'Активные',
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(
                                                                                                  color: controller.tab.value != 0 ? Color(0xFF80AEBF) : Colors.white,
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
                                                                                      onTap: () => controller.tab.value = 1,
                                                                                      child: Container(
                                                                                          height: 32,
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 6),
                                                                                          decoration: ShapeDecoration(
                                                                                              color: Color(controller.tab.value == 1 ? 0xFF80AEBF : 0xFFEBF3F6),
                                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                                                          ),
                                                                                          alignment: Alignment.center,
                                                                                          child: Text(
                                                                                              'Завершенные',
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(
                                                                                                  color: controller.tab.value != 1 ? Color(0xFF80AEBF) : Colors.white,
                                                                                                  fontSize: 12,
                                                                                                  height: 1,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  letterSpacing: 0.24
                                                                                              )
                                                                                          )
                                                                                      )
                                                                                  )
                                                                              )
                                                                            ]
                                                                        )
                                                                    )
                                                                )
                                                              ]
                                                          ),
                                                          Divider(color: Color(0xFFDDE8EA), height: 36)
                                                        ]
                                                    )
                                                ),
                                                controller.orders.isNotEmpty ? Builder(
                                                  builder: (c) {
                                                    List<OrdersModel> orders = [];

                                                    if (controller.tab.value == 0) {
                                                      orders.addAll(controller.orders.where((e) => e.end == 0));
                                                    } else {
                                                      orders.addAll(controller.orders.where((e) => e.end == 1));
                                                    }

                                                    if (orders.isEmpty) {
                                                      return Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                        child: Text(
                                                            controller.tab.value == 0 ? 'У вас нет активных заказов' : 'У вас нет завершенных заказов',
                                                            style: TextStyle(fontWeight: FontWeight.w700)
                                                        )
                                                      );
                                                    }

                                                    return Wrap(
                                                        runSpacing: 10,
                                                        children: List.generate(orders.length, (index) {
                                                          final order = orders[index];

                                                          return Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                                    child: Column(
                                                                        children: [
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                    'Заказ №${order.id}',
                                                                                    style: TextStyle(
                                                                                        color: Color(0xFF1E1E1E),
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w700
                                                                                    )
                                                                                ),
                                                                                Flexible(
                                                                                    child: Text(
                                                                                        order.total,
                                                                                        textAlign: TextAlign.right,
                                                                                        style: TextStyle(
                                                                                            color: Color(0xFF1E1E1E),
                                                                                            fontSize: 18,
                                                                                            fontWeight: FontWeight.w700
                                                                                        )
                                                                                    )
                                                                                )
                                                                              ]
                                                                          ),
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Flexible(
                                                                                    child: Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          Text(
                                                                                              'Статус:',
                                                                                              style: TextStyle(
                                                                                                  color: Color(0xFF8A95A8),
                                                                                                  fontSize: 15,
                                                                                                  fontWeight: FontWeight.w600
                                                                                              )
                                                                                          ),
                                                                                          w(4),
                                                                                          Text(
                                                                                              order.status,
                                                                                              style: TextStyle(
                                                                                                  color: Color(0xFF0D80D9),
                                                                                                  fontSize: 16,
                                                                                                  fontWeight: FontWeight.w600
                                                                                              )
                                                                                          )
                                                                                        ]
                                                                                    )
                                                                                )
                                                                              ]
                                                                          ),
                                                                          h(16)
                                                                        ]
                                                                    )
                                                                ),
                                                                SingleChildScrollView(
                                                                    padding: EdgeInsets.only(left: 20),
                                                                    scrollDirection: Axis.horizontal,
                                                                    child: Row(
                                                                        spacing: 16,
                                                                        children: List.generate(order.products.length, (index2) {
                                                                          final product = order.products[index2];

                                                                          return GestureDetector(
                                                                              onTap: () => Get.to(() => ProductView(id: product.id)),
                                                                              child: SizedBox(
                                                                                  width: 160,
                                                                                  child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                            height: 160,
                                                                                            clipBehavior: Clip.antiAlias,
                                                                                            decoration: ShapeDecoration(
                                                                                                color: Color(0xFFDDDADA),
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                                                                                            ),
                                                                                            child: CachedNetworkImage(
                                                                                                imageUrl: product.image, width: double.infinity, height: 64,
                                                                                                fit: BoxFit.contain,
                                                                                                errorWidget: (c, e, i) {
                                                                                                  return Image.asset('assets/image/empty.png');
                                                                                                }
                                                                                            )
                                                                                        ),
                                                                                        h(8),
                                                                                        Text(
                                                                                            product.name,
                                                                                            maxLines: 3,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            style: TextStyle(
                                                                                                color: Color(0xFF1E1E1E),
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w700
                                                                                            )
                                                                                        )
                                                                                      ]
                                                                                  )
                                                                              )
                                                                          );
                                                                        })
                                                                    )
                                                                ),
                                                                h(16),
                                                                Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                                    child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          if (order.dateAdded != null) Expanded(
                                                                              child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                        'Дата:',
                                                                                        style: TextStyle(
                                                                                            color: Color(0xFF8A95A8),
                                                                                            fontSize: 12,
                                                                                            fontWeight: FontWeight.w600
                                                                                        )
                                                                                    ),
                                                                                    Text(
                                                                                        controller.formatDateCustom(order.dateAdded!),
                                                                                        style: TextStyle(
                                                                                            color: Color(0xFF1E1E1E),
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.w600
                                                                                        )
                                                                                    )
                                                                                  ]
                                                                              )
                                                                          ),
                                                                          PrimaryButton(text: 'Подробнее', height: 45, width: 140, onPressed: () => Get.to(() => OrderInfoView(order: order)))
                                                                        ]
                                                                    )
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                                    child: Divider(color: Color(0xFFDDE8EA), height: 36)
                                                                )
                                                              ]
                                                          );
                                                        })
                                                    );
                                                  }
                                                ) : Container(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Вы еще не оформляли заказ')),
                                                h(20 + MediaQuery.of(context).padding.bottom)
                                              ]
                                          )
                                        ]
                                    )
                                ),
                                if (controller.isLoading.value) SearchWidget()
                              ]
                          )
                      ),
                      if (!controller.isLoading.value) Center(child: CircularProgressIndicator(color: primaryColor))
                    ]
                ))
            )
        )
    );
  }
}