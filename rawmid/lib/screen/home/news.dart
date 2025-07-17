import 'package:flutter/material.dart';
import 'package:rawmid/utils/extension.dart';
import '../../model/home/news.dart';
import '../../widget/h.dart';
import '../../widget/module_title.dart';
import 'news_card.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({super.key, required this.news, this.callback, this.callback2, this.title, this.padding, this.recipe, this.survey, this.my});

  final List<NewsModel> news;
  final Function()? callback;
  final Function()? callback2;
  final String? title;
  final bool? padding;
  final bool? recipe;
  final bool? survey;
  final int? my;

  @override
  State<NewsSection> createState() => NewsSectionState();
}

class NewsSectionState extends State<NewsSection> {
  final pageController = PageController(viewportFraction: 0.5);
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: (widget.padding ?? false) ? 20 : 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h(30),
              ModuleTitle(title: widget.title ?? 'Статьи', callback: widget.callback, type: true),
              SizedBox(
                  height: 264,
                  child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                            left: -8,
                            right: -8,
                            top: 0,
                            bottom: 0,
                            child: PageView.builder(
                                clipBehavior: Clip.none,
                                controller: pageController,
                                padEnds: false,
                                onPageChanged: (val) => setState(() {
                                  activeIndex = val;
                                }),
                                itemCount: widget.news.length,
                                itemBuilder: (context, index) {
                                  return NewsCard(news: widget.news[index], recipe: widget.recipe ?? false, survey: widget.survey ?? false, callback: widget.callback2, my: widget.my);
                                }
                            )
                        )
                      ]
                  )
              ),
              if (widget.news.length > 1) h(16),
              if (widget.news.length > 1) Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate((widget.news.length / 2).ceil(), (index) => GestureDetector(
                      onTap: () async {
                        await pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

                        setState(() {
                          activeIndex = index;
                        });
                      },
                      child: Container(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              color: activeIndex == index ? Colors.blue : Color(0xFF00ADEE).withOpacityX(0.2),
                              shape: BoxShape.circle
                          )
                      )
                  ))
              ),
              h(16)
            ]
        )
    );
  }
}
