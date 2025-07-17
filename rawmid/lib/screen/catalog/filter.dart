import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/category.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../widget/h.dart';
import '../../widget/w.dart';

class FilterView extends GetView<CategoryController> {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        children: [
          GestureDetector(
              onTap: () => controller.openFilter.value = !controller.openFilter.value,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: ShapeDecoration(
                      color: Color(0xFF009FE6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(controller.openFilter.value ? 0 : 8),
                              bottomRight: Radius.circular(controller.openFilter.value ? 0 : 8)
                          )
                      )
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'Выбор по параметрам',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700
                            )
                        ),
                        Transform.rotate(
                            angle: controller.openFilter.value ? 0 : 3.1,
                            child: Image.asset('assets/icon/top.png', width: 12, height: 12)
                        )
                      ]
                  )
              )
          ),
          if (controller.openFilter.value) Container(
              padding: const EdgeInsets.only(left: 16, right: 10),
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)
                      )
                  )
              ),
              constraints: BoxConstraints(maxHeight: 400),
              child: Stack(
                children: [
                  ListView(
                      children: [
                        if (controller.maxPrice.value > 0) ExpansionTile(
                            title: Text(
                                'Цена',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.24
                                )
                            ),
                            initiallyExpanded: true,
                            iconColor: primaryColor,
                            childrenPadding: EdgeInsets.zero,
                            tilePadding: EdgeInsets.zero,
                            collapsedIconColor: primaryColor,
                            collapsedShape: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFDDE8EA))
                            ),
                            shape: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFDDE8EA))
                            ),
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${controller.getValue(controller.filter['min_price'] ?? controller.minPrice.value).toInt()}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                    ),
                                    Expanded(
                                        child: RangeSlider(
                                            values: RangeValues(controller.getValue(controller.filter['min_price'] ?? controller.minPrice.value), controller.getValue(controller.filter['max_price'] ?? controller.maxPrice.value)),
                                            min: controller.getValue(controller.minPrice.value),
                                            max: controller.getValue(controller.maxPrice.value),
                                            divisions: controller.maxPrice.value.toInt(),
                                            activeColor: primaryColor,
                                            inactiveColor: Colors.grey.shade300,
                                            onChanged: (values) {
                                              controller.changePrice(values);
                                            }
                                        )
                                    ),
                                    Text(
                                        '${controller.getValue(controller.filter['max_price'] ?? controller.maxPrice.value).toInt()}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                    )
                                  ]
                              )
                            ]
                        ),
                        if (controller.manufacturers.isNotEmpty) ExpansionTile(
                            title: Text(
                                'Производитель',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.24
                                )
                            ),
                            initiallyExpanded: true,
                            iconColor: primaryColor,
                            childrenPadding: EdgeInsets.zero,
                            tilePadding: EdgeInsets.zero,
                            collapsedIconColor: primaryColor,
                            collapsedShape: RoundedRectangleBorder(
                                side: BorderSide.none
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide.none
                            ),
                            children: controller.manufacturers.map((item) {
                              return CheckboxListTile(
                                  title: Text(
                                      item.name,
                                      style: TextStyle(fontSize: 14)
                                  ),
                                  overlayColor: WidgetStatePropertyAll(primaryColor),
                                  side: BorderSide(color: primaryColor, width: 2),
                                  contentPadding: EdgeInsets.zero,
                                  checkColor: Colors.white,
                                  activeColor: primaryColor,
                                  visualDensity: VisualDensity.compact,
                                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  value: controller.filter['manufacturer'] != null && (controller.filter['manufacturer'] as List<String>).where((e) => e == item.id).isNotEmpty,
                                  onChanged: (val) => controller.setManufacturer(item.id)
                              );
                            }).toList()
                        ),
                        ...controller.attributes.map((item) => item.display == 'slider' ? ExpansionTile(
                            title: Row(
                                children: [
                                  Text(
                                      item.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.24
                                      )
                                  ),
                                  if (item.description.isNotEmpty) w(6),
                                  if (item.description.isNotEmpty) GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: Get.context!,
                                            builder: (context) {
                                              return AlertDialog(
                                                  content: Text(item.description),
                                                  actions: [
                                                    GestureDetector(
                                                        onTap: Get.back,
                                                        child: Text('OK', style: TextStyle(color: primaryColor))
                                                    )
                                                  ]
                                              );
                                            }
                                        );
                                      },
                                      child: Icon(Icons.help_outline, color: Colors.grey, size: 20)
                                  )
                                ]
                            ),
                            initiallyExpanded: item.expanded == 1,
                            iconColor: primaryColor,
                            childrenPadding: EdgeInsets.zero,
                            tilePadding: EdgeInsets.zero,
                            collapsedIconColor: primaryColor,
                            collapsedShape: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFDDE8EA))
                            ),
                            shape: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFDDE8EA))
                            ),
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${controller.getValue(((controller.filter['attr_slider'] ?? <String, Map<String, String>>{}) as Map<String, Map<String, String>>)['${item.attributeId}']?['min'] ?? item.values.first).toInt()}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                    ),
                                    Expanded(
                                        child: RangeSlider(
                                            values: RangeValues(controller.getValue(((controller.filter['attr_slider'] ?? <String, Map<String, String>>{}) as Map<String, Map<String, String>>)['${item.attributeId}']?['min'] ?? item.values.first), controller.getValue(((controller.filter['attr_slider'] ?? <String, Map<String, String>>{}) as Map<String, Map<String, String>>)['${item.attributeId}']?['max'] ?? item.values.last)),
                                            min: controller.getValue(item.values.first),
                                            max: controller.getValue(item.values.last),
                                            divisions: item.values.length,
                                            activeColor: primaryColor,
                                            inactiveColor: Colors.grey.shade300,
                                            onChanged: (values) {
                                              controller.changeFilter(item.attributeId, values);
                                            }
                                        )
                                    ),
                                    Text(
                                        '${controller.getValue(((controller.filter['attr_slider'] ?? <String, Map<String, String>>{}) as Map<String, Map<String, String>>)['${item.attributeId}']?['max'] ?? item.values.last).toInt()}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                    )
                                  ]
                              )
                            ]
                        ) : ExpansionTile(
                            title: Row(
                                children: [
                                  Text(
                                      item.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.24
                                      )
                                  ),
                                  if (item.description.isNotEmpty) w(6),
                                  if (item.description.isNotEmpty) GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: Get.context!,
                                            builder: (context) {
                                              return AlertDialog(
                                                  content: Text(item.description),
                                                  actions: [
                                                    GestureDetector(
                                                        onTap: Get.back,
                                                        child: Text('OK', style: TextStyle(color: primaryColor))
                                                    )
                                                  ]
                                              );
                                            }
                                        );
                                      },
                                      child: Icon(Icons.help_outline, color: Colors.grey, size: 20)
                                  )
                                ]
                            ),
                            initiallyExpanded: item.expanded == 1,
                            iconColor: primaryColor,
                            childrenPadding: EdgeInsets.zero,
                            tilePadding: EdgeInsets.zero,
                            collapsedIconColor: primaryColor,
                            collapsedShape: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFDDE8EA))
                            ),
                            shape: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFDDE8EA))
                            ),
                            children: item.values.map((value) {
                              return CheckboxListTile(
                                  title: Text(
                                      value,
                                      style: TextStyle(fontSize: 14)
                                  ),
                                  overlayColor: WidgetStatePropertyAll(primaryColor),
                                  side: BorderSide(color: primaryColor, width: 2),
                                  contentPadding: EdgeInsets.zero,
                                  checkColor: Colors.white,
                                  activeColor: primaryColor,
                                  visualDensity: VisualDensity.compact,
                                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  value: controller.filter['attribute_value'] != null && ((controller.filter['attribute_value'] as Map<String, List<String>>)['${item.attributeId}'] ?? []).where((e) => e == value).isNotEmpty,
                                  onChanged: (val) => controller.setFilter(item.attributeId, value)
                              );
                            }).toList()
                        )),
                        h(50)
                      ]
                  ),
                  if (controller.filter.isNotEmpty) Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 12, top: 4),
                      color: Colors.white,
                      child: Row(
                          children: [
                            Expanded(
                                child: PrimaryButton(text: 'Очистить', loader: true, height: 40, background: Colors.grey, onPressed: controller.clear)
                            ),
                            w(10),
                            Expanded(
                                child: PrimaryButton(text: 'Применить', loader: true, height: 40, onPressed: controller.loadProducts)
                            )
                          ]
                      )
                    )
                  )
                ]
              )
          )
        ]
    ));
  }
}