import 'package:flutter/material.dart';
import 'package:rawmid/model/home/banner.dart';
import 'package:rawmid/utils/extension.dart';
import '../../widget/h.dart';
import 'banner.dart';

class SlideshowView extends StatefulWidget {
  const SlideshowView({super.key, required this.banners, this.button});

  final List<BannerModel> banners;
  final bool? button;

  @override
  State<SlideshowView> createState() => SlideshowViewState();
}

class SlideshowViewState extends State<SlideshowView> {
  final pageController = PageController();
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          h(40),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 328,
              child: PageView(
                controller: pageController,
                onPageChanged: (val) => setState(() {
                  activeIndex = val;
                }),
                children: widget.banners.map((banner) => BannerCard(banner: banner, button: widget.button)).toList(),
              )
          ),
          if (widget.banners.length > 1) h(16),
          if (widget.banners.length > 1) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.banners.length, (index) => GestureDetector(
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
          h(30)
        ]
    );
  }
}
