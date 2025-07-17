import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/h.dart';
import '../../controller/my_product.dart';
import '../../model/profile/sernum.dart';

class RegisterProductView extends GetView<MyProductController> {
  const RegisterProductView({super.key, required this.item});

  final SernumModel item;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0,
            leadingWidth: 0,
            leading: SizedBox.shrink(),
            title: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: Get.back,
                          icon: Image.asset('assets/icon/left.png')
                      ),
                      Image.asset('assets/image/logo.png', width: 70)
                    ]
                )
            )
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Form(
                              key: controller.formKey,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 15,
                                  children: [
                                    h(10),
                                    Container(
                                        width: 78,
                                        height: 78,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: CachedNetworkImageProvider(item.image),
                                                fit: BoxFit.cover
                                            )
                                        )
                                    ),
                                    Text(
                                        '№ запроса на регистрацию товара: #${item.serId}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        )
                                    ),
                                    Text(
                                        'Дата запроса: ${item.dateAdded}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        )
                                    ),
                                    Text(
                                        '№ заказа: ${item.orderId}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        )
                                    ),
                                    Text(
                                        'Дата заказа: ${item.dateOrdered}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        )
                                    ),
                                    Text(
                                        'Наименование товара: ${item.name}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        )
                                    ),
                                    Text(
                                        'Модель: ${item.model}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        )
                                    ),
                                    Text(
                                        'Серийный номер: ${item.sernum}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        )
                                    ),
                                    Text(
                                        'Коммерческое использование: ${item.commercial ? 'Да' : 'Нет'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        )
                                    ),
                                    h(MediaQuery.of(context).padding.bottom + 20)
                                  ]
                              )
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}