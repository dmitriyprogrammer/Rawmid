import 'package:flutter/material.dart';
import '../model/order_history.dart';
import '../utils/constant.dart';

class PopupMenuNoPadding extends StatefulWidget {
  const PopupMenuNoPadding({super.key, required this.order, required this.callback});

  final OrdersModel order;
  final Function(int) callback;

  @override
  PopupMenuNoPaddingState createState() => PopupMenuNoPaddingState();
}

class PopupMenuNoPaddingState extends State<PopupMenuNoPadding> {
  final GlobalKey _menuKey = GlobalKey();

  void _showCustomMenu(BuildContext context) {
    final RenderBox button = _menuKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<int>(
      context: context,
      position: position,
      menuPadding: EdgeInsets.zero,
      color: Colors.white,
      items: [
        if (widget.order.cancel) PopupMenuItem<int>(
          value: 1,
          child: const Text('Отменить заказ', style: TextStyle(color: dangerColor))
        ),
        PopupMenuItem<int>(
            value: 2,
            child: const Text('Задать вопрос')
        ),
        PopupMenuItem<int>(
            value: 3,
            child: const Text('Переоформить')
        ),
        if (widget.order.payLink.isNotEmpty) PopupMenuItem<int>(
            value: 4,
            child: Text(widget.order.payText)
        )
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      )
    ).then((value) {
      if (value != null) {
        widget.callback(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _menuKey,
      child: const Icon(Icons.more_vert, color: primaryColor),
      onTap: () => _showCustomMenu(context)
    );
  }
}