import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rawmid/model/home/banner.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../utils/helper.dart';
import '../../widget/h.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key, required this.banner, this.button});

  final BannerModel banner;
  final bool? button;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (banner.link.isNotEmpty) Helper.openLink(banner.link);
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: !(button ?? false) ? 20 : 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xFFF0F0F0)
          ),
          alignment: Alignment.center,
          child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                        imageUrl: banner.image2,
                        errorWidget: (c, e, i) {
                          return Image.asset('assets/image/no_image.png', fit: BoxFit.cover);
                        },
                        fit: BoxFit.cover,
                        width: double.infinity
                    )
                ),
                if (!(button ?? false)) Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          h(12),
                          if (banner.link.isNotEmpty) PrimaryButton(
                              onPressed: () => Helper.openLink(banner.link),
                              text: 'Узнать больше',
                              height: 40,
                              borderColor: Colors.transparent
                          )
                        ]
                    )
                )
              ]
          )
      )
    );
  }
}
