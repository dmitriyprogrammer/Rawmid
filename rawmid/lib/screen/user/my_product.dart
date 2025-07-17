import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/user/register_product.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/utils/helper.dart';
import 'package:rawmid/widget/module_title.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../../widget/h.dart';
import '../../controller/my_product.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';

class MyProductView extends StatelessWidget {
  const MyProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyProductController>(
        init: MyProductController(),
        builder: (controller) => Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                titleSpacing: 0,
                leadingWidth: 0,
                leading: SizedBox.shrink(),
                title: Padding(
                    padding: const EdgeInsets.only(right: 20),
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
            body: Obx(() => SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    SingleChildScrollView(
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
                              Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        h(10),
                                        ModuleTitle(title: 'Регистрация товара', type: true),
                                        GestureDetector(
                                          onTap: () => Helper.openLink('https://madeindream.com/informatsija/product-registration.html?record_id=701'),
                                          child: Text(
                                              'Инструкция по регистрации',
                                              style: TextStyle(
                                                  color: const Color(0xFF0D80D9),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600
                                              )
                                          )
                                        ),
                                        h(23),
                                        Text(
                                          'При наступлении гарантийного случая обязательно наличие гарантийного талона и оригиналов чеков!',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                        h(11),
                                        Text(
                                          'Данные в чеках и талоне должны совпадать!',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                        h(23),
                                        PrimaryButton(text: 'Зарегистрировать товар', height: 48, onPressed: () => Get.toNamed('/add_product')),
                                        h(15),
                                        PrimaryButton(text: 'Проверить гарантию', height: 48, onPressed: () => Get.toNamed('/warranty_product')),
                                        if (controller.products.isNotEmpty) h(34),
                                        if (controller.products.isNotEmpty) ModuleTitle(title: 'Мои товары', type: true),
                                        if (controller.products.isNotEmpty) Column(
                                          spacing: 26,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(controller.products.length, (index) {
                                            final item = controller.products[index];

                                            return GestureDetector(
                                              onTap: () => Get.to(() => RegisterProductView(item: item)),
                                              child: Row(
                                                  spacing: 16,
                                                  children: [
                                                    Container(
                                                        width: 78,
                                                        height: 78,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: CachedNetworkImageProvider(item.image),
                                                                fit: BoxFit.cover
                                                            )
                                                        )
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                            spacing: 12,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                  item.name,
                                                                  style: TextStyle(
                                                                      color: const Color(0xFF1E1E1E),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w600
                                                                  )
                                                              ),
                                                              if (item.color.isNotEmpty) Row(
                                                                  spacing: 4,
                                                                  children: [
                                                                    Flexible(
                                                                        child: Text(
                                                                            'Цвет:',
                                                                            textAlign: TextAlign.right,
                                                                            style: TextStyle(
                                                                                color: const Color(0xFF8A95A8),
                                                                                fontSize: 11
                                                                            )
                                                                        )
                                                                    ),
                                                                    Expanded(
                                                                        child: Text(
                                                                            item.color,
                                                                            textAlign: TextAlign.right,
                                                                            style: TextStyle(
                                                                                color: const Color(0xFF1E1E1E),
                                                                                fontSize: 11
                                                                            )
                                                                        )
                                                                    )
                                                                  ]
                                                              )
                                                            ]
                                                        )
                                                    )
                                                  ]
                                              )
                                            );
                                          })
                                        ),
                                        h(40),
                                        PrimaryButton(text: 'Вернуться на главную', textStyle: TextStyle(
                                            color: primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            height: 1.30
                                        ), height: 48, background: Colors.white, borderColor: primaryColor, onPressed: () {
                                          Get.back();
                                          Get.back();
                                        }),
                                        h(MediaQuery.of(context).padding.bottom + 20)
                                      ]
                                  )
                              )
                            ]
                        )
                    ),
                    SearchWidget()
                  ]
                )
            ))
        )
    );
  }
}