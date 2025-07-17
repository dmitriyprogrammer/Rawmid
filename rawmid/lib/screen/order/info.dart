import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/product/product.dart';
import 'package:rawmid/widget/module_title.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../controller/order.dart';
import '../../model/cart.dart';
import '../../model/order_history.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';
import '../../widget/popup_menu.dart';
import '../../widget/w.dart';
import '../../widget/webview_session.dart';

class OrderInfoView extends GetView<OrderController> {
  const OrderInfoView({super.key, required this.order});

  final OrdersModel order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0,
            leadingWidth: 0,
            leading: SizedBox.shrink(),
            title: Padding(
                padding: const EdgeInsets.only(left: 4, right: 20),
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Заказ №${order.id}',
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                                  ),
                                  Transform.translate(
                                    offset: Offset(8, 0),
                                    child: PopupMenuNoPadding(order: order, callback: (val) async => controller.setParam(val, order))
                                  )
                                ]
                            ),
                            Divider(color: Color(0xFFDDE8EA))
                          ]
                      ),
                      h(10),
                      ValueListenableBuilder<int>(
                          valueListenable: Helper.trigger,
                          builder: (context, items, child) => Wrap(
                        runSpacing: 8,
                        children: order.products.map((item) => Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => Get.to(() => ProductView(id: item.id)),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: item.image.isNotEmpty ? CachedNetworkImageProvider(item.image) : AssetImage('assets/image/empty.png'),
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
                                                  item.name,
                                                  style: TextStyle(
                                                      color: Color(0xFF1E1E1E),
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w700
                                                  )
                                              ),
                                              h(8),
                                              Text(
                                                  item.price,
                                                  style: TextStyle(
                                                      color: Color(0xFF1E1E1E),
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700
                                                  )
                                              ),
                                              h(8),
                                              GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: Get.context!,
                                                      isScrollControlled: true,
                                                      useSafeArea: true,
                                                      useRootNavigator: true,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                      ),
                                                      builder: (context) {
                                                        return _openReview(controller, item);
                                                      }
                                                  );
                                                },
                                                child: Text(
                                                    'Разместить отзыв',
                                                    style: TextStyle(
                                                        color: const Color(0xFF8A95A8),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        decoration: TextDecoration.underline
                                                    )
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
                                              onTap: () => controller.addWishlist(item.id),
                                              child: Icon(Helper.wishlist.value.contains(item.id) ? Icons.favorite : Icons.favorite_border, color: Helper.wishlist.value.contains(item.id) ? primaryColor : Colors.black, size: 18)
                                          )
                                        ]
                                    )
                                  ]
                              )
                            )
                        )).toList()
                      )),
                      ModuleTitle(title: 'Доставка', type: true),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Способ доставки:  ',
                                style: TextStyle(
                                    color: Color(0xFF8A95A8),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.30
                                )
                            ),
                            TextSpan(
                                text: order.shipping.replaceAll(';', ' ').trim(),
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.30
                                )
                            )
                          ]
                        )
                      ),
                      h(12),
                      Row(
                        children: [
                          Image.asset('assets/icon/mark2.png', width: 9),
                          w(8),
                          Text(
                            order.address,
                            style: TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 11,
                              letterSpacing: 0.22
                            )
                          )
                        ]
                      ),
                      h(32),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: ShapeDecoration(
                            color: Color(0xFF009FE6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8)
                              )
                            )
                          ),
                          child: OrderStatusWidget(currentStatus: order.history.isNotEmpty ? order.history.first.status : '', history: order.history)
                      ),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)
                              )
                            )
                          ),
                          child: Column(
                            children: List.generate(order.history.length, (index) {
                              final history = order.history.reversed.toList()[index];
                              final isActive = index == order.history.length-1;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(right: 6, top: 6, bottom: 6),
                                        child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle
                                            )
                                        )
                                      ),
                                      if (order.history.length-1 > index) Container(
                                          margin: EdgeInsets.only(left: 5),
                                          width: 2,
                                          height: 28,
                                          color: Colors.black
                                      )
                                    ]
                                  ),
                                  w(2),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        h(1),
                                        Text(
                                          history.status,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal
                                          )
                                        ),
                                        if (history.date != null) Text(
                                          controller.formatDateCustom(history.date!),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 11
                                          )
                                        )
                                      ]
                                    )
                                  )
                                ]
                              );
                            })
                          )
                      ),
                      Builder(
                        builder: (context) {
                          final comments = order.history.where((e) => e.comment.isNotEmpty);
                          final visible = order.comment.isNotEmpty || comments.isNotEmpty;

                          return Column(
                            children: [
                              if (visible) h(32),
                              if (visible) ModuleTitle(title: 'Комментарий к заказу', type: true),
                              if (visible) Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFEBF3F6),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Column(
                                      spacing: 14,
                                      children: [
                                        if (order.comment.isNotEmpty) Row(
                                            spacing: 8,
                                            children: [
                                              Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: ShapeDecoration(
                                                      image: DecorationImage(
                                                        image: order.avatar.isNotEmpty ? CachedNetworkImageProvider(order.avatar) : AssetImage('assets/icon/us.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      shape: OvalBorder()
                                                  )
                                              ),
                                              Text(
                                                  order.comment,
                                                  style: TextStyle(
                                                      color: Color(0xFF1E1E1E),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600
                                                  )
                                              )
                                            ]
                                        ),
                                        ...comments.map((e) => Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            spacing: 8,
                                            children: [
                                              Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: ShapeDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage('assets/icon/us.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      shape: OvalBorder()
                                                  )
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: !e.comment.contains('</') ? 6 : 0),
                                                  child: !e.comment.contains('</') ? Text(
                                                      e.comment,
                                                      style: TextStyle(
                                                          color: Color(0xFF1E1E1E),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600
                                                      )
                                                  ) : Transform.translate(
                                                    offset: Offset(-6, -5),
                                                    child: DefaultTextStyle.merge(
                                                        style: TextStyle(
                                                          fontFamily: 'Manrope',
                                                          fontSize: 17
                                                        ),
                                                        child: Html(
                                                        data: e.comment,
                                                        style: {
                                                          '*': Style(
                                                              textDecoration: TextDecoration.none
                                                          )
                                                        },
                                                        onLinkTap: (val, map, element) {
                                                          if ((val ?? '').isNotEmpty) {
                                                            final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
                                                            String clean = e.comment.replaceAll(exp, '');
                                                            Helper.launchInBrowser(val!, title: clean.replaceAll(RegExp(r'\s+'), ' ').trim());
                                                          }
                                                        }
                                                    ))
                                                  )
                                                )
                                              )
                                            ]
                                        ))
                                      ]
                                  )
                              ),
                            ]
                          );
                        }
                      ),
                      h(32),
                      ModuleTitle(title: 'История заказа', type: true),
                      Row(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Статус заказа:',
                            style: TextStyle(
                              color: Color(0xFF8A95A8),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.30
                            )
                          ),
                          Text(
                              order.status,
                              style: TextStyle(
                                  color: Color(order.payD == 1 ? 0xFF03A34B : 0xFFDA2E2E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                              )
                          )
                        ]
                      ),
                      h(32),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                              borderRadius: BorderRadius.circular(8)
                            )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 12,
                            children: [
                              Row(
                                spacing: 12,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Image.asset('assets/image/barcode.jpg', width: 160, height: 60, fit: BoxFit.fill)
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Товарный чек № ${order.id}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.30
                                              )
                                          ),
                                          if (order.dateAdded != null) Text(
                                              'от ${controller.formatDateCustom(order.dateAdded!)}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11,
                                                  letterSpacing: 0.22
                                              )
                                          )
                                        ]
                                    )
                                  )
                                ]
                              ),
                              Column(
                                spacing: 12,
                                children: List.generate(order.products.length, (index) {
                                  final product = order.products[index];

                                  return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                                          borderRadius: BorderRadius.circular(8)
                                        )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        spacing: 12,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              product.name,
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Color(0xFF1E1E1E),
                                                fontSize: 11
                                              )
                                            )
                                          ),
                                          Flexible(
                                            child: Text(
                                              'X${product.quantity}',
                                              style: TextStyle(
                                                color: Color(0xFF1E1E1E),
                                                fontSize: 11
                                              )
                                            )
                                          ),
                                          Flexible(
                                            child: Text(
                                              product.price,
                                              style: TextStyle(
                                                color: Color(0xFF1E1E1E),
                                                fontSize: 11
                                              )
                                            )
                                          )
                                        ]
                                      )
                                  );
                                })
                              ),
                              Column(
                                spacing: 6,
                                children: List.generate(order.totals.length, (index) {
                                  final total = order.totals[index];
                                  final last = order.totals.length-1 == index;

                                  return Padding(
                                    padding: EdgeInsets.only(top: last ? 12 : 0),
                                    child: Row(
                                        spacing: 40,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                                total.title,
                                                style: TextStyle(
                                                    color: Color(0xFF1E1E1E),
                                                    fontSize: 15,
                                                    fontWeight: last ? FontWeight.w700 : FontWeight.w500
                                                )
                                            )
                                          ),
                                          Text(
                                              total.text,
                                              style: TextStyle(
                                                  color: Color(0xFF1E1E1E),
                                                  fontSize: 15,
                                                  fontWeight: last ? FontWeight.w700 : FontWeight.w500
                                              )
                                          )
                                        ]
                                    )
                                  );
                                })
                              ),
                              Divider(color: Color(0xFFDDE8EA), height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Спасибо за покупку',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.30
                                      )
                                  )
                                ]
                              ),
                              PrimaryButton(text: 'Распечатать чек', height: 45, loader: true, onPressed: () => Get.to(() => WebViewWithSession(link: order.print)))
                            ]
                          )
                      ),
                      h(20 + MediaQuery.of(context).padding.bottom)
                    ]
                )
            )
        )
    );
  }

  Widget _openReview(OrderController controller, CartModel product) {
    return Padding(
        padding: EdgeInsets.only(
            left: 16, right: 16, top: 20, bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20
        ),
        child: Form(
            key: controller.formKey,
            child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Оставьте отзыв',
                      style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      )
                  ),
                  h(16),
                  Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                                imageUrl: product.image,
                                errorWidget: (c, e, i) {
                                  return Image.asset('assets/image/no_image.png');
                                },
                                height: 64,
                                width: 64,
                                fit: BoxFit.cover
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700
                                      )
                                  ),
                                  if (product.color.isNotEmpty) Text(
                                      'Цвет: ${product.color}',
                                      style: TextStyle(
                                          color: Color(0xFF8A95A8),
                                          fontSize: 12
                                      )
                                  )
                                ]
                            )
                        ),
                        w(12),
                        Text(
                            product.price,
                            style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 18,
                                fontWeight: FontWeight.w700
                            )
                        )
                      ]
                  ),
                  h(20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(Icons.star, color: index < controller.rating.value ? Colors.amber : Color(0x4CFFCC00), size: 40),
                          onPressed: () => controller.rating.value = index+1,
                          padding: EdgeInsets.zero,
                        );
                      })
                  ),
                  h(20),
                  TextFormField(
                      cursorHeight: 15,
                      controller: controller.fioReviewField,
                      decoration: decorationInput(hint: 'Имя', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите ваше ФИО';
                        }

                        return null;
                      }
                  ),
                  h(10),
                  if (controller.navController.user.value == null) TextFormField(
                      controller: controller.emailReviewField,
                      cursorHeight: 15,
                      decoration: decorationInput(error: controller.emailValidate.value ? dangerColor : null, hint: 'E-mail', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: controller.validateEmailX,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите E-mail';
                        } else if ((val ?? '').isNotEmpty && !EmailValidator.validate(val!)) {
                          return 'E-mail заполнен некорректно';
                        }

                        return null;
                      }
                  ),
                  if (controller.navController.user.value == null && controller.emailValidate.value) Padding(
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
                  ),
                  if (controller.navController.user.value == null) h(10),
                  TextFormField(
                      controller: controller.textReviewField,
                      decoration: decorationInput(hint: 'Текст', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 3,
                      cursorHeight: 15,
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Напишите ваш отзыв';
                        }

                        return null;
                      }
                  ),
                  h(20),
                  PrimaryButton(text: 'Опубликовать отзыв', loader: true, height: 50, onPressed: () => controller.addReview(product.id)),
                  h(20)
                ]
            ))
        )
    );
  }
}

class OrderStatusStep {
  final String title;
  final String icon;
  final String iconComplete;
  final bool isFinal;
  final List<String> subStatuses;

  OrderStatusStep({
    required this.title,
    required this.icon,
    required this.iconComplete,
    this.isFinal = false,
    this.subStatuses = const [],
  });
}

class OrderStatusWidget extends StatelessWidget {
  final String currentStatus;
  final List<HistoryOrder> history;

  const OrderStatusWidget({
    super.key,
    required this.currentStatus,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final statusSteps = [
      OrderStatusStep(
        title: 'Ожидает оплату',
        icon: 's1',
        iconComplete: 's2',
        subStatuses: [
          'Оплата получена'
        ]
      ),
      OrderStatusStep(
        title: 'В процессе отгрузки',
        icon: 's3',
        iconComplete: 's4',
        subStatuses: [
          'Отправляем',
          'Отправлен',
          'Создана заявка в ТК',
          'Готовится к отправке',
          'Укомплектован'
        ]
      ),
      OrderStatusStep(
        title: 'Передан курьеру',
        icon: 's5',
        iconComplete: 's6',
        subStatuses: [
          'Доставляется',
          'Ожидает получения'
        ]
      ),
      OrderStatusStep(
        title: 'Завершен',
        icon: 's7',
        iconComplete: 's8',
        isFinal: true,
        subStatuses: [
          'Завершен',
          'Отменен'
        ]
      )
    ];

    final completedStatuses = history.map((h) => h.status).toSet();
    List<Widget> widgets = [];

    for (int i = 0; i < statusSteps.length; i++) {
      final step = statusSteps[i];
      var isCompleted = completedStatuses.contains(step.title);
      var isCurrent = step.title == currentStatus;

      if (currentStatus == 'Отменен') {
        isCompleted = true;
        isCurrent = true;
      }

      final iconFile = isCompleted || isCurrent ? step.iconComplete : step.icon;

      Widget iconWidget = Image.asset(
        'assets/icon/$iconFile.png',
        width: 24,
        height: 24
      );

      final matchedSubStatuses = step.subStatuses.where((sub) => completedStatuses.contains(sub)).length;
      var progress = step.subStatuses.isEmpty ? 0.0 : matchedSubStatuses / step.subStatuses.length;

      if (currentStatus == 'Отменен') {
        progress = 1;
      }

      final progressBar = Container(
        width: 22,
        height: 6,
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(3),
        ),
        clipBehavior: Clip.antiAlias,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3)
            )
          )
        )
      );

      widgets.add(
        Flexible(
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                iconWidget,
                h(4),
                Text(
                  step.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    letterSpacing: 0.22
                  )
                )
              ]
            )
          )
        )
      );

      if (i < statusSteps.length - 1) {
        widgets.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              progressBar
            ]
          )
        );
      }
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets
      )
    );
  }
}