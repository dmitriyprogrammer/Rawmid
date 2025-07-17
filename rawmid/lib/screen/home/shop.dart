import 'package:flutter/material.dart';
import 'package:rawmid/model/home/product.dart';
import 'package:rawmid/utils/extension.dart';
import '../../utils/helper.dart';
import '../../widget/h.dart';
import '../../widget/module_title.dart';
import '../../widget/product_card.dart';

class StoreSection extends StatefulWidget {
  const StoreSection({super.key, required this.products, required this.addWishlist, required this.buy, this.showMore, this.title});

  final List<ProductModel> products;
  final Function()? showMore;
  final Function(String) addWishlist;
  final Function(String) buy;
  final String? title;

  @override
  State<StoreSection> createState() => StoreSectionState();
}

class StoreSectionState extends State<StoreSection> {
  final pageController = PageController(viewportFraction: 1);
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          h(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ModuleTitle(title: widget.title ?? 'Магазин', callback: widget.showMore, type: true),
          ),
          h(15),
          ValueListenableBuilder<int>(
              valueListenable: Helper.trigger,
              builder: (context, items, child) => Container(
                  padding: const EdgeInsets.only(left: 4, right: 20),
                  constraints: BoxConstraints(minHeight: 308, maxHeight: 340),
                  child: PageView.builder(
                      clipBehavior: Clip.none,
                      controller: pageController,
                      onPageChanged: (val) => setState(() {
                        activeIndex = val;
                      }),
                      itemCount: (widget.products.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(2, (colIndex) {
                              int productIndex = index * 2 + colIndex;

                              if (productIndex < widget.products.length) {
                                return Expanded(child: ProductCard(
                                    product: widget.products[productIndex],
                                    addWishlist: () => widget.addWishlist(widget.products[productIndex].id),
                                    buy: () => widget.buy(widget.products[productIndex].id),
                                    margin: true
                                ));
                              } else {
                                return Spacer();
                              }
                            })
                        );
                      }
                  )
              )
          ),
          if ((widget.products.length / 2).ceil() > 1) h(16),
          if ((widget.products.length / 2).ceil() > 1) Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate((widget.products.length / 2).ceil(), (index) => GestureDetector(
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
