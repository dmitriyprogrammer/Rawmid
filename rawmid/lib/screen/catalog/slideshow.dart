import 'package:flutter/material.dart';
import 'package:rawmid/model/home/banner.dart';
import 'package:rawmid/utils/extension.dart';
import '../../widget/h.dart';
import '../../widget/module_title.dart';
import '../home/banner.dart';

class SlideshowCatalogView extends StatefulWidget {
  const SlideshowCatalogView({super.key, required this.banners, this.title});

  final List<BannerModel> banners;
  final String? title;

  @override
  State<SlideshowCatalogView> createState() => SlideshowViewState();
}

class SlideshowViewState extends State<SlideshowCatalogView> {
  PageController? pageController;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: widget.banners.length == 1 ? 1 : 0.85);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          h(20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ModuleTitle(title: widget.title ?? 'Магазин', type: true)
          ),
          h(10),
          Container(
              padding: EdgeInsets.only(left: 10, right: widget.banners.length == 1 ? 10 : 0),
              height: 200,
              child: PageView(
                controller: pageController,
                onPageChanged: (val) => setState(() {
                  activeIndex = val;
                }),
                padEnds: false,
                children: widget.banners.map((banner) => BannerCard(banner: banner, button: true)).toList(),
              )
          ),
          if (widget.banners.length > 1) h(16),
          if (widget.banners.length > 1) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.banners.length, (index) => GestureDetector(
                  onTap: () async {
                    await pageController?.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

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
          h(30)
        ]
    );
  }
}
