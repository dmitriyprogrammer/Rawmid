import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:rawmid/widget/module_title.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../../widget/h.dart';
import '../../controller/my_product.dart';
import '../../model/product/product_autocomplete.dart';
import '../../model/profile/sernum.dart';
import '../../utils/constant.dart';
import '../../utils/utils.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import '../product/zap.dart';

class WarrantyProductView extends GetView<MyProductController> {
  const WarrantyProductView({super.key});

  @override
  Widget build(BuildContext context) {
    SernumModel? item;

    if (Get.parameters['index'] != null) {
      item = controller.products[int.tryParse('${Get.parameters['index'] ?? 0}') ?? 0];
    }

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
            child: Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ColoredBox(
                                color: Color(0xFFF0F0F0),
                                child: Column(
                                    children: [
                                      h(20),
                                      SearchBarView(),
                                      h(20)
                                    ]
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Form(
                                    key: controller.formKey2,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          h(10),
                                          ModuleTitle(title: 'Проверка гарантийного срока', type: true),
                                          if (item != null) Row(
                                              spacing: 16,
                                              children: [
                                                Container(
                                                    width: 48.57,
                                                    height: 52.48,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: CachedNetworkImageProvider(item.image),
                                                            fit: BoxFit.cover
                                                        )
                                                    )
                                                ),
                                                Expanded(
                                                    child: Column(
                                                        spacing: 12,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                              item.name,
                                                              style: TextStyle(
                                                                  color: const Color(0xFF1E1E1E),
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w600
                                                              )
                                                          ),
                                                          if (item.color.isNotEmpty) Row(
                                                              spacing: 4,
                                                              children: [
                                                                Flexible(
                                                                    child: Text(
                                                                        'Цвет:',
                                                                        textAlign: TextAlign.right,
                                                                        style: TextStyle(
                                                                            color: const Color(0xFF8A95A8),
                                                                            fontSize: 11
                                                                        )
                                                                    )
                                                                ),
                                                                Expanded(
                                                                    child: Text(
                                                                        item.color,
                                                                        textAlign: TextAlign.right,
                                                                        style: TextStyle(
                                                                            color: const Color(0xFF1E1E1E),
                                                                            fontSize: 11
                                                                        )
                                                                    )
                                                                )
                                                              ]
                                                          )
                                                        ]
                                                    )
                                                )
                                              ]
                                          ),
                                          h(24),
                                          TypeAheadField<ProductAutocompleteModel>(
                                              suggestionsCallback: controller.suggestionsCallback,
                                              controller: controller.productField,
                                              itemBuilder: (context, e) => ListTile(title: Text(e.name)),
                                              onSelected: (e) {
                                                controller.productField.text = e.name;
                                                controller.modelField.text = e.model;
                                                controller.productId.value = e.id;

                                                if (!e.noSer) {
                                                  controller.noSerCheck.value = false;
                                                }
                                              },
                                              builder: (context, textController, focusNode) {
                                                return TextFormField(
                                                    controller: textController,
                                                    focusNode: focusNode,
                                                    textInputAction: TextInputAction.next,
                                                    decoration: decorationInput(
                                                      hint: 'Наименование товара*',
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                                    ),
                                                    validator: (val) {
                                                      if ((val ?? '').isEmpty) return ' ';
                                                      return null;
                                                    }
                                                );
                                              }
                                          ),
                                          h(8),
                                          TypeAheadField<ProductAutocompleteModel>(
                                              suggestionsCallback: controller.suggestionsCallback2,
                                              controller: controller.modelField,
                                              itemBuilder: (context, e) => ListTile(title: Text(e.name)),
                                              onSelected: (e) {
                                                controller.productField.text = e.name;
                                                controller.modelField.text = e.model;
                                                controller.productId.value = e.id;

                                                if (!e.noSer) {
                                                  controller.noSerCheck.value = false;
                                                }
                                              },
                                              builder: (context, textController, focusNode) {
                                                return TextFormField(
                                                    controller: textController,
                                                    focusNode: focusNode,
                                                    textInputAction: TextInputAction.next,
                                                    decoration: decorationInput(
                                                      hint: 'Модель товара*',
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                                        suffixIcon: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                      opaque: false,
                                                                      pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: 'https://madeindream.com/image/whereis_model.jpg'),
                                                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                        return FadeTransition(opacity: animation, child: child);
                                                                      }
                                                                  )
                                                              );
                                                            },
                                                            child: Icon(Icons.info, color: primaryColor)
                                                        )
                                                    ),
                                                    validator: (val) {
                                                      if ((val ?? '').isEmpty) return ' ';
                                                      return null;
                                                    }
                                                );
                                              }
                                          ),
                                          h(8),
                                          TextFormField(
                                              controller: controller.numberField,
                                              validator: (val) {
                                                if ((val ?? '').isEmpty) return ' ';
                                                return null;
                                              },
                                              textInputAction: TextInputAction.next,
                                              decoration: decorationInput(hint: 'Серийный номер (английскими буквами)*', contentPadding: const EdgeInsets.symmetric(horizontal: 20), suffixIcon: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                            opaque: false,
                                                            pageBuilder: (context, animation, secondaryAnimation) => ZapView(image: 'https://madeindream.com/image/whereis_sernum.jpg'),
                                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                              return FadeTransition(opacity: animation, child: child);
                                                            }
                                                        )
                                                    );
                                                  },
                                                  child: Icon(Icons.info, color: primaryColor)
                                              ))
                                          ),
                                          if (controller.noSer.value) h(8),
                                          if (controller.noSer.value) Row(
                                              mainAxisSize: MainAxisSize.min,
                                              spacing: 8,
                                              children: [
                                                Checkbox(
                                                    value: controller.noSerCheck.value,
                                                    onChanged: (value) {
                                                      controller.noSerCheck.value = value!;
                                                    },
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    side: const BorderSide(color: Colors.lightBlue, width: 2),
                                                    activeColor: Colors.lightBlue,
                                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    visualDensity: VisualDensity.compact
                                                ),
                                                Text(
                                                    'Нет серийного номера',
                                                    style: TextStyle(
                                                        color: const Color(0xFF8A95A8),
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w700
                                                    )
                                                )
                                              ]
                                          ),
                                          h(24),
                                          PrimaryButton(text: 'Проверить гарантию', loader: true, height: 48, onPressed: controller.warranty),
                                          h(MediaQuery.of(context).padding.bottom + 20)
                                        ]
                                    )
                                )
                            )
                          ]
                      )
                  ),
                  SearchWidget()
                ]
            )
        )
    );
  }
}