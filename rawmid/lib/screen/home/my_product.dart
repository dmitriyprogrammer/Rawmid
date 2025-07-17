import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/module_title.dart';
import '../../model/profile/sernum.dart';
import '../../widget/h.dart';
import '../user/register_product.dart';

class MyProductsSection extends StatelessWidget {
  const MyProductsSection({super.key, required this.products});

  final List<SernumModel> products;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color(0xFF1B1B1B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          h(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ModuleTitle(title: 'Мои товары', callback: () => Get.toNamed('/my_products'))
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(products[index]);
              }
            )
          ),
          h(40)
        ]
      )
    );
  }

  Widget _buildProductCard(SernumModel product) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  errorWidget: (c, e, i) {
                    return Image.asset('assets/image/no_image.png');
                  },
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover
                )
              ),
              if (product.category.isNotEmpty) Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  constraints: BoxConstraints(maxWidth: 92),
                  child: Text(product.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: primaryColor, fontSize: 12))
                )
              )
            ]
          ),
          h(8),
          Text(
            product.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis
          ),
          if (product.color.isNotEmpty) h(4),
          product.color.isNotEmpty ? Text(
            'Цвет: ${product.color}',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ) : h(20),
          h(8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              minimumSize: Size(double.infinity, 36),
            ),
            onPressed: () => Get.to(() => RegisterProductView(item: product)),
            child: Text('К товару', style: TextStyle(fontSize: 14, color: Colors.white))
          )
        ]
      )
    );
  }
}
