import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:rawmid/controller/checkout.dart';
import 'package:rawmid/model/city.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../controller/cart.dart';
import '../../controller/home.dart';
import '../../model/cart.dart';
import '../../model/checkout/shipping.dart';
import '../../model/location.dart';
import '../../model/profile/address.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';
import '../../widget/primary_button.dart';
import '../../widget/w.dart';
import '../home/city.dart';
import '../product/product.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
        init: CheckoutController(),
        builder: (controller) => Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                titleSpacing: 0,
                leadingWidth: 0,
                leading: SizedBox.shrink(),
                title: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 20),
                    child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: Get.back,
                              icon: Image.asset('assets/icon/left.png')
                          ),
                          if (controller.navController.city.value.isNotEmpty) w(10),
                          if (controller.navController.city.value.isNotEmpty) Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    final city = controller.navController.city.value;

                                    showModalBottomSheet(
                                        context: Get.context!,
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        useRootNavigator: true,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                        ),
                                        builder: (context) {
                                          return CitySearch();
                                        }
                                    ).then((_) {
                                      controller.controllersAddress['postcode']?.clear();
                                      controller.controllersAddress['address_1']?.clear();
                                      controller.navController.filteredCities.value = controller.navController.cities;
                                      controller.navController.filteredLocation.clear();
                                      if (city == controller.navController.city.value) return;
                                      controller.controllersAddress['city']!.text = controller.navController.city.value;
                                      controller.initialize(update: true);
                                      controller.country.value = controller.navController.countryId.value;
                                      controller.setCountry(controller.country.value).then((_) {
                                        controller.region.value = controller.navController.zoneId.value;
                                      });

                                      if (Get.isRegistered<HomeController>()) {
                                        final home = Get.find<HomeController>();
                                        home.initialize();
                                      }

                                      if (Get.isRegistered<CartController>()) {
                                        final cart = Get.find<CartController>();
                                        cart.initialize();
                                      }
                                    });
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.location_on_rounded, color: Color(0xFF14BFFF)),
                                            w(6),
                                            Flexible(
                                                child: Text(
                                                    controller.navController.city.value,
                                                    textAlign: TextAlign.right,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Color(0xFF14BFFF),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600
                                                    )
                                                )
                                            )
                                          ]
                                      )
                                  )
                              )
                          )
                        ]
                    ))
                )
            ),
            backgroundColor: Colors.white,
            body: Obx(() => SafeArea(
                bottom: false,
                child: controller.isLoading.value ? SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: controller.success.value ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        h(40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Номер вашего заказа:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                )
                            )
                          ]
                        ),
                        Text(
                          '${controller.order.value!.orderId}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 24,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        h(30),
                        Image.asset('assets/image/success.png', width: 130),
                        h(12),
                        Text(
                          'Заказ успешно оформлен!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8A95A8),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        h(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Helper.launchInBrowser('https://t.me/RAWMIDchatbot?start=phone_77774538722'),
                              child: Image.asset('assets/image/telegramlink.png', width: Get.width-40)
                            )
                          ]
                        ),
                        if (controller.setOrder.value != null && controller.navController.user.value != null) h(20),
                        if (controller.setOrder.value != null && controller.navController.user.value != null) PrimaryButton(text: 'Посмотреть заказ', onPressed: () => Get.offNamed('/orders', parameters: {'order_id': controller.setOrder.value!.id}))
                      ]
                    ) : Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Оформление заказа',
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700
                                )
                            ),
                            h(24),
                            ValueListenableBuilder<int>(
                                valueListenable: Helper.trigger,
                                builder: (context, items, child) => Column(
                                    children: controller.navController.cartProducts.map((item) => _cartItemTile(item, controller.updateCart, controller.updateCart, controller.addWishlist)).toList()
                                )
                            ),
                            if (controller.acc.isNotEmpty) Container(
                                height: 120,
                                padding: const EdgeInsets.all(16),
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                    color: Color(0xFFEBF3F6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Добавить аксессуары',
                                          style: TextStyle(
                                              color: Color(0xFF1E1E1E),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700
                                          )
                                      ),
                                      h(15),
                                      Expanded(
                                          child: PageView.builder(
                                              clipBehavior: Clip.none,
                                              controller: controller.pageController,
                                              itemCount: controller.acc.length,
                                              padEnds: false,
                                              itemBuilder: (context, index) {
                                                return Obx(() => GestureDetector(
                                                    onTap: () => controller.addCartAcc(controller.acc[index].id, index),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                                        clipBehavior: Clip.antiAlias,
                                                        alignment: Alignment.center,
                                                        child: controller.accAdd[controller.acc[index].id] != null ? Container(
                                                          alignment: Alignment.center,
                                                          width: 20,
                                                          height: 20,
                                                          child: CircularProgressIndicator(color: primaryColor)
                                                        ) : CachedNetworkImage(
                                                            imageUrl: controller.acc[index].image,
                                                            errorWidget: (c, e, i) {
                                                              return Image.asset('assets/image/no_image.png');
                                                            },
                                                            height: 120,
                                                            width: double.infinity,
                                                            fit: BoxFit.cover
                                                        )
                                                    )
                                                ));
                                              }
                                          )
                                      )
                                    ]
                                )
                            ),
                            h(20),
                            Text(
                                'Личная информация',
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700
                                )
                            ),
                            h(20),
                            Container(
                                height: 40,
                                padding: const EdgeInsets.all(4),
                                decoration: ShapeDecoration(
                                    color: Color(0xFFEBF3F6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                ),
                                child: Row(
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                              onTap: () => controller.setTab(0),
                                              child: Container(
                                                  height: 32,
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  decoration: ShapeDecoration(
                                                      color: Color(controller.tab.value == 0 ? 0xFF80AEBF : 0xFFEBF3F6),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Физическое лицо',
                                                      style: TextStyle(
                                                          color: controller.tab.value != 0 ? Color(0xFF80AEBF) : Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: 0.24
                                                      )
                                                  )
                                              )
                                          )
                                      ),
                                      Expanded(
                                          child: GestureDetector(
                                              onTap: () => controller.setTab(1),
                                              child: Container(
                                                  height: 32,
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  decoration: ShapeDecoration(
                                                      color: Color(controller.tab.value == 1 ? 0xFF80AEBF : 0xFFEBF3F6),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Юридическое лицо',
                                                      style: TextStyle(
                                                          color: controller.tab.value != 1 ? Color(0xFF80AEBF) : Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: 0.24
                                                      )
                                                  )
                                              )
                                          )
                                      )
                                    ]
                                )
                            ),
                            h(16),
                            controller.tab.value == 0 ? Wrap(
                                runSpacing: 16,
                                children: controller.fizControllers.entries.map((item) => Column(
                                    children: [
                                        item.key == 'telephone' ? PhoneFormField(
                                          controller: controller.phoneField,
                                          validator: PhoneValidator.compose([PhoneValidator.required(Get.context!, errorText: 'Номер телефона обязателен'), PhoneValidator.validMobile(Get.context!, errorText: 'Номер телефона некорректен')]),
                                          countrySelectorNavigator: const CountrySelectorNavigator.draggableBottomSheet(),
                                          isCountrySelectionEnabled: true,
                                          isCountryButtonPersistent: true,
                                          autofillHints: const [AutofillHints.telephoneNumber],
                                          countryButtonStyle: const CountryButtonStyle(
                                              showDialCode: true,
                                              padding: EdgeInsets.only(left: 15),
                                              showIsoCode: false,
                                              showFlag: true,
                                              showDropdownIcon: false
                                          ),
                                          onChanged: (val) => controller.saveField(item.key, '+${val.countryCode}${val.nsn}'),
                                          decoration: decorationInput(contentPadding: const EdgeInsets.all(8)),
                                        ) : TextFormField(
                                          cursorHeight: 15,
                                          key: controller.errors[item.key],
                                          controller: item.value,
                                          validator: (value) => controller.validators[item.key]!(value),
                                          decoration: decorationInput(error: item.key == 'email' && controller.emailValidate.value ? dangerColor : null, prefixIcon: item.key == 'phone_buh' ? Image.asset('assets/icon/rph.png', width: 20) : null, hint: controller.controllerHints[item.key], contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (val) async {
                                            controller.saveField(item.key, val);

                                            if (item.key == 'email') {
                                              controller.validateEmailX(val);
                                            }
                                          }
                                      ),
                                      if (item.key == 'email' && controller.emailValidate.value) Padding(
                                          padding: const EdgeInsets.only(top: 4, left: 16),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'E-mail не существует',
                                                    style: TextStyle(color: dangerColor, fontSize: 12)
                                                )
                                              ]
                                          )
                                      )
                                    ]
                                )).toList()
                            ) : Column(
                              children: [
                                Wrap(
                                    runSpacing: 16,
                                    children: controller.urControllers.entries.map((item) => Column(
                                        children: [
                                          item.key == 'phone_buh' ? PhoneFormField(
                                            controller: controller.phoneBuhField,
                                            validator: PhoneValidator.compose([PhoneValidator.required(Get.context!, errorText: 'Номер телефона обязателен'), PhoneValidator.validMobile(Get.context!, errorText: 'Номер телефона некорректен')]),
                                            countrySelectorNavigator: const CountrySelectorNavigator.draggableBottomSheet(),
                                            isCountrySelectionEnabled: true,
                                            isCountryButtonPersistent: true,
                                            autofillHints: const [AutofillHints.telephoneNumber],
                                            countryButtonStyle: const CountryButtonStyle(
                                                showDialCode: true,
                                                showIsoCode: false,
                                                showFlag: true,
                                                padding: EdgeInsets.only(left: 15),
                                                showDropdownIcon: false,
                                                flagSize: 20
                                            ),
                                            decoration: decorationInput(contentPadding: const EdgeInsets.all(8), hint: 'Номер бухгалтерии'),
                                          ) : TextFormField(
                                              cursorHeight: 15,
                                              key: controller.errors[item.key],
                                              controller: item.value,
                                              validator: (value) => controller.validators[item.key] != null ? controller.validators[item.key]!(value) : null,
                                              decoration: decorationInput(error: item.key == 'email_buh' && controller.emailValidate.value ? dangerColor : null, prefixIcon: item.key == 'phone_buh' ? Image.asset('assets/icon/rph.png', width: 20) : null, hint: controller.controllerHints[item.key], contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              keyboardType: TextInputType.text,
                                              textInputAction: TextInputAction.next,
                                              onChanged: (val) async {
                                                controller.saveField(item.key, val);

                                                if (item.key == 'email_buh') {
                                                  controller.validateEmailX(val);
                                                }
                                              }
                                          ),
                                          if (item.key == 'email_buh' && controller.emailValidate.value) Padding(
                                              padding: const EdgeInsets.only(top: 4, left: 16),
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'E-mail не существует',
                                                        style: TextStyle(color: dangerColor, fontSize: 12)
                                                    )
                                                  ]
                                              )
                                          )
                                        ]
                                    )).toList()
                                ),
                                h(16),
                                DropdownButtonFormField<String?>(
                                    value: controller.edo.value,
                                    isExpanded: true,
                                    decoration: decorationInput(hint: 'ЭДО', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                    items: ['ДИАДОК', 'СБИС', 'НЕТ'].map((item) {
                                      return DropdownMenuItem<String?>(
                                          value: item,
                                          child: Text(item, style: TextStyle(fontSize: 14))
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      controller.edo.value = newValue ?? '';
                                      controller.saveField('edo', newValue ?? '');
                                    }
                                )
                              ]
                            ),
                            h(20),
                            Stack(
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Способ доставки',
                                            style: TextStyle(
                                                color: Color(0xFF1E1E1E),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700
                                            )
                                        ),
                                        h(24),
                                        controller.shipping.where((e) => e.quote.isNotEmpty).isNotEmpty ? Column(
                                            children: controller.shipping.where((e) => e.quote.isNotEmpty).map((item) => _buildRadioTile(
                                                item: item,
                                                controller: controller
                                            )).toList()
                                        ) : Builder(
                                          builder: (c) {
                                            return Obx(() {
                                              if (!controller.isLoading2.value) {
                                                return Center(child: CircularProgressIndicator(color: primaryColor));
                                              }

                                              final addresses = controller.navController.user.value?.address.where((e) => e.address.toLowerCase().contains(controller.navController.city.value.toLowerCase())) ?? [];

                                              return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if (addresses.isEmpty) Text('Заполните адрес, чтобы увидеть способы доставки', style: TextStyle(fontSize: 12)),
                                                    if (addresses.isNotEmpty) h(15),
                                                    ...addresses.map((e) => GestureDetector(
                                                        onTap: () => controller.setAddress(e.id),
                                                        child: Padding(
                                                            padding: const EdgeInsets.only(bottom: 10),
                                                            child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(
                                                                      width: 20,
                                                                      height: 24,
                                                                      child: Radio(
                                                                          value: e.id,
                                                                          groupValue: (controller.addressId.value == 0 && e.def) ? e.id : controller.addressId.value,
                                                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                          activeColor: primaryColor,
                                                                          onChanged: (value) {
                                                                            controller.addressId.value = int.tryParse('${value ?? 0}') ?? 0;
                                                                          }
                                                                      )
                                                                  ),
                                                                  w(8),
                                                                  Expanded(
                                                                      child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                                e.address,
                                                                                style: TextStyle(
                                                                                    color: Color(0xFF1E1E1E),
                                                                                    fontSize: 14,
                                                                                    height: 1.40,
                                                                                    letterSpacing: 0.14
                                                                                )
                                                                            ),
                                                                            if (e.def) h(4),
                                                                            if (e.def) Text('Основной', style: TextStyle(color: Colors.grey))
                                                                          ]
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                    )),
                                                    h(20),
                                                    if ((controller.navController.user.value?.address ?? []).isEmpty) Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          DropdownButtonFormField<String>(
                                                              value: controller.country.value,
                                                              isExpanded: true,
                                                              decoration: decorationInput(hint: 'Страна', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                                              items: controller.countries.map((item) {
                                                                return DropdownMenuItem<String>(
                                                                    value: item.countryId!,
                                                                    child: Text(item.name!, style: TextStyle(fontSize: 14))
                                                                );
                                                              }).toList(),
                                                              onChanged: (val) => controller.setCountry(val),
                                                              validator: (value) => value == null ? 'Выберите страну' : null
                                                          ),
                                                          if (controller.regions.isNotEmpty) h(16),
                                                          if (controller.regions.isNotEmpty) DropdownButtonFormField<String?>(
                                                              value: controller.region.value,
                                                              isExpanded: true,
                                                              decoration: decorationInput(hint: 'Регион', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                                              items: controller.regions.map((item) {
                                                                return DropdownMenuItem<String?>(
                                                                    value: item.zoneId,
                                                                    child: Text(item.name!, style: TextStyle(fontSize: 14))
                                                                );
                                                              }).toList(),
                                                              onChanged: (newValue) {
                                                                controller.region.value = newValue ?? '';
                                                                controller.controllersAddress['city']!.clear();
                                                                controller.controllersAddress['postcode']!.clear();
                                                                controller.controllersAddress['address_1']!.clear();
                                                                controller.saveField('zone_id', newValue ?? '');
                                                              },
                                                              validator: (value) => value == null ? 'Выберите регион' : null
                                                          ),
                                                          if (controller.regions.isNotEmpty) h(16),
                                                          if (controller.regions.isNotEmpty) TypeAheadField<Location>(
                                                              suggestionsCallback: controller.suggestionsCallback,
                                                              controller: controller.controllersAddress['city'],
                                                              itemBuilder: (context, e) => ListTile(title: Text(e.label), onTap: () {
                                                                controller.controllersAddress['city']!.text = e.label;
                                                                controller.searchC.value = e.label;

                                                                final city = CityModel(id: int.tryParse(e.fiasId) ?? 0, name: e.value.replaceAll('г. ', ''));
                                                                final cityStr = controller.navController.city.value;

                                                                controller.navController.changeCity(city, not: false).then((e) {
                                                                  if (cityStr != city.name) {
                                                                    controller.initialize(update: true);
                                                                    controller.country.value = controller.navController.countryId.value;
                                                                    controller.setCountry(controller.country.value).then((_) {
                                                                      controller.region.value = controller.navController.zoneId.value;
                                                                    });
                                                                  }
                                                                });

                                                                Future.delayed(Duration(milliseconds: 100), () {
                                                                  controller.controllersAddress['city']!.clear();
                                                                  controller.controllersAddress['city']!.text = e.label;
                                                                });

                                                                FocusScope.of(context).unfocus();
                                                                controller.suggestionSelected.value = true;
                                                              }),
                                                              onSelected: (e) {
                                                                controller.controllersAddress['city']!.text = e.label;
                                                                controller.searchC.value = e.label;

                                                                final city = CityModel(id: int.tryParse(e.fiasId) ?? 0, name: e.value.replaceAll('г. ', ''));
                                                                final cityStr = controller.navController.city.value;

                                                                controller.navController.changeCity(city, not: false).then((e) {
                                                                  if (cityStr != city.name) {
                                                                    controller.initialize(update: true);
                                                                    controller.country.value = controller.navController.countryId.value;
                                                                    controller.setCountry(controller.country.value).then((_) {
                                                                      controller.region.value = controller.navController.zoneId.value;
                                                                    });
                                                                  }
                                                                });

                                                                Future.delayed(Duration(milliseconds: 100), () {
                                                                  controller.controllersAddress['city']!.clear();
                                                                  controller.controllersAddress['city']!.text = e.label;
                                                                });

                                                                FocusScope.of(Get.context!).unfocus();
                                                                controller.suggestionSelected.value = true;
                                                              },
                                                              hideOnEmpty: true,
                                                              hideOnSelect: true,
                                                              hideOnUnfocus: true,
                                                              hideOnError: true,
                                                              builder: (context, textController, focusNode) {
                                                                return TextFormField(
                                                                    controller: textController,
                                                                    focusNode: focusNode,
                                                                    key: controller.errors['city'],
                                                                    cursorHeight: 15,
                                                                    validator: (value) => controller.validators['city']!(value),
                                                                    decoration: decorationInput(hint: 'Город *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                    textInputAction: TextInputAction.next,
                                                                    onChanged: (val) {
                                                                      controller.suggestionSelected.value = false;
                                                                      controller.saveField('city', val);
                                                                    }
                                                                );
                                                              }
                                                          ),
                                                          if (controller.regions.isNotEmpty) h(16),
                                                          if (controller.regions.isNotEmpty) TextFormField(
                                                              key: controller.errors['postcode'],
                                                              cursorHeight: 15,
                                                              onChanged: (val) => controller.saveField('postcode', val),
                                                              controller: controller.controllersAddress['postcode'],
                                                              keyboardType: TextInputType.number,
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter.digitsOnly,
                                                                LengthLimitingTextInputFormatter(6)
                                                              ],
                                                              decoration: decorationInput(hint: 'Индекс ', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                                              textInputAction: TextInputAction.next
                                                          ),
                                                          if (controller.regions.isNotEmpty) h(16),
                                                          if (controller.regions.isNotEmpty) TypeAheadField<String>(
                                                              suggestionsCallback: controller.suggestionsCallback2,
                                                              controller: controller.controllersAddress['address_1'],
                                                              itemBuilder: (context, e) => ListTile(title: Text(e)),
                                                              onSelected: (e) {
                                                                if (!e.contains(', д ')) {
                                                                  Helper.snackBar(error: true, text: 'Необходимо указать полный адрес');
                                                                  return;
                                                                }

                                                                controller.controllersAddress['address_1']!.text = e;
                                                              },
                                                              builder: (context, textController, focusNode) {
                                                                return TextFormField(
                                                                    controller: textController,
                                                                    focusNode: focusNode,
                                                                    key: controller.errors['address_1'],
                                                                    cursorHeight: 15,
                                                                    onChanged: (val) => controller.saveField('address_1', val),
                                                                    validator: (value) => controller.validators['address_1']!(value),
                                                                    decoration: decorationInput(hint: 'Адрес *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                    textInputAction: TextInputAction.done
                                                                );
                                                              }
                                                          ),
                                                          h(20)
                                                        ]
                                                    ),
                                                    controller.navController.user.value != null ? controller.addAddress.value ? Column(
                                                        children: [
                                                          PrimaryButton(
                                                              text: 'Добавить адрес',
                                                              height: 40,
                                                              loader: true,
                                                              onPressed: controller.newAddress
                                                          ),
                                                          PrimaryButton(
                                                              text: 'Отмена',
                                                              height: 40,
                                                              background: Colors.grey,
                                                              onPressed: () => controller.addAddress.value = false
                                                          )
                                                        ]
                                                    ) : GestureDetector(
                                                        onTap: controller.newAddress,
                                                        child:  Container(
                                                            height: 44,
                                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                                            decoration: ShapeDecoration(
                                                                color: Colors.white,
                                                                image: DecorationImage(image: AssetImage('assets/image/border.png'), fit: BoxFit.fill),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(8)
                                                                )
                                                            ),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Image.asset('assets/icon/plus.png'),
                                                                  w(8),
                                                                  Text(
                                                                      'Добавить адрес',
                                                                      style: TextStyle(
                                                                          color: Color(0xFF8A95A8),
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                    ) : PrimaryButton(text: 'Применить', height: 40, loader: true, onPressed: () => controller.setShipping(address: true)),
                                                    h(20)
                                                  ]
                                              );
                                            });
                                          }
                                        ),
                                        h(20),
                                        Text(
                                            'Способ оплаты',
                                            style: TextStyle(
                                                color: Color(0xFF1E1E1E),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700
                                            )
                                        ),
                                        h(24),
                                        !controller.isLoading2.value ? Center(child: CircularProgressIndicator(color: primaryColor)) : Column(
                                            children: controller.payment.map((item) => GestureDetector(
                                                onTap: () => controller.setPayment(item),
                                                child: Padding(
                                                    padding: const EdgeInsets.only(bottom: 10),
                                                    child: Row(
                                                        children: [
                                                          Icon(
                                                              controller.selectedPayment.value == item.code ? Icons.radio_button_checked : Icons.circle_outlined,
                                                              color: primaryColor,
                                                              size: 24
                                                          ),
                                                          w(10),
                                                          Expanded(
                                                              child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                        item.title,
                                                                        style: TextStyle(
                                                                            color: Color(0xFF141414),
                                                                            fontSize: 14,
                                                                            height: 1.40,
                                                                            letterSpacing: 0.14
                                                                        )
                                                                    ),
                                                                    h(4),
                                                                    if (item.paymentDiscount.isNotEmpty) Text(
                                                                        item.paymentDiscount.trim(),
                                                                        style: TextStyle(
                                                                            color: Color(0xFF8A95A8),
                                                                            fontSize: 12,
                                                                            height: 1.40,
                                                                            letterSpacing: 0.12
                                                                        )
                                                                    )
                                                                  ]
                                                              )
                                                          )
                                                        ]
                                                    )
                                                )
                                            )).toList()
                                        ),
                                        h(20),
                                        TextFormField(
                                            cursorHeight: 15,
                                            controller: controller.commentField,
                                            decoration: decorationInput(hint: 'Комментарий к заказу', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                                            keyboardType: TextInputType.text,
                                            maxLines: 3,
                                            onChanged: (val) => controller.saveField('comment', val),
                                            textInputAction: TextInputAction.done
                                        ),
                                        h(20),
                                        if (controller.usePrepayment.value) Column(
                                          children: [
                                            GestureDetector(
                                                onTap: () => controller.setPrepayment(0),
                                                child: Padding(
                                                    padding: const EdgeInsets.only(bottom: 10),
                                                    child: Row(
                                                        children: [
                                                          SizedBox(
                                                              width: 20,
                                                              height: 24,
                                                              child: Radio(
                                                                  value: 0,
                                                                  groupValue: controller.prepayment.value,
                                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                  activeColor: primaryColor,
                                                                  onChanged: (value) {
                                                                    controller.prepayment.value = value ?? 0;
                                                                    Helper.prefs.setInt('prepayment', value ?? 0);
                                                                  }
                                                              )
                                                          ),
                                                          w(8),
                                                          Expanded(
                                                              child: Text(
                                                                  'Полная предоплата (без переплат)',
                                                                  style: TextStyle(
                                                                      color: Color(0xFF1E1E1E),
                                                                      fontSize: 14,
                                                                      height: 1.40,
                                                                      letterSpacing: 0.14
                                                                  )
                                                              )
                                                          )
                                                        ]
                                                    )
                                                )
                                            ),
                                            GestureDetector(
                                                onTap: () => controller.setPrepayment(1),
                                                child: Padding(
                                                    padding: const EdgeInsets.only(bottom: 10),
                                                    child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                              width: 20,
                                                              height: 24,
                                                              child: Radio(
                                                                  value: 1,
                                                                  groupValue: controller.prepayment.value,
                                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                  activeColor: primaryColor,
                                                                  onChanged: (value) {
                                                                    controller.prepayment.value = value ?? 1;
                                                                    Helper.prefs.setInt('prepayment', value ?? 1);
                                                                  }
                                                              )
                                                          ),
                                                          w(8),
                                                          Expanded(
                                                              child: Text(
                                                                  'Частичная предоплата:  1000 руб.\nОстаток суммы +3% (комиссия курьерской службы) оплачивается курьеру при получении.\nВнимание! Внесенная предоплата не может быть возвращена!',
                                                                  style: TextStyle(
                                                                      color: Color(0xFF1E1E1E),
                                                                      fontSize: 14,
                                                                      height: 1.40,
                                                                      letterSpacing: 0.14
                                                                  )
                                                              )
                                                          )
                                                        ]
                                                    )
                                                )
                                            ),
                                            h(20)
                                          ]
                                        ),
                                        Column(
                                            children: controller.totals.map((total) => _buildRow(total.title, total.text, isTotal: total.code == 'total')).toList()
                                        ),
                                        h(20),
                                        Divider(color: Color(0xFFDDE8EA), thickness: 1, height: 0.1),
                                        h(32),
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 8,
                                            children: [
                                              Checkbox(
                                                  value: controller.agree.value,
                                                  onChanged: (value) {
                                                    controller.agree.value = value!;
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  side: const BorderSide(color: Colors.lightBlue, width: 2),
                                                  activeColor: Colors.lightBlue,
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  visualDensity: VisualDensity.compact
                                              ),
                                              Expanded(
                                                  child: Text.rich(
                                                      TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text: 'Я прочитал ',
                                                                style: TextStyle(
                                                                    color: const Color(0xFF8A95A8),
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w700
                                                                )
                                                            ),
                                                            TextSpan(
                                                                recognizer: TapGestureRecognizer()..onTap = () {
                                                                  showAdaptiveDialog(
                                                                      context: Get.context!,
                                                                      useRootNavigator: true,
                                                                      useSafeArea: true,
                                                                      builder: (c) {
                                                                        controller.webPersonalController ??= WebViewController()
                                                                          ..setJavaScriptMode(
                                                                              JavaScriptMode.unrestricted)
                                                                          ..loadRequest(Uri.parse('https://madeindream.com/informatsija/usloviya-rashirennoj-garantii.html?ajax=1'));

                                                                        return Scaffold(
                                                                            backgroundColor: Colors.black45,
                                                                            body: Align(
                                                                                alignment: Alignment.center,
                                                                                child: Container(
                                                                                    padding: EdgeInsets.all(20),
                                                                                    height: Get.height * 0.7,
                                                                                    child: Container(
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                                                                        clipBehavior: Clip.antiAlias,
                                                                                        child: Stack(
                                                                                            children: [
                                                                                              Padding(
                                                                                                  padding: EdgeInsets.all(20),
                                                                                                  child: Column(
                                                                                                      children: [
                                                                                                        Expanded(child: WebViewWidget(controller: controller.webPersonalController!))
                                                                                                      ]
                                                                                                  )
                                                                                              ),
                                                                                              Positioned(
                                                                                                  right: 0,
                                                                                                  top: 0,
                                                                                                  child: IconButton(onPressed: Get.back, icon: Icon(Icons.close, size: 20, color: Colors.black))
                                                                                              )
                                                                                            ]
                                                                                        )
                                                                                    )
                                                                                )
                                                                            )
                                                                        );
                                                                      }
                                                                  );
                                                                },
                                                                text: 'Условия предоставления расширенной гарантии',
                                                                style: TextStyle(
                                                                    color: const Color(0xFF14BFFF),
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w700
                                                                )
                                                            ),
                                                            TextSpan(
                                                                text: ' и ',
                                                                style: TextStyle(
                                                                    color: const Color(0xFF8A95A8),
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w700
                                                                )
                                                            ),
                                                            TextSpan(
                                                                recognizer: TapGestureRecognizer()..onTap = () {
                                                                  showAdaptiveDialog(
                                                                      context: Get.context!,
                                                                      useRootNavigator: true,
                                                                      useSafeArea: true,
                                                                      builder: (c) {
                                                                        controller.webPersonalController ??= WebViewController()
                                                                          ..setJavaScriptMode(
                                                                              JavaScriptMode.unrestricted)
                                                                          ..loadRequest(Uri.parse('https://madeindream.com/informatsija/politika-obrabotki.html?ajax=1'));

                                                                        return Scaffold(
                                                                            backgroundColor: Colors.black45,
                                                                            body: Align(
                                                                                alignment: Alignment.center,
                                                                                child: Container(
                                                                                    padding: EdgeInsets.all(20),
                                                                                    height: Get.height * 0.7,
                                                                                    child: Container(
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                                                                        clipBehavior: Clip.antiAlias,
                                                                                        child: Stack(
                                                                                            children: [
                                                                                              Padding(
                                                                                                  padding: EdgeInsets.all(20),
                                                                                                  child: Column(
                                                                                                      children: [
                                                                                                        Expanded(child: WebViewWidget(controller: controller.webPersonalController!))
                                                                                                      ]
                                                                                                  )
                                                                                              ),
                                                                                              Positioned(
                                                                                                  right: 0,
                                                                                                  top: 0,
                                                                                                  child: IconButton(onPressed: Get.back, icon: Icon(Icons.close, size: 20, color: Colors.black))
                                                                                              )
                                                                                            ]
                                                                                        )
                                                                                    )
                                                                                )
                                                                            )
                                                                        );
                                                                      }
                                                                  );
                                                                },
                                                                text: 'Политику обработки персональных даных',
                                                                style: TextStyle(
                                                                    color: const Color(0xFF14BFFF),
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w700
                                                                )
                                                            ),
                                                            TextSpan(
                                                                text: ' и согласен с условиями.',
                                                                style: TextStyle(
                                                                    color: const Color(0xFF8A95A8),
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w700
                                                                )
                                                            )
                                                          ]
                                                      )
                                                  )
                                              )
                                            ]
                                        ),
                                        h(20),
                                        PrimaryButton(text: 'Оформить', height: 50, loader: true, onPressed: controller.checkout)
                                      ]
                                  ),
                                  if (controller.preload.value) Positioned.fill(
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: Get.height,
                                          width: Get.width,
                                          color: Colors.white.withOpacityX(0.8),
                                          child: CircularProgressIndicator(color: primaryColor)
                                      )
                                  )
                                ]
                            ),
                            h(20 + MediaQuery.of(context).padding.bottom)
                          ]
                      )
                    )
                ) : Center(
                    child: CircularProgressIndicator(color: primaryColor)
                )
            ))
        )
    );
  }

  Widget _buildRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(top: isTotal ? 16 : 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.3,
                      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal
                  )
              )
            ),
            w(16),
            Text(
                value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal
                )
            )
          ]
      )
    );
  }

  Widget _buildRadioTile({required ShippingModel item, required CheckoutController controller}) {
    final addresses = controller.navController.user.value?.address;

    if ((addresses ?? []).where((e) => e.countryId == controller.navController.countryId.value).isEmpty) {
      controller.addressId.value = 0;
    }

    if (controller.addressId.value == 0) {
      for (var i in (addresses ?? <AddressModel>[])) {
        if (i.def) {
          controller.addressId.value = i.id;
          break;
        }
      }
    }

    if ((controller.controllersAddress['city']?.text ?? '').isEmpty) {
      controller.controllersAddress['city']?.text = controller.navController.city.value;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            item.title,
            style: TextStyle(
                color: Color(0xFF141414),
                fontSize: 16,
                height: 1.40,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.14
            )
        ),
        h(12),
        Column(
          children: item.quote.map((e) => Column(
            children: [
              GestureDetector(
                  onTap: () {
                    controller.addAddress.value = false;

                    if (controller.selectedShipping.value == e.code) {
                      return;
                    }

                    controller.selectedShipping.value = e.code;

                    if (e.title.contains('пункта выдачи')) {
                      controller.selectedPvz.value = null;
                      controller.selectedBBPvz.value = null;
                      controller.cDek.value = true;
                    } else {
                      controller.setShipping();
                    }
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Icon(
                                controller.selectedShipping.value == e.code ? Icons.radio_button_checked : Icons.circle_outlined,
                                color: primaryColor,
                                size: 24
                            ),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          e.title,
                                          style: TextStyle(
                                              color: Color(0xFF141414),
                                              fontSize: 14,
                                              height: 1.40,
                                              letterSpacing: 0.14
                                          )
                                      ),
                                      h(4),
                                      if (e.title.contains('пункта выдачи')) InkWell(
                                          onTap: () {
                                            controller.selectedShipping.value = e.code;

                                            showModalBottomSheet(
                                              context: Get.context!,
                                              isScrollControlled: true,
                                              useSafeArea: true,
                                              useRootNavigator: true,
                                              enableDrag: false,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                              ),
                                              builder: (context) {
                                                return Stack(
                                                  children: [
                                                    e.code.contains('bb') ? _buildMapBB(controller) : _buildMap(controller),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: Get.back
                                                      )
                                                    )
                                                  ]
                                                );
                                              }
                                            );
                                          },
                                          child: Text(
                                              (controller.selectedPvz.value != null && e.code.contains('cdek')) || (controller.selectedBBPvz.value != null && e.code.contains('bb.')) ? 'Изменить ПВЗ' : 'Выбрать ПВЗ',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 14,
                                                  height: 1.40,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.12
                                              )
                                          )
                                      ),
                                      if (e.title.contains('пункта выдачи') && ((controller.selectedPvz.value != null && e.code.contains('cdek')) || (controller.selectedBBPvz.value != null && e.code.contains('bb.')))) Text(
                                          '${controller.selectedPvz.value?.code ?? controller.selectedBBPvz.value?.id ?? ''}: ${controller.selectedPvz.value?.address ?? controller.selectedBBPvz.value?.pvzAddr ?? ''}',
                                          style: TextStyle(
                                              color: Color(0xFF8A95A8),
                                              fontSize: 12,
                                              height: 1.40,
                                              letterSpacing: 0.12
                                          )
                                      ),
                                      if (!e.title.contains('пункта выдачи') && e.description.isNotEmpty) Text(
                                          e.description.trim(),
                                          style: TextStyle(
                                              color: Color(0xFF8A95A8),
                                              fontSize: 12,
                                              height: 1.40,
                                              letterSpacing: 0.12
                                          )
                                      )
                                    ]
                                )
                            ),
                            if (e.cost > 0) Builder(
                              builder: (c) {
                                final regex = RegExp(r'[^\d\s]+');
                                final match = regex.firstMatch(controller.totals.firstWhere((total) => total.code == 'total').text);
                                var currencySymbol = '₽';

                                if (match != null) {
                                  currencySymbol = match.group(0) ?? '₽';
                                }

                                return Text(
                                    Helper.formatPrice(e.cost.toDouble(), symbol: currencySymbol),
                                    style: TextStyle(
                                        color: Color(0xFF141414),
                                        fontSize: 14,
                                        height: 1.40,
                                        letterSpacing: 0.14
                                    )
                                );
                              },
                            )
                          ]
                      )
                  )
              ),
              if (controller.selectedShipping.value == e.code && (e.title.contains('о дверей') || e.title.contains('урьерская доставка') || e.title.contains('курьером'))) Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 32, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text((addresses ?? []).isNotEmpty ? 'Выберите адрес' : 'Добавление адреса'),
                        h(10),
                        ...(addresses ?? []).map((e) => GestureDetector(
                            onTap: () => e.countryId != controller.navController.countryId.value ? null : controller.setAddress(e.id),
                            child: Stack(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: 20,
                                              height: 24,
                                              child: Radio(
                                                  value: e.id,
                                                  groupValue: (controller.addressId.value == 0 && e.def) ? e.id : controller.addressId.value,
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  activeColor: primaryColor,
                                                  onChanged: (value) {
                                                    if (e.countryId != controller.navController.countryId.value) {
                                                      controller.setAddress(int.tryParse('$value') ?? 0);
                                                    }
                                                  }
                                              )
                                          ),
                                          w(8),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        e.address,
                                                        style: TextStyle(
                                                            color: Color(0xFF1E1E1E),
                                                            fontSize: 14,
                                                            height: 1.40,
                                                            letterSpacing: 0.14
                                                        )
                                                    ),
                                                    if (e.def) h(4),
                                                    if (e.def) Text('Основной', style: TextStyle(color: Colors.grey))
                                                  ]
                                              )
                                          )
                                        ]
                                    )
                                ),
                                if (e.countryId != controller.navController.countryId.value) Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(color: Colors.white.withOpacityX(0.8))
                                )
                              ]
                            )
                        )),
                        if (controller.addAddress.value || (addresses ?? []).isNotEmpty) h(20),
                        if (controller.addAddress.value || (addresses ?? []).isEmpty) Form(
                          key: controller.formKeyAddress,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<String?>(
                                    value: controller.country.value,
                                    isExpanded: true,
                                    decoration: decorationInput(hint: 'Страна', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                    items: controller.countries.map((item) {
                                      return DropdownMenuItem<String?>(
                                          value: item.countryId,
                                          child: Text(item.name ?? '', style: TextStyle(fontSize: 14))
                                      );
                                    }).toList(),
                                    onChanged: (val) => controller.setCountry(val),
                                    validator: (value) => value == null ? 'Выберите страну' : null
                                ),
                                if (controller.regions.isNotEmpty) h(16),
                                if (controller.regions.isNotEmpty) DropdownButtonFormField<String?>(
                                    value: controller.region.value,
                                    isExpanded: true,
                                    decoration: decorationInput(hint: 'Регион', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                    items: controller.regions.map((item) {
                                      return DropdownMenuItem<String?>(
                                          value: item.zoneId,
                                          child: Text(item.name ?? '', style: TextStyle(fontSize: 14))
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      controller.region.value = newValue ?? '';
                                      controller.controllersAddress['city']!.clear();
                                      controller.controllersAddress['postcode']!.clear();
                                      controller.controllersAddress['address_1']!.clear();
                                      controller.saveField('zone_id', newValue ?? '');
                                    },
                                    validator: (value) => value == null ? 'Выберите регион' : null
                                ),
                                if (controller.regions.isNotEmpty) h(16),
                                if (controller.regions.isNotEmpty) TypeAheadField<Location>(
                                    suggestionsCallback: controller.suggestionsCallback,
                                    controller: controller.controllersAddress['city'],
                                    itemBuilder: (context, e) => ListTile(title: Text(e.label), onTap: () {
                                      controller.controllersAddress['city']!.text = e.label;
                                      controller.searchC.value = e.label;
                                      final city = CityModel(id: int.tryParse(e.fiasId) ?? 0, name: e.value.replaceAll('г. ', ''));
                                      final cityStr = controller.navController.city.value;

                                      controller.navController.changeCity(city, not: false).then((e) {
                                        if (cityStr != city.name) {
                                          controller.initialize(update: true);
                                          controller.country.value = controller.navController.countryId.value;
                                          controller.setCountry(controller.country.value).then((_) {
                                            controller.region.value = controller.navController.zoneId.value;
                                          });
                                        }
                                      });

                                      Future.delayed(Duration(milliseconds: 100), () {
                                        controller.controllersAddress['city']!.clear();
                                        controller.controllersAddress['city']!.text = e.label;
                                      });

                                      FocusScope.of(context).unfocus();
                                      controller.suggestionSelected.value = true;
                                    }),
                                    onSelected: (e) {
                                      controller.controllersAddress['city']!.text = e.label;
                                      controller.searchC.value = e.label;

                                      final city = CityModel(id: int.tryParse(e.fiasId) ?? 0, name: e.value.replaceAll('г. ', ''));
                                      final cityStr = controller.navController.city.value;

                                      controller.navController.changeCity(city, not: false).then((e) {
                                        if (cityStr != city.name) {
                                          controller.initialize(update: true);
                                          controller.country.value = controller.navController.countryId.value;
                                          controller.setCountry(controller.country.value).then((_) {
                                            controller.region.value = controller.navController.zoneId.value;
                                          });
                                        }
                                      });

                                      Future.delayed(Duration(milliseconds: 100), () {
                                        controller.controllersAddress['city']!.clear();
                                        controller.controllersAddress['city']!.text = e.label;
                                      });

                                      FocusScope.of(Get.context!).unfocus();
                                      controller.suggestionSelected.value = true;
                                    },
                                    hideOnEmpty: true,
                                    hideOnSelect: true,
                                    hideOnUnfocus: true,
                                    hideOnError: true,
                                    builder: (context, textController, focusNode) {
                                      return TextFormField(
                                          controller: textController,
                                          focusNode: focusNode,
                                          key: controller.errors['city'],
                                          cursorHeight: 15,
                                          validator: (value) => controller.validators['city']!(value),
                                          decoration: decorationInput(hint: 'Город *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (val) {
                                            controller.suggestionSelected.value = false;
                                            controller.saveField('city', val);
                                          }
                                      );
                                    }
                                ),
                                if (controller.regions.isNotEmpty) h(16),
                                if (controller.regions.isNotEmpty) TextFormField(
                                    key: controller.errors['postcode'],
                                    cursorHeight: 15,
                                    onChanged: (val) => controller.saveField('postcode', val),
                                    controller: controller.controllersAddress['postcode'],
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(6)
                                    ],
                                    decoration: decorationInput(hint: 'Индекс ', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    textInputAction: TextInputAction.next
                                ),
                                if (controller.regions.isNotEmpty) h(16),
                                if (controller.regions.isNotEmpty) TypeAheadField<String>(
                                    suggestionsCallback: controller.suggestionsCallback2,
                                    controller: controller.controllersAddress['address_1'],
                                    itemBuilder: (context, e) => ListTile(title: Text(e)),
                                    onSelected: (e) {
                                      if (!e.contains(', д ')) {
                                        Helper.snackBar(error: true, text: 'Необходимо указать полный адрес');
                                        return;
                                      }

                                      controller.controllersAddress['address_1']!.text = e;
                                    },
                                    builder: (context, textController, focusNode) {
                                      return TextFormField(
                                          controller: textController,
                                          focusNode: focusNode,
                                          key: controller.errors['address_1'],
                                          cursorHeight: 15,
                                          onChanged: (val) => controller.saveField('address_1', val),
                                          validator: (value) => controller.validators['address_1']!(value),
                                          decoration: decorationInput(hint: 'Адрес *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          textInputAction: TextInputAction.done
                                      );
                                    }
                                ),
                                h(20)
                              ]
                          )
                        ),
                        if (controller.navController.user.value != null) controller.addAddress.value ? Column(
                          children: [
                            PrimaryButton(
                                text: 'Добавить адрес',
                                height: 40,
                                loader: true,
                                onPressed: controller.newAddress
                            ),
                            PrimaryButton(
                                text: 'Отмена',
                                height: 40,
                                background: Colors.grey,
                                onPressed: () => controller.addAddress.value = false
                            )
                          ]
                        ) : GestureDetector(
                            onTap: controller.newAddress,
                            child: Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: ShapeDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(image: AssetImage('assets/image/border.png'), fit: BoxFit.fill),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/icon/plus.png'),
                                      w(8),
                                      Text(
                                          'Добавить адрес',
                                          style: TextStyle(
                                              color: Color(0xFF8A95A8),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500
                                          )
                                      )
                                    ]
                                )
                            )
                        )
                      ]
                    )
                  ),
                  h(20)
                ]
              )
            ]
          )).toList()
        ),
        h(6)
      ]
    );
  }

  Widget _buildMap(CheckoutController controller) {
    return Obx(() => Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.only(top: 20),
        child: YandexMap(
            onMapCreated: (c) {
              if (controller.pvz.isNotEmpty) {
                controller.userLocation.value = Point(latitude: controller.pvz.first.coordY, longitude: controller.pvz.first.coordX);
              }

              c.moveCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: controller.userLocation.value ?? const Point(latitude: 55.853593, longitude: 37.501265),
                          zoom: 12
                      )
                  )
              );
            },
            mapObjects: controller.pvz.map((pvz) {
              return PlacemarkMapObject(
                  mapId: MapObjectId('pvz_${pvz.phone.replaceAll(RegExp(r'[^0-9]'), '')}'),
                  point: Point(latitude: pvz.coordY, longitude: pvz.coordX),
                  icon: PlacemarkIcon.single(
                      PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage('assets/icon/map.png')
                      )
                  ),
                  onTap: (_, __) {
                    showAdaptiveDialog(
                        context: Get.context!,
                        builder: (context) {
                          return AlertDialog(
                              title: Text(pvz.name, textAlign: TextAlign.center),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _infoRow(Icons.location_on, 'Адрес: ${pvz.address}'),
                                    _infoRow(Icons.access_time, 'Часы работы: ${pvz.workTime}'),
                                    _infoRow(Icons.phone, 'Телефон: ${pvz.phone}'),
                                    if (pvz.note.isNotEmpty) Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                            "📌 ${pvz.note}",
                                            style: TextStyle(
                                                fontSize: 14, color: Colors.grey[700])
                                        )
                                    )
                                  ]
                              ),
                              actions: [
                                TextButton(
                                    onPressed: Get.back,
                                    child: Text('Закрыть')
                                ),
                                TextButton(
                                    onPressed: () => controller.setPvz(pvz),
                                    child: Text('Выбрать')
                                )
                              ]
                          );
                        }
                    );
                  }
              );
            }).toList()
        )
    ));
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapBB(CheckoutController controller) {
    return Obx(() => Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.only(top: 20),
        child: YandexMap(
            onMapCreated: (c) {
              if (controller.pvz.isNotEmpty) {
                controller.userLocation.value = Point(latitude: controller.pvz.first.coordY, longitude: controller.pvz.first.coordX);
              }

              c.moveCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: controller.userLocation.value ?? const Point(latitude: 55.853593, longitude: 37.501265),
                          zoom: 12
                      )
                  )
              );
            },
            mapObjects: controller.bbItems.map((pvz) {
              return PlacemarkMapObject(
                  mapId: MapObjectId('pvz_${pvz.id}'),
                  point: Point(latitude: pvz.latitude, longitude: pvz.longitude),
                  icon: PlacemarkIcon.single(
                      PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage('assets/icon/map.png')
                      )
                  ),
                  onTap: (_, __) {
                    showAdaptiveDialog(
                        context: Get.context!,
                        builder: (context) {
                          return AlertDialog(
                              title: Text(pvz.pvzName, textAlign: TextAlign.center),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _infoRow(Icons.location_on, 'Адрес: ${pvz.pvzAddr}'),
                                    _infoRow(Icons.location_on, 'Часы работы: ${pvz.work}'),
                                    _infoRow(Icons.location_on, 'Телефон: ${pvz.phone}'),
                                  ]
                              ),
                              actions: [
                                TextButton(
                                    onPressed: Get.back,
                                    child: Text('Закрыть')
                                ),
                                TextButton(
                                    onPressed: () => controller.bbCallback(pvz),
                                    child: Text('Выбрать')
                                )
                              ]
                          );
                        }
                    );
                  }
              );
            }).toList()
        )
    ));
  }

  Widget _cartItemTile(CartModel product, Function(CartModel) plus, Function(CartModel) minus, Function(String) addWishlist) {
    return GestureDetector(
        onTap: () {
          Get.to(() => ProductView(id: product.id));
        },
        child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: product.image.isNotEmpty ? CachedNetworkImageProvider(product.image) : AssetImage('assets/image/empty.png'),
                              fit: BoxFit.cover
                          )
                      )
                  ),
                  w(12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                product.name,
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700
                                )
                            ),
                            if (product.color.isNotEmpty) h(4),
                            if (product.color.isNotEmpty) Text(
                                'Цвет: ${product.color}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600])
                            ),
                            h(8),
                            Text(
                                product.price,
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700
                                )
                            )
                          ]
                      )
                  ),
                  w(6),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () => addWishlist(product.id),
                            child: Icon(Helper.wishlist.value.contains(product.id) ? Icons.favorite : Icons.favorite_border, color: Helper.wishlist.value.contains(product.id) ? primaryColor : Colors.black, size: 18)
                        ),
                        h(28),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                                children: [
                                  Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          product.quantity = product.quantity! - 1;
                                          minus(product);
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: Icon(Icons.remove, color: Colors.blue, size: 18),
                                      )
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      width: 35,
                                      child: Text(
                                          '${product.quantity}',
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              height: 1.30
                                          )
                                      )
                                  ),
                                  Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          onTap: () {
                                            product.quantity = product.quantity! + 1;
                                            plus(product);
                                          },
                                          borderRadius: BorderRadius.circular(20),
                                          child: Icon(Icons.add, color: Colors.blue, size: 18)
                                      )
                                  )
                                ]
                            )
                        )
                      ]
                  )
                ]
            )
        ));
  }
}