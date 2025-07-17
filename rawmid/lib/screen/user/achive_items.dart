import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/utils/extension.dart';
import '../../../widget/h.dart';
import '../../model/club/achievement.dart';

class AchiveItemsView extends StatelessWidget {
  const AchiveItemsView({super.key, required this.items, required this.type});

  final List<AchievementModel> items;
  final bool type;

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [Color(0xFFE4CEB6), Color(0xFFCCF5FF), Color(0xFFB5DDFF)];
    List<Color> textColors = [Color(0xFFAF987E), Color(0xFF6AB8CA), Color(0xFF90B7D8)];
    List<Color> titleColors = [Color(0xFF5D4F3F), Color(0xFF005569), Color(0xFF2C5171)];
    var colorIndex = 0;

    return Scaffold(
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
            child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 8,
                        mainAxisExtent: 256
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final e = items[index];
                      colorIndex++;
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
                    })
            )
        )
    );
  }
}