import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:get/get.dart';
import 'package:rawmid/utils/helper.dart';
import 'package:share_plus/share_plus.dart';
import '../../controller/news.dart';
import '../../utils/constant.dart';
import '../../widget/h.dart';
// import '../../widget/primary_button.dart';
// import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../../widget/w.dart';
import '../home/shop.dart';
import '../product/zap.dart';

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0,
            leadingWidth: 0,
            leading: SizedBox.shrink(),
            title: Padding(
                padding: const EdgeInsets.only(left: 3, right: 20),
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
              final news = controller.news.value;

              return Stack(
                  alignment: Alignment.center,
                  children: [
                    if (controller.isLoading.value) Container(
                        height: Get.height,
                        color: Colors.white,
                        padding: EdgeInsets.only(bottom: 50 + MediaQuery.of(context).viewPadding.bottom),
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
                              Expanded(
                                  child: news != null ? SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            h(20),
                                            Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    Get.context!,
                                                                    PageRouteBuilder(
                                                                        opaque: false,
                                                                        pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: news.image),
                                                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                          return FadeTransition(opacity: animation, child: child);
                                                                        }
                                                                    )
                                                                );
                                                              },
                                                              child: Container(
                                                                  clipBehavior: Clip.antiAlias,
                                                                  decoration: ShapeDecoration(
                                                                      color: Color(0xFF1B1B1B),
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                                  ),
                                                                  child: CachedNetworkImage(
                                                                      imageUrl: news.image,
                                                                      errorWidget: (c, e, i) {
                                                                        return Image.asset('assets/image/no_image.png');
                                                                      },
                                                                      width: double.infinity,
                                                                      fit: BoxFit.cover
                                                                  )
                                                              )
                                                          ),
                                                          Positioned(
                                                            right: 20,
                                                            top: 20,
                                                            child: InkWell(
                                                                onTap: () async {
                                                                  final file = await Helper.downloadFileAsXFile(news.image, 'Share');

                                                                  SharePlus.instance.share(
                                                                    ShareParams(uri: Uri.parse(news.link), title: news.title, previewThumbnail: file),
                                                                  );
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: primaryColor), borderRadius: BorderRadius.all(Radius.circular(30))),
                                                                  width: 30,
                                                                  height: 30,
                                                                  child: Icon(Icons.share, size: 18)
                                                                )
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                      h(20),
                                                      Text(
                                                          news.title,
                                                          style: TextStyle(
                                                              color: Color(0xFF1E1E1E),
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w700
                                                          )
                                                      ),
                                                      h(16),
                                                      Wrap(
                                                          spacing: 15,
                                                          children: [
                                                            Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Image.asset('assets/icon/calendar.png', width: 16),
                                                                  w(4),
                                                                  Text(
                                                                      news.date,
                                                                      textAlign: TextAlign.right,
                                                                      style: TextStyle(
                                                                          color: Color(0xFF8A95A8),
                                                                          fontSize: 14
                                                                      )
                                                                  )
                                                                ]
                                                            ),
                                                            if (news.time.isNotEmpty) Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Image.asset('assets/icon/time.png', width: 16),
                                                                  w(4),
                                                                  Text(
                                                                      news.time,
                                                                      textAlign: TextAlign.right,
                                                                      style: TextStyle(
                                                                          color: Color(0xFF8A95A8),
                                                                          fontSize: 14
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                          ]
                                                      )
                                                    ]
                                                )
                                            ),
                                            h(20),
                                            if ((news.youtubeLink ?? '').isNotEmpty) Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                child: GestureDetector(
                                                    onTap: () => Helper.launchInBrowser(news.youtubeLink!),
                                                    child: Row(
                                                        spacing: 6,
                                                        children: [
                                                          Icon(Icons.play_circle_fill_rounded, color: dangerColor),
                                                          Text(
                                                              'Смотреть видео',
                                                              style: TextStyle(
                                                                  color: dangerColor,
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.w700
                                                              )
                                                          )
                                                        ]
                                                    )
                                                )
                                            ),
                                            h(20),
                                            if (news.text.isNotEmpty) Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                child: Html(
                                                    data: news.text.replaceAll('•', ''),
                                                    extensions: [
                                                      IframeHtmlExtension(),
                                                      TagExtension(
                                                        tagsToExtend: {'img'},
                                                        builder: (context) {
                                                          final src = context.attributes['src'] ?? '';

                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  Get.context!,
                                                                  PageRouteBuilder(
                                                                      opaque: false,
                                                                      pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: src),
                                                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                        return FadeTransition(opacity: animation, child: child);
                                                                      }
                                                                  )
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(vertical: 10),
                                                              child: Image.network(src)
                                                            )
                                                          );
                                                        }
                                                      )
                                                    ],
                                                    style: {
                                                      'ul': Style(
                                                          margin: Margins.all(0),
                                                          padding: HtmlPaddings.only(left: 10)
                                                      ),
                                                      '*': Style(
                                                        border: Border(),
                                                      ),
                                                      'br, hr': Style(
                                                          display: Display.none
                                                      ),
                                                      'span, p': Style(
                                                          width: Width.auto(),
                                                          display: Display.block
                                                      ),
                                                      'div': Style(
                                                          display: Display.block,
                                                          height: Height.auto(),
                                                          padding: HtmlPaddings.symmetric(vertical: 10)
                                                      ),
                                                      'a': Style(
                                                          textDecoration: TextDecoration.none,
                                                          display: Display.block,
                                                          margin: Margins.symmetric(vertical: 10)
                                                      ),
                                                      'span > a': Style(
                                                          textDecoration: TextDecoration.none,
                                                          display: Display.inlineBlock
                                                      )
                                                    },
                                                    onLinkTap: (val, map, element) {
                                                      if ((val ?? '').isNotEmpty) {
                                                        Helper.openLink(val!);
                                                      }
                                                    }
                                                )
                                            ),
                                            if (news.ingredients != null || news.energy != null) Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      h(20),
                                                      if (news.ingredients != null) Text(
                                                          'Ингредиенты',
                                                          style: TextStyle(
                                                              color: Color(0xFF1E1E1E),
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w700
                                                          )
                                                      ),
                                                      if (news.ingredients != null) h(20),
                                                      if (news.ingredients != null) Column(
                                                          children: List.generate(news.ingredients!.length, (index) {
                                                            final item = news.ingredients![index];

                                                            return Row(
                                                                spacing: 15,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                      child: Text(
                                                                          item.title,
                                                                          style: TextStyle(
                                                                              color: Color(0xFF1E1E1E),
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w600
                                                                          )
                                                                      )
                                                                  ),
                                                                  Expanded(
                                                                      child: Text(
                                                                          item.text,
                                                                          textAlign: TextAlign.right,
                                                                          style: TextStyle(
                                                                              color: Color(0xFF1E1E1E),
                                                                              fontSize: 14
                                                                          )
                                                                      )
                                                                  )
                                                                ]
                                                            );
                                                          })
                                                      ),
                                                      if (news.energy != null) h(20),
                                                      if (news.energy != null) Wrap(
                                                          children: List.generate(news.energy!.length, (index) {
                                                            final item = news.energy![index];

                                                            return Text(
                                                                '${item.title} - ${item.text}${index < news.energy!.length-1 ? ' / ' : ''}',
                                                                style: TextStyle(
                                                                    color: primaryColor,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w600
                                                                )
                                                            );
                                                          }).toList()
                                                      ),
                                                      h(20),
                                                      if (news.steps != null) Text(
                                                          'Рецепт',
                                                          style: TextStyle(
                                                              color: Color(0xFF1E1E1E),
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w700
                                                          )
                                                      ),
                                                      if (news.steps != null) h(20),
                                                      if (news.steps != null) Column(
                                                          spacing: 20,
                                                          children: List.generate(news.steps!.length, (index) {
                                                            final item = news.steps![index];

                                                            return Column(
                                                                children: [
                                                                  Row(
                                                                      spacing: 15,
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        if ((item.image1 ?? '').isNotEmpty) Expanded(
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.push(
                                                                                    Get.context!,
                                                                                    PageRouteBuilder(
                                                                                        opaque: false,
                                                                                        pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: item.image1!),
                                                                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                                          return FadeTransition(opacity: animation, child: child);
                                                                                        }
                                                                                    )
                                                                                );
                                                                              },
                                                                              child: Container(
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  child: CachedNetworkImage(
                                                                                      imageUrl: item.image1!,
                                                                                      errorWidget: (c, e, i) {
                                                                                        return Image.asset('assets/image/no_image.png', fit: BoxFit.contain);
                                                                                      },
                                                                                      fit: BoxFit.contain,
                                                                                      width: double.infinity
                                                                                  )
                                                                              )
                                                                            )
                                                                        ),
                                                                        if ((item.image2 ?? '').isNotEmpty) Expanded(
                                                                            child: GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.push(
                                                                                      Get.context!,
                                                                                      PageRouteBuilder(
                                                                                          opaque: false,
                                                                                          pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: item.image2!),
                                                                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                                            return FadeTransition(opacity: animation, child: child);
                                                                                          }
                                                                                      )
                                                                                  );
                                                                                },
                                                                                child: Container(
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                                                                                clipBehavior: Clip.antiAlias,
                                                                                child: CachedNetworkImage(
                                                                                    imageUrl: item.image2!,
                                                                                    errorWidget: (c, e, i) {
                                                                                      return Image.asset('assets/image/no_image.png', fit: BoxFit.contain);
                                                                                    },
                                                                                    fit: BoxFit.contain,
                                                                                    width: double.infinity
                                                                                )
                                                                            ))
                                                                        )
                                                                      ]
                                                                  ),
                                                                  if (item.text != null) h(20),
                                                                  if (item.text != null) Text(
                                                                      item.text!,
                                                                      style: TextStyle(
                                                                          color: Color(0xFF1E1E1E),
                                                                          fontSize: 14
                                                                      )
                                                                  )
                                                                ]
                                                            );
                                                          })
                                                      ),
                                                    ]
                                                )
                                            ),
                                            if ((news.products ?? []).isNotEmpty) StoreSection(title: 'Товары рецепта', products: news.products!, addWishlist: controller.addWishlist, buy: (id) async {
                                              await controller.main.addCart(id);
                                              controller.update();
                                            }),
                                            h(20)
                                          ]
                                      )
                                  ) : Center(
                                      child: Text('Статья не найдена!')
                                  )
                              )
                            ]
                        )
                    ),
                    // if (controller.isLoading.value) SearchWidget(),
                    // if (!controller.isLoading.value) Center(child: CircularProgressIndicator(color: primaryColor)),
                    // if (controller.isLoading.value) Positioned(
                    //     bottom: 10 + MediaQuery.of(context).viewPadding.bottom,
                    //     left: 20,
                    //     right: 20,
                    //     child: PrimaryButton(text: 'Все ${controller.recipe ? 'рецепты' : 'статьи'}', height: 40, background: Colors.white, borderColor: primaryColor, borderWidth: 2, textStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w700), onPressed: () {
                    //       if (controller.recipe) {
                    //         Get.toNamed('/blog', arguments: true);
                    //       } else {
                    //         Get.toNamed('/blog');
                    //       }
                    //     })
                    // )
                  ]
              );
            })
        )
    );
  }
}