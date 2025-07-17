import 'package:flutter/material.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/model/city.dart';
import '../../utils/constant.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';
import 'package:get/get.dart';

class CitySearch extends GetView<NavigationController> {
  const CitySearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.85),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Выберите город',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              h(10),
              TextFormField(
                  autocorrect: false,
                  cursorHeight: 15,
                  style: TextStyle(
                      color: firstColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                  ),
                  onChanged: controller.filterCities,
                  decoration: decorationInput(hint: 'Поиск города', prefixIcon: Image.asset('assets/image/search.png')),
                  textInputAction: TextInputAction.done
              ),
              h(10),
              controller.filteredLocation.isEmpty ? Expanded(
                  child: controller.searchCity.isNotEmpty && controller.filteredCities.isEmpty ? Center(child: Text('Город не найден')) : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.filteredCities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(controller.filteredCities[index].name),
                            onTap: () {
                              controller.city.value = controller.filteredCities[index].name;
                              controller.searchCity.value = '';
                              controller.changeCity(controller.filteredCities[index]);
                            }
                        );
                      }
                  )
              ) : Expanded(
                  child: controller.searchCity.isNotEmpty && controller.filteredLocation.isEmpty ? Center(child: Text('Город не найден')) : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.filteredLocation.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(controller.filteredLocation[index].label),
                            onTap: () {
                              controller.city.value = controller.filteredLocation[index].value.replaceAll('г. ', '');
                              controller.searchCity.value = '';
                              controller.changeCity(CityModel(id: int.tryParse(controller.filteredLocation[index].fiasId) ?? 0, name: controller.filteredLocation[index].value.replaceAll('г. ', '')));
                            }
                        );
                      }
                  )
              )
            ]
        )
    ));
  }
}
