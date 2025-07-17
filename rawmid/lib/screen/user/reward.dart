import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/reward.dart';
import '../../utils/constant.dart';
import '../../widget/h.dart';

class RewardView extends StatelessWidget {
  const RewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RewardController>(
        init: RewardController(),
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
        body: SafeArea(
            bottom: false,
            child: Obx(() => !controller.isLoading.value ? Center(
                child: CircularProgressIndicator(color: primaryColor)
            ) : Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: controller.rewards.keys.map((date) {
                      var colorIndex = 0;

                      return Container(
                          decoration: ShapeDecoration(
                              color: const Color(0xFFF5F5F5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)
                              )
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    date,
                                    style: TextStyle(
                                        color: const Color(0xFFA6A6A6),
                                        fontSize: 16.47,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.67
                                    )
                                ),
                                h(10),
                                Column(
                                    spacing: 10,
                                    children: controller.rewards[date]!.reversed.map((item) {
                                      List<Color> colors = [Color(0xFFD9D9D9), Color(0xFF258BDF), Color(0xFF33CFC2)];
                                      final i = colorIndex % colors.length;
                                      colorIndex++;

                                      return Row(
                                          spacing: 10,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: item.text.contains('достижени') ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Row(
                                                    spacing: 9,
                                                    crossAxisAlignment: item.text.contains('достижени') ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                          width: 38,
                                                          height: 38,
                                                          decoration: ShapeDecoration(
                                                              color: colors[i],
                                                              shape: OvalBorder()
                                                          ),
                                                          alignment: Alignment.center,
                                                          child: Image.asset('assets/icon/${i == 1 ? 'kep' : i == 2 ? 'kar' : 'calendar2'}.png', width: 18)
                                                      ),
                                                      Expanded(
                                                          child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                if (item.text.contains('достижени')) Text(
                                                                    controller.extractFragment(item.text),
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 20,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w600,
                                                                        height: 1.37
                                                                    )
                                                                ),
                                                                if (item.text.contains('достижени')) Text(
                                                                  '-Полученно достижение. Поздравляем!',
                                                                  style: TextStyle(
                                                                    color: const Color(0xFFA6A6A6),
                                                                    fontSize: 16.47,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w400,
                                                                    height: 1.67,
                                                                  ),
                                                                ),
                                                                if (!item.text.contains('достижени')) Text(
                                                                    item.text.replaceAll('№ заказа', 'Заказ'),
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 20,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w600,
                                                                        height: 1.37
                                                                    )
                                                                )
                                                              ]
                                                          )
                                                      )
                                                    ]
                                                )
                                            ),
                                            Text(
                                                item.reward,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.25
                                                )
                                            )
                                          ]
                                      );
                                    }).toList()
                                )
                              ]
                          )
                      );
                    }).toList()
                  )
                )
            ))
        )
    ));
  }
}