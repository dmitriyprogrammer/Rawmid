import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/utils/extension.dart';
import '../controller/navigation.dart';

class NavMenuView extends StatelessWidget {
  const NavMenuView({super.key, this.nav});

  final bool? nav;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Obx(() => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacityX(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 3)
              )
            ]
        ),
        child: TabBar(
            controller: controller.tabController,
            indicatorColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 10),
            tabs: List.generate(controller.widgetOptions.length, (index) => IconButton(
                onPressed: () {
                  if (controller.tabController != null) {
                    controller.tabController?.animateTo(index);
                  }

                  controller.activeTab.value = index;

                  if (nav ?? false) {
                    if (Navigator.canPop(context)) {
                      Get.back();
                    }
                  }
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 56, minHeight: 56, maxHeight: 56),
                icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icon/${index + 1}${controller.activeTab.value == index ? '_active' : ''}.png', width: 20, height: 20),
                            FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                    controller.titles[index],
                                    style: TextStyle(
                                        color: controller.activeTab.value == index ? Color(0xFF14BFFF) : Color(0xFFBABABA),
                                        fontSize: 11,
                                        letterSpacing: 0.1,
                                        fontWeight: FontWeight.w900
                                    )
                                )
                            )
                          ]
                      ),
                      if (index == 3 && controller.cartProducts.isNotEmpty) Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle
                              ),
                              constraints: BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20
                              ),
                              child: Text(
                                  '${controller.cartProducts.map((e) => e.quantity).reduce((a, b) => (a ?? 0) + (b ?? 0))}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11
                                  ),
                                  textAlign: TextAlign.center
                              )
                          )
                      ),
                      if (index == 2 && controller.wishlist.isNotEmpty) Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle
                              ),
                              constraints: BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20
                              ),
                              child: Text(
                                  '${controller.wishlist.length}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11
                                  ),
                                  textAlign: TextAlign.center
                              )
                          )
                      )
                    ]
                )
            ))
        ))
    );
  }
}