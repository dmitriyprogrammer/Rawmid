import 'package:flutter/material.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:rawmid/utils/helper.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../model/home/special.dart';
import '../../widget/h.dart';
import 'package:get/get.dart';

class PromotionsSection extends StatefulWidget {
  const PromotionsSection({super.key, required this.specials, this.title});

  final List<SpecialModel> specials;
  final String? title;

  @override
  State<PromotionsSection> createState() => PromotionsSectionState();
}

class PromotionsSectionState extends State<PromotionsSection> {
  final pageController = PageController(viewportFraction: 0.85);
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF1B1B1B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          h(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ModuleTitle(title: widget.title ?? 'Акции', callback: () => Get.toNamed('/specials'))
          ),
          h(10),
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (val) => setState(() {
                activeIndex = val;
              }),
              itemCount: widget.specials.length,
              itemBuilder: (context, index) {
                return _buildPromotionCard(widget.specials[index], widget.specials.length > 1);
              }
            )
          ),
          if (widget.specials.length > 1) h(16),
          if (widget.specials.length > 1) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.specials.length, (index) => GestureDetector(
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

  Widget _buildPromotionCard(SpecialModel special, bool length) {
    return Container(
      margin: EdgeInsets.only(right: length ? 16 : 0),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            special.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
          ),
          h(12),
          Text(
            special.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 12)
          ),
          Spacer(),
          if (special.link.isNotEmpty) ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              minimumSize: Size(double.infinity, 40)
            ),
            onPressed: () => Helper.openLink(special.link),
            child: Text('Подробнее', style: TextStyle(fontSize: 16, color: Colors.white))
          )
        ]
      )
    );
  }
}
