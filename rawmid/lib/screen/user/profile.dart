import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawmid/utils/constant.dart';
import '../../../widget/h.dart';
import '../../controller/user.dart';
import '../../widget/w.dart';

class ProfileSection extends GetView<UserController> {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Личная информация', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                InkWell(
                    onTap: () => controller.edit.value = !controller.edit.value,
                    child: Image.asset('assets/icon/edit.png')
                )
              ]
          ),
          h(12),
          Divider(color: Color(0xFFDDE8EA), height: 1),
          h(20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => controller.pickImage(ImageSource.gallery),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(40)
                      ),
                      clipBehavior: Clip.antiAlias,
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      child: controller.loadImage.value ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: primaryColor)
                      ) : controller.imageFile.value != null ? Image.file(controller.imageFile.value!, fit: BoxFit.cover, width: 80, height: 80) : (controller.user.value?.image ?? '').isNotEmpty ? CachedNetworkImage(
                          imageUrl: controller.user.value!.image, width: 80, height: 80,
                          fit: BoxFit.cover,
                          errorWidget: (c, e, i) {
                            return Image.asset('assets/image/empty.png');
                          }
                      ) : Image.asset('assets/image/empty.png')
                  )
                ),
                Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                        color: Color(0xFFEBF3F6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                    ),
                    child: Text(
                        (controller.user.value?.type ?? false) ? 'Юридическое лицо' : 'Физическое лицо',
                        style: TextStyle(
                            color: Color(0xFF0D80D9),
                            fontSize: 14
                        )
                    )
                )
              ]
          ),
          h(32),
          if ((controller.user.value?.fio ?? '').isNotEmpty) Text(controller.user.value?.fio ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          if ((controller.user.value?.fio ?? '').isNotEmpty) h(16),
          if ((controller.user.value?.phone ?? '').isNotEmpty) Row(
              children: [
                Image.asset('assets/icon/phone.png'),
                w(8),
                Text(
                    controller.user.value!.phone,
                    style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    )
                )
              ]
          ),
          if ((controller.user.value?.phone ?? '').isNotEmpty) h(22),
          if ((controller.user.value?.email ?? '').isNotEmpty) Row(
              children: [
                Image.asset('assets/icon/email.png'),
                w(8),
                Text(
                    controller.user.value!.email,
                    style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    )
                )
              ]
          )
        ]
    ));
  }
}