import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rawmid/model/club/achievement.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../model/home/achieviment.dart';
import '../../widget/h.dart';
import '../../widget/primary_button.dart';
import '../../widget/tooltip.dart';
import '../../widget/w.dart';
import 'package:get/get.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key, required this.item, required this.callback});

  final AchievimentModel item;
  final Function() callback;

  @override
  Widget build(BuildContext context) {
    int colorIndex = 0;
    int rIndex = 1;

    for (var (index, i) in item.achievements.indexed) {
      if ((int.tryParse('${i.reward}') ?? 0) >= item.rang) {
        rIndex = index - 1;
        break;
      }
    }

    if (rIndex < 0) {
      rIndex = 1;
    }

    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          h(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ModuleTitle(title: 'Достижения', callback: callback, type: true),
                Row(
                    children: [
                      Text(
                          'Ваш ранг:',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color(0xFF8A95A8),
                              fontSize: 14
                          )
                      ),
                      w(4),
                      Text(
                          item.name,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 14
                          )
                      )
                    ]
                ),
                h(8),
                TooltipWidget(
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
                              width: Get.width * (item.rang / item.max),
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
                                  children: [
                                    Row(
                                        children: [
                                          Text(
                                              '${item.rang}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600
                                              )
                                          ),
                                          w(4),
                                          Image.asset('assets/icon/rang.png')
                                        ]
                                    ),
                                    w(3),
                                    Text(
                                        '/',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        )
                                    ),
                                    w(3),
                                    Row(
                                        children: [
                                          Text(
                                              '${item.max}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600
                                              )
                                          ),
                                          w(4),
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
                          child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'За что можно получить баллы?',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                          ),
                                          Transform.translate(
                                              offset: Offset(15, 0),
                                              child: IconButton(
                                                  icon: const Icon(Icons.close),
                                                  onPressed: Get.back
                                              )
                                          )
                                        ]
                                    ),
                                    const Divider(height: 1),
                                    h(20),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Действие',
                                              style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                          Text(
                                              'Начислим',
                                              style: TextStyle(fontWeight: FontWeight.bold)
                                          )
                                        ]
                                    ),
                                    h(10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Отзыв',
                                              style: TextStyle(fontSize: 14)
                                          ),
                                          Text(
                                              '150',
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    ),
                                    h(10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Отзыв с 2 фото и более',
                                              style: TextStyle(fontSize: 14)
                                          ),
                                          Text(
                                              '300',
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    ),
                                    h(10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Отзыв с 4 фото и более',
                                              style: TextStyle(fontSize: 14)
                                          ),
                                          Text(
                                              '500',
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    ),
                                    h(10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Посещение клуба (в день)',
                                              style: TextStyle(fontSize: 14)
                                          ),
                                          Text(
                                              '25',
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    ),
                                    h(10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Публикация статьи',
                                              style: TextStyle(fontSize: 14)
                                          ),
                                          Text(
                                              '200',
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    ),
                                    h(10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Публикация рецепта',
                                              style: TextStyle(fontSize: 14)
                                          ),
                                          Text(
                                              '150',
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    ),
                                    h(10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Публикация обзора',
                                              style: TextStyle(fontSize: 14)
                                          ),
                                          Text(
                                              '250',
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    ),
                                    h(10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Вопрос',
                                              style: TextStyle(fontSize: 14)
                                          ),
                                          Text(
                                              '30',
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    ),
                                    h(10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Комментарий',
                                              style: TextStyle(fontSize: 14)
                                          ),
                                          Text(
                                              '25',
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    ),
                                    h(10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Вступление в клуб',
                                              style: TextStyle(fontSize: 14)
                                          ),
                                          Text(
                                              '200',
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    ),
                                    h(10),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Подписка на новости (в мес)',
                                              style: TextStyle(fontSize: 14)
                                          ),
                                          Text(
                                              '100',
                                              style: TextStyle(fontSize: 14)
                                          )
                                        ]
                                    )
                                  ]
                              )
                          )
                      )
                  );
                })
              ]
            )
          ),
          if (item.achievements.isNotEmpty) h(30),
          if (item.achievements.isNotEmpty) SizedBox(
            height: 256,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.5, initialPage: rIndex),
              itemCount: item.achievements.length,
              itemBuilder: (context, index) {
                colorIndex++;
                return _buildAchievementCard(item.achievements[index], colorIndex);
              }
            )
          ),
          if (item.achievements.isNotEmpty) h(30)
        ]
      )
    );
  }

  Widget _buildAchievementCard(AchievementModel e, int colorIndex) {
    final type = (e.progress?.current ?? 0) < (e.progress?.max ?? 1);
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
