import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/model/catalog/category.dart';
import '../../widget/h.dart';
import '../../widget/module_title.dart';
import 'item.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  State<CategorySection> createState() => CategorySectionState();
}

class CategorySectionState extends State<CategorySection> {
  final pageController = PageController(viewportFraction: 0.7);
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          h(20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ModuleTitle(title: 'Категории', type: true)
          ),
          h(10),
          Container(
              padding: const EdgeInsets.only(left: 10),
              height: 170,
              child: PageView(
                controller: pageController,
                onPageChanged: (val) => setState(() {
                  activeIndex = val;
                }),
                padEnds: false,
                children: widget.categories.map((category) => _categoryCard(category)).toList(),
              )
          ),
          h(30)
        ]
    );
  }

  Widget _categoryCard(CategoryModel category) {
    return GestureDetector(
      onTap: () => Get.to(() => CategoryItemView(category: category)),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(12),
          width: 140,
          height: 160,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                  colors: [Colors.blue.shade500, Colors.blue.shade300],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                            imageUrl: category.image,
                            errorWidget: (c, e, i) {
                              return Image.asset('assets/image/no_image.png', fit: BoxFit.contain);
                            },
                            fit: BoxFit.cover,
                            width: double.infinity
                        )
                    )
                ),
                h(10),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        category.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis
                    )
                )
              ]
          )
      )
    );
  }
}
