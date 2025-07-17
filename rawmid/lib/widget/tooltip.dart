import 'package:flutter/material.dart';

class TooltipWidget extends StatefulWidget {
  final Widget child;
  final String message;
  final double? left;

  const TooltipWidget({super.key, required this.child, required this.message, this.left});

  @override
  TooltipWidgetState createState() => TooltipWidgetState();
}

class TooltipWidgetState extends State<TooltipWidget> {
  final GlobalKey _childKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isTooltipVisible = false;

  void _showTooltip() {
    if (_isTooltipVisible) return;

    final overlayState = Overlay.of(context);
    final overlayBox = overlayState.context.findRenderObject() as RenderBox;
    final childBox = _childKey.currentContext?.findRenderObject() as RenderBox?;

    if (childBox == null) return;

    final childPosition = childBox.localToGlobal(Offset.zero, ancestor: overlayBox);

    double tooltipHeight = 40;
    bool showAbove = childPosition.dy > overlayBox.size.height / 2;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: widget.left ?? childPosition.dx + childBox.size.width / 2 - 26,
        top: showAbove
            ? childPosition.dy - tooltipHeight - 20
            : childPosition.dy + childBox.size.height + 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            constraints: BoxConstraints(maxWidth: overlayBox.size.width - 40),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14)
            )
          )
        )
      )
    );

    overlayState.insert(_overlayEntry!);
    _isTooltipVisible = true;

    Future.delayed(Duration(seconds: 3), () {
      _hideTooltip();
    });
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isTooltipVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showTooltip,
      child: Container(
        key: _childKey,
        child: widget.child
      )
    );
  }
}