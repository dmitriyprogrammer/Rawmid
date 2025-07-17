import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../controller/club.dart';
import '../../utils/constant.dart';
import '../../widget/h.dart';
import '../../widget/primary_button.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../home/shop.dart';
import '../user/achive_items.dart';

class ClubView extends GetView<NavigationController> {
  const ClubView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClubController>(
        init: ClubController(),
        builder: (club) => Container(
          color: Colors.white,
          height: Get.height,
          child: SafeArea(
              bottom: false,
              child: Obx(() => club.isLoading.value ? SingleChildScrollView(
                  child: Stack(
                      children: [
                        Column(
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
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                      children: [
                                        h(16),
                                        ModuleTitle(title: 'Клуб', type: true),
                                        Container(
                                            width: double.infinity,
                                            height: 200,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFF2F2F2F),
                                              image: DecorationImage(image: AssetImage('assets/image/club.png')),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Ваш ранг',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          height: 1.30
                                                      )
                                                  ),
                                                  h(12),
                                                  Text(
                                                      controller.user.value?.rangStr ?? 'Новичок',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 32,
                                                          fontWeight: FontWeight.w600,
                                                          height: 1.20
                                                      )
                                                  ),
                                                  Spacer(),
                                                  Stack(
                                                      children: [
                                                        Container(
                                                            height: 35,
                                                            width: Get.width,
                                                            decoration: BoxDecoration(
                                                                color: Colors.blue.shade200,
                                                                borderRadius: BorderRadius.circular(34)
                                                            )
                                                        ),
                                                        Container(
                                                            height: 35,
                                                            width: Get.width * ((controller.user.value?.rang ?? 0) / 12000),
                                                            decoration: BoxDecoration(
                                                              color: Colors.blue,
                                                              borderRadius: BorderRadius.circular(34),
                                                            ),
                                                            alignment: Alignment.center
                                                        ),
                                                        Positioned(
                                                            top: 0,
                                                            bottom: 0,
                                                            left: 0,
                                                            right: 0,
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                spacing: 3,
                                                                children: [
                                                                  Row(
                                                                      spacing: 4,
                                                                      children: [
                                                                        Text(
                                                                            '${controller.user.value?.rang ?? 0}',
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w600
                                                                            )
                                                                        ),
                                                                        Image.asset('assets/icon/rang.png')
                                                                      ]
                                                                  ),
                                                                  Text(
                                                                      '/',
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w600,
                                                                      )
                                                                  ),
                                                                  Row(
                                                                      spacing: 4,
                                                                      children: [
                                                                        Text(
                                                                            '12000',
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w600
                                                                            )
                                                                        ),
                                                                        Image.asset('assets/icon/rang.png')
                                                                      ]
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                      ]
                                                  )
                                                ]
                                            )
                                        ),
                                        h(12),
                                        IntrinsicHeight(
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              spacing: 12,
                                              children: [
                                                Expanded(
                                                    child: GestureDetector(
                                                      onTap: () => Get.to(() => AchiveItemsView(items: club.achievements, type: false)),
                                                      child: Container(
                                                          decoration: ShapeDecoration(
                                                              gradient: LinearGradient(
                                                                  begin: Alignment(-0.16, -0.32),
                                                                  end: Alignment(0.88, 0.79),
                                                                  colors: [const Color(0xFF00E200), const Color(0xFF00AF7A)]
                                                              ),
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                          ),
                                                          clipBehavior: Clip.antiAlias,
                                                          padding: EdgeInsets.all(16),
                                                          child: Stack(
                                                              clipBehavior: Clip.none,
                                                              children: [
                                                                Positioned(
                                                                    right: -16,
                                                                    top: -16,
                                                                    bottom: 0,
                                                                    child: Image.asset('assets/image/c1.png', fit: BoxFit.cover)
                                                                ),
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    spacing: 40,
                                                                    children: [
                                                                      Text(
                                                                          'Полученные награды',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                              height: 1.30
                                                                          )
                                                                      ),
                                                                      Row(
                                                                          spacing: 4,
                                                                          children: [
                                                                            Text(
                                                                                '${club.achievements.length}',
                                                                                style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 32,
                                                                                    fontWeight: FontWeight.w600
                                                                                )
                                                                            ),
                                                                            Text(
                                                                                '/',
                                                                                style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w500
                                                                                )
                                                                            ),
                                                                            Text(
                                                                                '${club.ranks.length}',
                                                                                style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w500
                                                                                )
                                                                            )
                                                                          ]
                                                                      )
                                                                    ]
                                                                )
                                                              ]
                                                          )
                                                      )
                                                    )
                                                ),
                                                Expanded(
                                                    child: GestureDetector(
                                                      onTap: () => Get.toNamed('/rewards'),
                                                      child: Container(
                                                          decoration: ShapeDecoration(
                                                              gradient: LinearGradient(
                                                                  begin: Alignment(0.25, -0.73),
                                                                  end: Alignment(0.88, 0.79),
                                                                  colors: [const Color(0xFF007FE2), const Color(0xFF0452C6)]
                                                              ),
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                          ),
                                                          clipBehavior: Clip.antiAlias,
                                                          padding: EdgeInsets.all(16),
                                                          child: Stack(
                                                              clipBehavior: Clip.none,
                                                              children: [
                                                                Positioned(
                                                                    right: -16,
                                                                    top: -16,
                                                                    bottom: 0,
                                                                    child: Image.asset('assets/image/c2.png', fit: BoxFit.cover)
                                                                ),
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    spacing: 40,
                                                                    children: [
                                                                      Text(
                                                                          'Балланс бонусных баллов',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                              height: 1.30
                                                                          )
                                                                      ),
                                                                      Row(
                                                                          spacing: 4,
                                                                          children: [
                                                                            Text(
                                                                                '${controller.user.value?.rang ?? ''}',
                                                                                style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 32,
                                                                                    fontWeight: FontWeight.w600
                                                                                )
                                                                            ),
                                                                            Image.asset('assets/icon/rang2.png', width: 24, height: 24)
                                                                          ]
                                                                      )
                                                                    ]
                                                                )
                                                              ]
                                                          )
                                                      )
                                                    )
                                                )
                                              ]
                                          )
                                        ),
                                        h(12),
                                        PrimaryButton(text: 'Все достижения', height: 40, background: Colors.white, borderColor: primaryColor, textStyle: TextStyle(color: primaryColor), onPressed: () => Get.toNamed('/achieviment')),
                                        if (controller.user.value != null) h(32),
                                        if (controller.user.value != null) ModuleTitle(title: 'Мой контент', type: true, callback: () => Get.toNamed('/club_content'))
                                      ]
                                  )
                              ),
                              if (club.banners.isNotEmpty && controller.user.value != null) Container(
                                  padding: EdgeInsets.only(left: 20),
                                  height: 120,
                                  child: PageView(
                                    controller: club.pageController,
                                    onPageChanged: (val) => club.activeIndex.value = val,
                                    padEnds: false,
                                    children: club.banners.map((banner) => Container(
                                        height: 120,
                                        padding: const EdgeInsets.all(19),
                                        margin: const EdgeInsets.only(right: 12),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                            color: const Color(0xFFEBF3F6),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12)
                                            )
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              right: -18,
                                              top: -18,
                                              bottom: -18,
                                              child: Image.asset(banner['image'], fit: BoxFit.cover)
                                            ),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                spacing: 16,
                                                children: [
                                                  Expanded(
                                                      child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Flexible(
                                                                child: Image.asset(banner['icon'], width: 17, height: 16)
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                                banner['title'],
                                                                style: TextStyle(
                                                                    color: const Color(0xFF1E1E1E),
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500
                                                                )
                                                            ),
                                                            Row(
                                                                spacing: 3,
                                                                children: [
                                                                  Text(
                                                                      'Всего:',
                                                                      style: TextStyle(
                                                                          color: const Color(0xFF8A95A8),
                                                                          fontSize: 14
                                                                      )
                                                                  ),
                                                                  Text(
                                                                      '${banner['count']}',
                                                                      style: TextStyle(
                                                                          color: const Color(0xFF8A95A8),
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.w600
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                          ]
                                                      )
                                                  ),
                                                  PrimaryButton(text: 'Подробнее', height: 40, width: 127, onPressed: () => Get.toNamed(banner['link'], arguments: banner['arguments'], parameters: banner['parameters']))
                                                ]
                                            )
                                          ]
                                        )
                                    )).toList(),
                                  )
                              ),
                              if (club.banners.length > 1) h(24),
                              if (club.banners.length > 1) Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(club.banners.length, (index) => GestureDetector(
                                      onTap: () async {
                                        await club.pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                        club.activeIndex.value = index;
                                      },
                                      child: Container(
                                          width: 10,
                                          height: 10,
                                          margin: EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(
                                              color: club.activeIndex.value == index ? Colors.blue : Color(0xFF00ADEE).withOpacityX(0.2),
                                              shape: BoxShape.circle
                                          )
                                      )
                                  ))
                              ),
                              if (club.products.isNotEmpty) StoreSection(title: 'Избранное', products: club.products, showMore: () => controller.onItemTapped(2), addWishlist: club.addWishlist, buy: (id) async {
                                await controller.addCart(id);
                                club.update();
                              }),
                              h(20)
                            ]
                        ),
                        SearchWidget()
                      ]
                  )) : Center(
                  child: CircularProgressIndicator(color: primaryColor)
              ))
          )
        )
    );
  }
}