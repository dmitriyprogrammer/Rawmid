import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../controller/club.dart';
import '../../model/club/achievement.dart';
import '../../utils/constant.dart';
import '../../widget/h.dart';
import '../../widget/primary_button.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../../widget/tooltip.dart';
import '../user/achive_items.dart';

class AchievimentView extends StatelessWidget {
  const AchievimentView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ClubController>()) {
      Get.put(ClubController());
    }

    final controller = Get.find<ClubController>();

    var colorIndex = 0;
    var colorIndex2 = 0;

    return Scaffold(
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
            child: Obx(() {
              final auth = controller.user.value != null;
              final items = controller.achievements;
              final items2 = controller.notAchievements;
              final rang = controller.user.value?.rang ?? 0;

              return controller.isLoading.value ? SingleChildScrollView(
                  child: Stack(
                      children: [
                        Column(
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
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        h(16),
                                        ModuleTitle(title: 'Достижения', type: true),
                                        GestureDetector(
                                          onTap: () => Get.toNamed('/rewards'),
                                          child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: ShapeDecoration(
                                                  gradient: LinearGradient(
                                                      begin: Alignment(0.25, -0.73),
                                                      end: Alignment(0.88, 0.79),
                                                      colors: [const Color(0xFF007FE2), const Color(0xFF0452C6)]
                                                  ),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                              ),
                                              child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Positioned(
                                                        right: -74,
                                                        top: 104,
                                                        child: Container(
                                                            transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-0.45),
                                                            width: 335.74,
                                                            height: 110,
                                                            decoration: ShapeDecoration(
                                                                color: const Color(0xFF1475FF).withOpacityX(0.6),
                                                                shape: OvalBorder()
                                                            )
                                                        )
                                                    ),
                                                    Column(
                                                        spacing: 4,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                              'Баланс бонусных балов',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.w700,
                                                                  height: 1.30
                                                              )
                                                          ),
                                                          Row(
                                                              spacing: 6,
                                                              children: [
                                                                Text(
                                                                    '$rang',
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 40,
                                                                        fontWeight: FontWeight.w600
                                                                    )
                                                                ),
                                                                Image.asset('assets/icon/rang2.png', width: 35)
                                                              ]
                                                          ),
                                                          h(20),
                                                          Text(
                                                              'Выполняйте задания, пишите обзоры, рецепты и прочее, получайте за это баллы и покупайте на них товары RAWMID',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12
                                                              )
                                                          )
                                                        ]
                                                    )
                                                  ]
                                              )
                                          )
                                        ),
                                        h(24),
                                        Row(
                                            spacing: 4,
                                            children: [
                                              Text(
                                                  'Ваш ранг:',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Color(0xFF8A95A8),
                                                      fontSize: 14
                                                  )
                                              ),
                                              Text(
                                                  controller.user.value?.rangStr ?? 'Новичок',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Color(0xFF1E1E1E),
                                                      fontSize: 14
                                                  )
                                              )
                                            ]
                                        ),
                                        h(8),
                                        if (items.isNotEmpty && auth) TooltipWidget(
                                            message: 'Набрано Вами баллов / Количество баллов до следующего ранга.',
                                            left: 20,
                                            child: Stack(
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
                                                      width: Get.width * (rang / 12000),
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
                                                                      '$rang',
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
                                        ),
                                        h(10),
                                        PrimaryButton(text: 'Как получить баллы?', height: 38, onPressed: () {
                                          showDialog(
                                              context: Get.context!,
                                              builder: (context) => Dialog(
                                                  backgroundColor: Colors.white,
                                                  insetPadding: EdgeInsets.symmetric(horizontal: 20),
                                                  child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage('assets/image/beck.png'), fit: BoxFit.cover, alignment: Alignment.topCenter),
                                                          borderRadius: BorderRadius.circular(25)
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                              decoration: ShapeDecoration(
                                                                  color: Colors.white,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(25)
                                                                  )
                                                              ),
                                                              margin: EdgeInsets.only(top: 280),
                                                              padding: EdgeInsets.all(20),
                                                              child: SingleChildScrollView(
                                                                  child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text(
                                                                            'Копите баллы и обменивайте их на технику мечты!',
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 24,
                                                                                fontFamily: 'Inter',
                                                                                fontWeight: FontWeight.w800,
                                                                                height: 1.14
                                                                            )
                                                                        ),
                                                                        h(20),
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            spacing: 10,
                                                                            children: [
                                                                              Row(
                                                                                  spacing: 10,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                        width: 24.01,
                                                                                        height: 24.01,
                                                                                        margin: EdgeInsets.only(top: 4),
                                                                                        decoration: ShapeDecoration(
                                                                                            color: const Color(0xFFD9D9D9),
                                                                                            shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(5.72)
                                                                                            )
                                                                                        ),
                                                                                        alignment: Alignment.center,
                                                                                        child: Image.asset('assets/icon/p1.png', width: 12)
                                                                                    ),
                                                                                    Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        spacing: 2,
                                                                                        children: [
                                                                                          Text(
                                                                                              'Публикация отзыва',
                                                                                              style: TextStyle(
                                                                                                  color: Colors.black,
                                                                                                  fontSize: 16.47,
                                                                                                  fontFamily: 'Inter',
                                                                                                  fontWeight: FontWeight.w400
                                                                                              )
                                                                                          ),
                                                                                          Text(
                                                                                              'Отзыв с двумя фото и более',
                                                                                              style: TextStyle(
                                                                                                  color: Colors.black,
                                                                                                  fontSize: 14,
                                                                                                  fontFamily: 'Inter',
                                                                                                  fontWeight: FontWeight.w400
                                                                                              )
                                                                                          ),
                                                                                          Text(
                                                                                              'Отзыв с 4 фото и более',
                                                                                              style: TextStyle(
                                                                                                  color: Colors.black,
                                                                                                  fontSize: 14,
                                                                                                  fontFamily: 'Inter',
                                                                                                  fontWeight: FontWeight.w400
                                                                                              )
                                                                                          )
                                                                                        ]
                                                                                    )
                                                                                  ]
                                                                              ),
                                                                              Column(
                                                                                  children: [
                                                                                    Text(
                                                                                        '+150',
                                                                                        textAlign: TextAlign.right,
                                                                                        style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 16.47,
                                                                                            fontFamily: 'Inter',
                                                                                            fontWeight: FontWeight.w400
                                                                                        )
                                                                                    ),
                                                                                    Text(
                                                                                        '+300',
                                                                                        textAlign: TextAlign.right,
                                                                                        style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 16.47,
                                                                                            fontFamily: 'Inter',
                                                                                            fontWeight: FontWeight.w400
                                                                                        )
                                                                                    ),
                                                                                    Text(
                                                                                        '+500',
                                                                                        textAlign: TextAlign.right,
                                                                                        style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 16.47,
                                                                                            fontFamily: 'Inter',
                                                                                            fontWeight: FontWeight.w400
                                                                                        )
                                                                                    )
                                                                                  ]
                                                                              )
                                                                            ]
                                                                        ),
                                                                        h(10),
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            spacing: 10,
                                                                            children: [
                                                                              Expanded(
                                                                                  child: Row(
                                                                                      spacing: 10,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                            width: 24.01,
                                                                                            height: 24.01,
                                                                                            decoration: ShapeDecoration(
                                                                                                color: const Color(0xFFD9D9D9),
                                                                                                shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(5.72)
                                                                                                )
                                                                                            ),
                                                                                            alignment: Alignment.center,
                                                                                            child: Image.asset('assets/icon/p2.png', width: 12)
                                                                                        ),
                                                                                        Text(
                                                                                            'Посещение клуба ежедневно',
                                                                                            style: TextStyle(
                                                                                                color: Colors.black,
                                                                                                fontSize: 16.47,
                                                                                                fontFamily: 'Inter',
                                                                                                fontWeight: FontWeight.w400
                                                                                            )
                                                                                        )
                                                                                      ]
                                                                                  )
                                                                              ),
                                                                              Text(
                                                                                  '+25',
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 16.47,
                                                                                      fontFamily: 'Inter',
                                                                                      fontWeight: FontWeight.w400
                                                                                  )
                                                                              )
                                                                            ]
                                                                        ),
                                                                        h(10),
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            spacing: 10,
                                                                            children: [
                                                                              Row(
                                                                                  spacing: 10,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                        width: 24.01,
                                                                                        height: 24.01,
                                                                                        decoration: ShapeDecoration(
                                                                                            color: const Color(0xFFD9D9D9),
                                                                                            shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(5.72)
                                                                                            )
                                                                                        ),
                                                                                        alignment: Alignment.center,
                                                                                        child: Image.asset('assets/icon/p3.png', width: 12)
                                                                                    ),
                                                                                    Text(
                                                                                        'Публикация статьи',
                                                                                        style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 16.47,
                                                                                            fontFamily: 'Inter',
                                                                                            fontWeight: FontWeight.w400
                                                                                        )
                                                                                    )
                                                                                  ]
                                                                              ),
                                                                              Text(
                                                                                  '+200',
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 16.47,
                                                                                      fontFamily: 'Inter',
                                                                                      fontWeight: FontWeight.w400
                                                                                  )
                                                                              )
                                                                            ]
                                                                        ),
                                                                        h(10),
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            spacing: 10,
                                                                            children: [
                                                                              Row(
                                                                                  spacing: 10,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                        width: 24.01,
                                                                                        height: 24.01,
                                                                                        decoration: ShapeDecoration(
                                                                                            color: const Color(0xFFD9D9D9),
                                                                                            shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(5.72)
                                                                                            )
                                                                                        ),
                                                                                        alignment: Alignment.center,
                                                                                        child: Image.asset('assets/icon/p4.png', width: 12)
                                                                                    ),
                                                                                    Text(
                                                                                        'Публикация рецепта',
                                                                                        style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 16.47,
                                                                                            fontFamily: 'Inter',
                                                                                            fontWeight: FontWeight.w400
                                                                                        )
                                                                                    )
                                                                                  ]
                                                                              ),
                                                                              Text(
                                                                                  '+150',
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 16.47,
                                                                                      fontFamily: 'Inter',
                                                                                      fontWeight: FontWeight.w400
                                                                                  )
                                                                              )
                                                                            ]
                                                                        ),
                                                                        h(10),
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            spacing: 10,
                                                                            children: [
                                                                              Expanded(
                                                                                  child: Row(
                                                                                      spacing: 10,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                            width: 24.01,
                                                                                            height: 24.01,
                                                                                            decoration: ShapeDecoration(
                                                                                                color: const Color(0xFFD9D9D9),
                                                                                                shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(5.72)
                                                                                                )
                                                                                            ),
                                                                                            alignment: Alignment.center,
                                                                                            child: Image.asset('assets/icon/p5.png', width: 12)
                                                                                        ),
                                                                                        Text(
                                                                                            'Публикация обзора техники',
                                                                                            style: TextStyle(
                                                                                                color: Colors.black,
                                                                                                fontSize: 16.47,
                                                                                                fontFamily: 'Inter',
                                                                                                fontWeight: FontWeight.w400
                                                                                            )
                                                                                        )
                                                                                      ]
                                                                                  )
                                                                              ),
                                                                              Text(
                                                                                  '+250',
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 16.47,
                                                                                      fontFamily: 'Inter',
                                                                                      fontWeight: FontWeight.w400
                                                                                  )
                                                                              )
                                                                            ]
                                                                        ),
                                                                        h(10),
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            spacing: 10,
                                                                            children: [
                                                                              Row(
                                                                                  spacing: 10,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                        width: 24.01,
                                                                                        height: 24.01,
                                                                                        decoration: ShapeDecoration(
                                                                                            color: const Color(0xFFD9D9D9),
                                                                                            shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(5.72)
                                                                                            )
                                                                                        ),
                                                                                        alignment: Alignment.center,
                                                                                        child: Image.asset('assets/icon/p6.png', width: 12)
                                                                                    ),
                                                                                    Text(
                                                                                        'Вопрос',
                                                                                        style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 16.47,
                                                                                            fontFamily: 'Inter',
                                                                                            fontWeight: FontWeight.w400
                                                                                        )
                                                                                    )
                                                                                  ]
                                                                              ),
                                                                              Text(
                                                                                  '+30',
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 16.47,
                                                                                      fontFamily: 'Inter',
                                                                                      fontWeight: FontWeight.w400
                                                                                  )
                                                                              )
                                                                            ]
                                                                        ),
                                                                        h(10),
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            spacing: 10,
                                                                            children: [
                                                                              Row(
                                                                                  spacing: 10,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                        width: 24.01,
                                                                                        height: 24.01,
                                                                                        decoration: ShapeDecoration(
                                                                                            color: const Color(0xFFD9D9D9),
                                                                                            shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(5.72)
                                                                                            )
                                                                                        ),
                                                                                        alignment: Alignment.center,
                                                                                        child: Image.asset('assets/icon/p7.png', width: 12)
                                                                                    ),
                                                                                    Text(
                                                                                        'Комментарий',
                                                                                        style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 16.47,
                                                                                            fontFamily: 'Inter',
                                                                                            fontWeight: FontWeight.w400
                                                                                        )
                                                                                    )
                                                                                  ]
                                                                              ),
                                                                              Text(
                                                                                  '+25',
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 16.47,
                                                                                      fontFamily: 'Inter',
                                                                                      fontWeight: FontWeight.w400
                                                                                  )
                                                                              )
                                                                            ]
                                                                        ),
                                                                        h(10),
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            spacing: 10,
                                                                            children: [
                                                                              Row(
                                                                                  spacing: 10,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                        width: 24.01,
                                                                                        height: 24.01,
                                                                                        decoration: ShapeDecoration(
                                                                                            color: const Color(0xFFD9D9D9),
                                                                                            shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(5.72)
                                                                                            )
                                                                                        ),
                                                                                        alignment: Alignment.center,
                                                                                        child: Image.asset('assets/icon/p8.png', width: 12)
                                                                                    ),
                                                                                    Text(
                                                                                        'Вступление в клуб',
                                                                                        style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 16.47,
                                                                                            fontFamily: 'Inter',
                                                                                            fontWeight: FontWeight.w400
                                                                                        )
                                                                                    )
                                                                                  ]
                                                                              ),
                                                                              Text(
                                                                                  '+200',
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 16.47,
                                                                                      fontFamily: 'Inter',
                                                                                      fontWeight: FontWeight.w400
                                                                                  )
                                                                              )
                                                                            ]
                                                                        ),
                                                                        h(10),
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            spacing: 10,
                                                                            children: [
                                                                              Expanded(
                                                                                  child: Row(
                                                                                      spacing: 10,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                            width: 24.01,
                                                                                            height: 24.01,
                                                                                            decoration: ShapeDecoration(
                                                                                                color: const Color(0xFFD9D9D9),
                                                                                                shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(5.72)
                                                                                                )
                                                                                            ),
                                                                                            alignment: Alignment.center,
                                                                                            child: Image.asset('assets/icon/p9.png', width: 12)
                                                                                        ),
                                                                                        Expanded(
                                                                                            child: Text(
                                                                                                'Подписка на новости (в месяц)',
                                                                                                style: TextStyle(
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 16.47,
                                                                                                    fontFamily: 'Inter',
                                                                                                    fontWeight: FontWeight.w400
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                      ]
                                                                                  )
                                                                              ),
                                                                              Text(
                                                                                  '+100',
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 16.47,
                                                                                      fontFamily: 'Inter',
                                                                                      fontWeight: FontWeight.w400
                                                                                  )
                                                                              )
                                                                            ]
                                                                        )
                                                                      ]
                                                                  )
                                                              )
                                                          ),
                                                          Positioned(
                                                            left: 20,
                                                            top: 20,
                                                            child: GestureDetector(
                                                              onTap: Get.back,
                                                              child: Image.asset('assets/icon/b4.png', width: 50, height: 50)
                                                            )
                                                          )
                                                        ]
                                                      )
                                                  )
                                              )
                                          );
                                        }),
                                        if (items.isNotEmpty && auth) h(40),
                                        if (items.isNotEmpty && auth) ModuleTitle(title: 'Полученные награды', type: true)
                                      ]
                                  )
                              ),
                              if (items.isNotEmpty && auth) SizedBox(
                                  height: 256,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: items.length,
                                    padding: EdgeInsets.only(left: 14),
                                    itemBuilder: (context, index) {
                                      colorIndex++;
                                      return _buildAchievementCard(items[index], colorIndex, false);
                                    }
                                  )
                              ),
                              if (items.isNotEmpty && auth) h(20),
                              if (items.isNotEmpty && auth) Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: PrimaryButton(text: 'Смотреть все', height: 38, onPressed: () => Get.to(() => AchiveItemsView(items: items, type: false)))
                              ),
                              if (items2.isNotEmpty && auth) h(40),
                              if (items2.isNotEmpty && auth) Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ModuleTitle(title: 'Близки к получению', type: true)
                                      ]
                                  )
                              ),
                              if (items2.isNotEmpty && auth) SizedBox(
                                  height: 256,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: items2.length,
                                      padding: EdgeInsets.only(left: 14),
                                      itemBuilder: (context, index) {
                                        colorIndex2++;
                                        return _buildAchievementCard(items2[index], colorIndex2, false);
                                      }
                                  )
                              ),
                              if (items.isNotEmpty && auth) h(20),
                              if (items.isNotEmpty && auth) Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: PrimaryButton(text: 'Смотреть все', height: 38, onPressed: () => Get.to(() => AchiveItemsView(items: items2, type: true)))
                              ),
                              h(20),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: PrimaryButton(text: 'Вернуться на главную', height: 40, background: Colors.white, borderColor: primaryColor, borderWidth: 2, textStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w700), onPressed: () {
                                    final main = Get.find<NavigationController>();
                                    main.onItemTapped(0);
                                    Get.back();
                                    Get.back();
                                  })
                              ),
                              h(20 + MediaQuery.of(context).viewPadding.bottom),
                            ]
                        ),
                        SearchWidget()
                      ]
                  )) : Center(
                  child: CircularProgressIndicator(color: primaryColor)
              );
            })
        )
    );
  }

  Widget _buildAchievementCard(AchievementModel e, int colorIndex, bool type) {
    List<Color> colors = [Color(0xFFE4CEB6), Color(0xFFCCF5FF), Color(0xFFB5DDFF)];
    List<Color> textColors = [Color(0xFFAF987E), Color(0xFF6AB8CA), Color(0xFF90B7D8)];
    List<Color> titleColors = [Color(0xFF5D4F3F), Color(0xFF005569), Color(0xFF2C5171)];
    final i = colorIndex % titleColors.length;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: Get.context!,
          builder: (context) => Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: Get.back,
                        child: Image.asset('assets/icon/b4.png', width: 50, height: 50)
                      ),
                      (e.progress?.current ?? 0) < (e.progress?.max ?? 0) ? Container(
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE5E5E5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(56),
                            )
                          ),
                          height: 50,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            spacing: 7,
                            children: [
                              Image.asset('assets/icon/r5.png', width: 20),
                              Text(
                                '${(e.progress?.current ?? 0)}/${(e.progress?.max ?? 0)}',
                                style: TextStyle(
                                  color: const Color(0xFF868686),
                                  fontSize: 18,
                                  fontFamily: 'Inter'
                                )
                              )
                            ]
                          )
                      ) : Image.asset('assets/image/vipo.png', width: 157, height: 47)
                    ]
                  ),
                  h(10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: CachedNetworkImage(
                      imageUrl: e.image,
                      errorWidget: (c, e, i) {
                        return Image.asset('assets/image/no_image.png');
                      }
                    )
                  ),
                  h(8),
                  Text(
                    e.title,
                    style: TextStyle(
                      color: const Color(0xFF212121),
                      fontSize: 34,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                      height: 1
                    )
                  ),
                  h(14),
                  e.text.length > 2 ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          e.text.first,
                          style: TextStyle(
                              color: const Color(0xFF212121),
                              fontSize: 26,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.15
                          )
                      ),
                      h(20),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Доступен для рангов:\n',
                              style: TextStyle(
                                color: const Color(0xFFAFAFAF),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600
                              )
                            ),
                            TextSpan(
                              text: e.text[1].replaceAll('Доступен для рангов:', '').trim(),
                              style: TextStyle(
                                color: const Color(0xFFAFAFAF),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400
                              )
                            )
                          ]
                        )
                      ),
                      if (e.text.length >= 2) h(12),
                      if (e.text.length >= 2) Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Для питания:\n',
                              style: TextStyle(
                                color: const Color(0xFFAFAFAF),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: e.text[2].replaceAll('Для питания:', '').trim(),
                              style: TextStyle(
                                color: const Color(0xFFAFAFAF),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400
                              )
                            )
                          ]
                        )
                      )
                    ]
                  ) : Text(
                    e.text.join("\r\n"),
                    style: TextStyle(fontSize: 14)
                  )
                ]
              )
            )
          )
        );
      },
      child: Container(
          width: 206,
          height: 256,
          margin: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: colors[colorIndex % colors.length],
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: CachedNetworkImage(
                      imageUrl: e.image,
                      fit: BoxFit.contain,
                      errorWidget: (c, e, i) {
                        return Image.asset('assets/image/no_image.png');
                      }
                  )
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(e.title, style: TextStyle(
                              color: titleColors[i],
                              fontSize: 18.18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                              height: 1.11,
                            ), maxLines: 2, overflow: TextOverflow.ellipsis)
                          )
                        ]
                      ),
                      h(4),
                      Row(
                          spacing: 4,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 6,
                              children: [
                                Image.asset('assets/icon/v${i == 1 ? '2' : i == 2 ? '4' : '3'}.png', width: 6),
                                Text(
                                  'узнать больше',
                                  style: TextStyle(
                                    color: textColors[colorIndex % textColors.length],
                                    fontSize: 12.12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400
                                  )
                                )
                              ]
                            ),
                            if (e.reward > 0) Row(
                              spacing: 2,
                              children: [
                                Text(
                                    '${e.reward}',
                                    style: TextStyle(
                                      color: textColors[colorIndex % textColors.length],
                                      fontSize: 12.12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400
                                    )
                                ),
                                Image.asset('assets/icon/r${i == 1 ? '2' : i == 2 ? '4' : '3'}.png', width: 13)
                              ]
                            )
                          ]
                      )
                    ]
                )
              ),
              if (type) Positioned(
                  top: 10,
                  left: 12,
                  child: Container(
                      decoration: ShapeDecoration(
                          color: Colors.black.withOpacityX(0.6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(42.26)
                          ),
                          shadows: [
                            BoxShadow(
                                color: Color(0x0F000000),
                                blurRadius: 4,
                                offset: Offset(0, 3),
                                spreadRadius: 0
                            )
                          ]
                      ),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: Row(
                          spacing: 5,
                          children: [
                            Image.asset('assets/icon/r6.png', width: 15),
                            Text(
                                '${(e.progress?.current ?? 0)}/${(e.progress?.max ?? 0)}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.58,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.67
                                )
                            )
                          ]
                      )
                  )
              )
            ]
          )
      )
    );
  }
}