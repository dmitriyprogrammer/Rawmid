import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZapView extends StatelessWidget {
  const ZapView({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
        body: SafeArea(
          child: GestureDetector(
            onTap: Get.back,
            child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: Stack(
                    children: [
                      Center(
                          child: InteractiveViewer(
                              clipBehavior: Clip.none,
                              panEnabled: true,
                              minScale: 1,
                              maxScale: 10,
                              child: CachedNetworkImage(
                                  imageUrl: image,
                                  errorWidget: (c, e, i) {
                                    return Image.asset('assets/image/no_image.png');
                                  },
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.contain
                              )
                          )
                      ),
                      Positioned(
                          top: 10,
                          right: 0,
                          child: IconButton(onPressed: Get.back, icon: Icon(Icons.close, size: 26, color: Colors.white))
                      )
                    ]
                )
            )
          )
        )
    );
  }
}