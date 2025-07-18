import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/utils/moderate_status.dart';
import '../../controller/news.dart';
import '../../model/home/news.dart';
import '../../widget/h.dart';
import '../../widget/w.dart';
import '../news/news.dart';
import 'package:get/get.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.news, this.button, this.recipe, this.survey, this.my, this.callback});

  final NewsModel news;
  final bool? button;
  final bool? recipe;
  final bool? survey;
  final int? my;
  final Function()? callback;

  @override
  Widget build(BuildContext context) {
    final moderate = ModerateStatus(news.moderate);

    return GestureDetector(
      onTap: () {
        final params = Get.parameters;
        final t = '${(my ?? params['my'] ?? -1)}';

        if (moderate.isEditable) {
          if (t == '0') {
            Get.toNamed('/add_recipe', parameters: {'id': news.id})?.then((_) {
              Get.parameters = params;
              callback?.call();
            });
            return;
          } else if (t == '1') {
            Get.toNamed('/add_news', parameters: {'id': news.id})?.then((_) {
              Get.parameters = params;
              callback?.call();
            });
            return;
          }
        }

        Get.delete<NewsController>();
        Get.put(NewsController(news.id, recipe ?? false, survey ?? false));
        Get.to(() => NewsView(), preventDuplicates: false)?.then((_) => callback?.call());
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
              ]
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                        imageUrl: news.image,
                        errorWidget: (c, e, i) {
                          return SizedBox();
                        },
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover
                    )
                ),
                h(8),
                Text(
                    news.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                ),
                h(4),
                news.time.isNotEmpty ? Row(
                    children: [
                      Image.asset('assets/icon/time.png'),
                      w(4),
                      Text(
                          news.time,
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xFF8A95A8),
                              fontSize: 11
                          )
                      )
                    ]
                ) : h(20),
                if (news.time.isNotEmpty) h(4),
                Text(
                    news.text,
                    style: TextStyle(
                        color: Color(0xFF1B1B1B),
                        fontSize: 12
                    ),
                    maxLines: !(button ?? false) ? 2 : 5,
                    overflow: TextOverflow.ellipsis
                ),
                if (!(button ?? false)) Spacer(),
                if (!(button ?? false)) ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        minimumSize: Size(double.infinity, 40)
                    ),
                    onPressed: () {
                      final params = Get.parameters;
                      final t = '${(my ?? params['my'] ?? -1)}';

                      if (moderate.isEditable) {
                        if (t == '0') {
                          Get.toNamed('/add_recipe', parameters: {'id': news.id})?.then((_) {
                            Get.parameters = params;
                            callback?.call();
                          });
                          return;
                        } else if (t == '1') {
                          Get.toNamed('/add_news', parameters: {'id': news.id})?.then((_) {
                            Get.parameters = params;
                            callback?.call();
                          });
                          return;
                        }
                      }

                      Get.delete<NewsController>();
                      Get.put(NewsController(news.id, recipe ?? false, survey ?? false));
                      Get.to(() => NewsView())?.then((_) => callback?.call());
                    },
                    child: Text('Читать', style: TextStyle(fontSize: 14, color: Colors.white))
                )
              ]
          )
      )
    );
  }
}