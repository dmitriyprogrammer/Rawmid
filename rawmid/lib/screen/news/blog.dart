import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/news.dart';
import 'package:rawmid/screen/home/news_card.dart';
import 'package:rawmid/screen/news/news.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../controller/blog.dart';
import '../../utils/constant.dart';
import '../../widget/h.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    var back = false;

    return GetBuilder<BlogController>(
        init: BlogController(),
        builder: (controller) => PopScope(
            canPop: false,
            onPopInvokedWithResult: (type, val) async {
              if (back) return;
              if (controller.id.isNotEmpty && controller.categories.isNotEmpty) {
                controller.id.value = '';
                return;
              }

              Future.microtask(() {
                Get.back();
              });
            },
            child: Scaffold(
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
                                  onPressed: () {
                                    if (controller.id.isNotEmpty && controller.categories.isNotEmpty) {
                                      controller.id.value = '';
                                      return;
                                    }

                                    back = true;

                                    Get.back();
                                  },
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
                      final cat = (controller.categories.isNotEmpty && controller.id.isEmpty);
                      var count = 1;

                      if (controller.isLoading.value) {
                        if (!cat) {
                          count += (controller.news.length / 2).ceil();
                        } else {
                          count += (controller.categories.length / 2).ceil();
                        }
                      }

                      var title = Get.parameters['my_recipes'] == '1' ? 'Мои рецепты' : Get.parameters['my_survey'] == '1' ? 'Мои обзоры' : controller.isRecipe.value ? 'Рецепты' : 'Статьи';

                      if (controller.id.isNotEmpty && controller.categories.isNotEmpty) {
                        title = controller.categories.firstWhere((e) => (e.id == '0' && e.name == 'Обзоры') || e.id == controller.id.value).name;
                      }

                      return !controller.isLoading.value ? Center(child: CircularProgressIndicator(color: primaryColor)) : Stack(
                          children: [
                            ListView.builder(
                                itemCount: count,
                                itemBuilder: (c, index) {
                                  if (index == 0) {
                                    return Column(
                                        children: [
                                          ColoredBox(
                                              color: const Color(0xFFF0F0F0),
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
                                                    h(20),
                                                    ModuleTitle(title: title, type: true)
                                                  ]
                                              )
                                          ),
                                          if (controller.featured.isNotEmpty && controller.id.isEmpty) Container(
                                              padding: const EdgeInsets.only(left: 20),
                                              height: 254,
                                              child: PageView.builder(
                                                  controller: controller.pageController,
                                                  onPageChanged: (val) {
                                                    controller.activeIndex.value = val;
                                                  },
                                                  itemCount: controller.featured.length,
                                                  padEnds: false,
                                                  itemBuilder: (context, index) {
                                                    return Padding(
                                                        padding: const EdgeInsets.only(right: 20),
                                                        child: Stack(
                                                            children: [
                                                              Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                        clipBehavior: Clip.antiAlias,
                                                                        height: 160,
                                                                        decoration: ShapeDecoration(
                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                                        ),
                                                                        child: Stack(
                                                                            children: [
                                                                              CachedNetworkImage(
                                                                                  imageUrl: controller.featured[index].image,
                                                                                  errorWidget: (c, e, i) {
                                                                                    return Image.asset('assets/image/no_image.png');
                                                                                  },
                                                                                  width: double.infinity,
                                                                                  fit: BoxFit.contain
                                                                              ),
                                                                              Positioned(
                                                                                  left: 0,
                                                                                  top: 0,
                                                                                  right: 0,
                                                                                  bottom: 0,
                                                                                  child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                          gradient: LinearGradient(
                                                                                              begin: Alignment(-0.00, -1.00),
                                                                                              end: Alignment(0, 1),
                                                                                              colors: [Colors.black.withOpacityX(0), Colors.black.withOpacityX(0.800000011920929)]
                                                                                          )
                                                                                      )
                                                                                  )
                                                                              ),
                                                                              Positioned(
                                                                                  left: 16,
                                                                                  right: 16,
                                                                                  bottom: 14,
                                                                                  child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Flexible(
                                                                                            child: Text(
                                                                                                controller.featured[index].title,
                                                                                                maxLines: 2,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                style: TextStyle(
                                                                                                    color: Colors.white,
                                                                                                    fontSize: 16,
                                                                                                    height: 1,
                                                                                                    fontWeight: FontWeight.w700
                                                                                                )
                                                                                            )
                                                                                        ),
                                                                                        ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(
                                                                                                backgroundColor: primaryColor,
                                                                                                shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(12)
                                                                                                ),
                                                                                                minimumSize: Size(90, 40)
                                                                                            ),
                                                                                            onPressed: () {
                                                                                              Get.delete<NewsController>();
                                                                                              Get.put(NewsController(controller.featured[index].id, false, Get.parameters['my_survey'] == '1'));
                                                                                              Get.to(() => NewsView());
                                                                                            },
                                                                                            child: Text('Читать', style: TextStyle(fontSize: 14, color: Colors.white))
                                                                                        )
                                                                                      ]
                                                                                  )
                                                                              )
                                                                            ]
                                                                        )
                                                                    ),
                                                                    h(16),
                                                                    Text(
                                                                        controller.featured[index].text,
                                                                        maxLines: 4,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: Color(0xFF1E1E1E),
                                                                            fontSize: 13
                                                                        )
                                                                    )
                                                                  ]
                                                              ),
                                                              if (controller.featured[index].text.length > 200) Positioned(
                                                                  bottom: 2,
                                                                  right: 0,
                                                                  child: InkWell(
                                                                      onTap: () {
                                                                        Get.delete<NewsController>();
                                                                        Get.put(NewsController(controller.featured[index].id, false, Get.parameters['my_survey'] == '1'));
                                                                        Get.to(() => NewsView());
                                                                      },
                                                                      child: Container(
                                                                          padding: const EdgeInsets.only(left: 3),
                                                                          color: Colors.white,
                                                                          child: Text(
                                                                              'читать далее...',
                                                                              style: TextStyle(color: Colors.blue, fontSize: 14)
                                                                          )
                                                                      )
                                                                  )
                                                              )
                                                            ]
                                                        )
                                                    );
                                                  }
                                              )
                                          ),
                                          if (controller.featured.length > 1 && controller.id.isEmpty) h(16),
                                          if (controller.featured.length > 1 && controller.id.isEmpty) Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: List.generate(controller.featured.length, (index) => GestureDetector(
                                                  onTap: () async {
                                                    await controller.pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

                                                    controller.activeIndex.value = index;
                                                  },
                                                  child: Container(
                                                      width: 10,
                                                      height: 10,
                                                      margin: EdgeInsets.symmetric(horizontal: 4),
                                                      decoration: BoxDecoration(
                                                          color: controller.activeIndex.value == index ? Colors.blue : Color(0xFF00ADEE).withOpacityX(0.2),
                                                          shape: BoxShape.circle
                                                      )
                                                  )
                                              ))
                                          ),
                                          if (controller.featured.isNotEmpty && controller.id.isEmpty) h(30)
                                        ]
                                    );
                                  }

                                  if (cat) {
                                    final gridIndex = index - 1;

                                    final int first = gridIndex * 2;
                                    if (first >= controller.categories.length) return const SizedBox();

                                    final int? second = (first + 1 < controller.categories.length) ? first + 1 : null;

                                    return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                                        child: Row(
                                            spacing: 15,
                                            children: [
                                              Expanded(
                                                  child: GestureDetector(
                                                      onTap: () => controller.setCategory(controller.categories[first].id),
                                                      child: Container(
                                                          width: double.infinity,
                                                          height: controller.isRecipe.value ? 165 : 46,
                                                          clipBehavior: Clip.antiAlias,
                                                          decoration: BoxDecoration(
                                                              color: controller.isRecipe.value ? const Color(0xFFE4E4E4) : Colors.white,
                                                              border: Border.all(color: primaryColor),
                                                              borderRadius: BorderRadius.circular(8),
                                                              image: controller.isRecipe.value ? DecorationImage(image: CachedNetworkImageProvider(controller.categories[first].image), fit: BoxFit.cover) : null
                                                          ),
                                                          child: Stack(
                                                              alignment: Alignment.center,
                                                              children: [
                                                                if (controller.isRecipe.value) Positioned(
                                                                    left: 0,
                                                                    top: 0,
                                                                    right: 0,
                                                                    bottom: 0,
                                                                    child: ColoredBox(color: Colors.black.withOpacityX(0.6))
                                                                ),
                                                                Text(
                                                                    controller.categories[first].name,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        color: controller.isRecipe.value ? Colors.white : null,
                                                                        fontSize: controller.isRecipe.value ? 16 : 14,
                                                                        height: 1,
                                                                        fontWeight: FontWeight.w700
                                                                    )
                                                                )
                                                              ]
                                                          )
                                                      )
                                                  )
                                              ),
                                              Expanded(
                                                  child: second != null
                                                      ? GestureDetector(
                                                      onTap: () => controller.setCategory(controller.categories[second].id),
                                                      child: Container(
                                                          width: double.infinity,
                                                          height: controller.isRecipe.value ? 165 : 46,
                                                          clipBehavior: Clip.antiAlias,
                                                          decoration: BoxDecoration(
                                                              color: controller.isRecipe.value ? const Color(0xFFE4E4E4) : Colors.white,
                                                              border: Border.all(color: primaryColor),
                                                              borderRadius: BorderRadius.circular(8),
                                                              image: controller.isRecipe.value ? DecorationImage(image: CachedNetworkImageProvider(controller.categories[second].image), fit: BoxFit.cover) : null
                                                          ),
                                                          child: Stack(
                                                              alignment: Alignment.center,
                                                              children: [
                                                                if (controller.isRecipe.value) Positioned(
                                                                    left: 0,
                                                                    top: 0,
                                                                    right: 0,
                                                                    bottom: 0,
                                                                    child: ColoredBox(color: Colors.black.withOpacityX(0.6))
                                                                ),
                                                                Text(
                                                                    controller.categories[second].name,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        color: controller.isRecipe.value ? Colors.white : null,
                                                                        fontSize: controller.isRecipe.value ? 16 : 14,
                                                                        height: 1,
                                                                        fontWeight: FontWeight.w700
                                                                    )
                                                                )
                                                              ]
                                                          )
                                                      )
                                                  )
                                                      : SizedBox()
                                              )
                                            ]
                                        )
                                    );
                                  }

                                  final gridIndex = index - 1;

                                  final int first = gridIndex * 2;
                                  if (first >= controller.news.length) return const SizedBox();

                                  final int? second = (first + 1 < controller.news.length) ? first + 1 : null;

                                  return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      child: Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                                    constraints: BoxConstraints(maxHeight: 264, minHeight: 260),
                                                    child: NewsCard(news: controller.news[first], recipe: controller.isRecipe.value, survey: Get.parameters['my_survey'] == '1' || controller.id.value == '0')
                                                )
                                            ),
                                            Expanded(
                                                child: second != null ? Container(
                                                    constraints: BoxConstraints(maxHeight: 264, minHeight: 260),
                                                    child: NewsCard(news: controller.news[second], recipe: controller.isRecipe.value, survey: Get.parameters['my_survey'] == '1' || controller.id.value == '0')
                                                ) : SizedBox()
                                            )
                                          ]
                                      )
                                  );
                                }
                            ),
                            SearchWidget()
                          ]
                      );
                    })
                )
            )
        ));
  }
}