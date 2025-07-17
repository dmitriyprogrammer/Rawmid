import 'package:flutter/material.dart';
import 'package:rawmid/utils/extension.dart';
import '../../model/home/news.dart';
import '../../widget/h.dart';
import '../../widget/module_title.dart';
import 'news_card.dart';

class RecipesSection extends StatefulWidget {
  const RecipesSection({super.key, required this.recipes, required this.callback, this.callback2, this.title, this.button, this.padding, this.my});

  final List<NewsModel> recipes;
  final Function() callback;
  final Function()? callback2;
  final String? title;
  final bool? button;
  final int? my;
  final EdgeInsets? padding;

  @override
  State<RecipesSection> createState() => RecipesSectionState();
}

class RecipesSectionState extends State<RecipesSection> {
  final pageController = PageController(viewportFraction: 0.5);
  int activeIndex = 0;
  bool button = true;

  @override
  Widget build(BuildContext context) {
    if (widget.button != null) {
      button = widget.button ?? false;
    }

    return ColoredBox(
        color: Colors.white,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ModuleTitle(title: widget.title ?? 'Рецепты', callback: widget.callback, type: true),
              ),
              h(15),
              Container(
                  padding: widget.padding ?? EdgeInsets.only(left: 4, right: 20),
                  height: 264,
                  child: PageView.builder(
                      clipBehavior: Clip.none,
                      controller: pageController,
                      onPageChanged: (val) => setState(() {
                        activeIndex = val;
                      }),
                      padEnds: false,
                      itemCount: widget.recipes.length,
                      itemBuilder: (context, index) {
                        return NewsCard(news: widget.recipes[index], button: button, recipe: true, my: widget.my, callback: widget.callback2);
                      }
                  )
              ),
              if (widget.recipes.length > 1) h(16),
              if (widget.recipes.length > 1) Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate((widget.recipes.length / 2).ceil(), (index) => GestureDetector(
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
