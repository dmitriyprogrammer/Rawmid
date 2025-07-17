import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constant.dart';

class SelectDropDown extends StatefulWidget {
  const SelectDropDown({super.key, required this.callback, required this.values, required this.hint, this.background, this.borderColor, this.color, this.hintColor, this.reset, this.selected});

  final Function(List<String>, int) callback;
  final List<String> values;
  final String hint;
  final Color? background;
  final Color? borderColor;
  final Color? color;
  final Color? hintColor;
  final bool? reset;
  final List<String>? selected;

  @override
  SelectDropDownState createState() => SelectDropDownState();
}

class SelectDropDownState extends State<SelectDropDown> {
  List<String> selected = [];
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if ((widget.selected ?? []).isNotEmpty) {
      selected = widget.selected!;
    }
  }

  void _toggleDropdown() {
    setState(() {
      if (_overlayEntry == null) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      } else {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return OverlayEntry(builder: (_) => const SizedBox());
    final renderBox = renderObject;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final availableSpaceBelow = screenHeight - offset.dy - size.height;
    final availableSpaceAbove = offset.dy;
    final showBelow = availableSpaceBelow > availableSpaceAbove;

    return OverlayEntry(
        builder: (context) => StatefulBuilder(
        builder: (context, localSetState) => Stack(
            children: [
              Positioned.fill(
                  child: GestureDetector(
                      onTap: _toggleDropdown,
                      behavior: HitTestBehavior.opaque,
                      child: Container()
                  )
              ),
              Positioned(
                  left: offset.dx,
                  width: size.width,
                  height: widget.values.length > 6 ? 300 : null,
                  child: CompositedTransformFollower(
                      link: _layerLink,
                      showWhenUnlinked: false,
                      offset: showBelow ? Offset(0, 0) : Offset(0, -((widget.values.length > 6 ? 6 : widget.values.length) * 41).toDouble()),
                      child: GestureDetector(
                          onTap: _toggleDropdown,
                          child: Material(
                              elevation: 0,
                              borderRadius: BorderRadius.circular(8),
                              color: widget.background ?? Color(0xFFDDE8EA),
                              child: Stack(
                                  children: [
                                    if (showBelow) Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                            padding: EdgeInsets.only(left: 16, right: 15, top: 16, bottom: 12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    widget.hint.toLowerCase().capitalizeFirst ?? '',
                                                    style: TextStyle(color: widget.color ?? Colors.black, fontSize: 12)
                                                ),
                                                Icon(Icons.keyboard_arrow_up_rounded, color: widget.color ?? Color(0xFF8A95A8))
                                              ]
                                            )
                                        )
                                    ),
                                    Container(
                                        width: Get.width,
                                        padding: EdgeInsets.only(top: showBelow ? 45 : 0, bottom: !showBelow ? 45 : 12),
                                        child: Scrollbar(
                                            thickness: 2,
                                            radius: Radius.circular(10),
                                            thumbVisibility: true,
                                            controller: scrollController,
                                            child: SingleChildScrollView(
                                                controller: scrollController,
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: List.generate(widget.values.length, (index) => Transform.translate(
                                                        offset: Offset(5, 0),
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              if (selected.contains(widget.values[index])) {
                                                                selected.remove(widget.values[index]);
                                                              } else {
                                                                selected.add(widget.values[index]);
                                                              }
                                                              localSetState(() {});
                                                              widget.callback(selected, index);
                                                            },
                                                            child: Row(
                                                                children: [
                                                                  Checkbox(
                                                                      overlayColor: WidgetStatePropertyAll(primaryColor),
                                                                      side: BorderSide(color: primaryColor, width: 2),
                                                                      checkColor: Colors.white,
                                                                      activeColor: primaryColor,
                                                                      visualDensity: VisualDensity.compact,
                                                                      value: selected.contains(widget.values[index]),
                                                                      onChanged: (val) {
                                                                        if (selected.contains(widget.values[index])) {
                                                                          selected.remove(widget.values[index]);
                                                                        } else {
                                                                          selected.add(widget.values[index]);
                                                                        }
                                                                        localSetState(() {});
                                                                        widget.callback(selected, index);
                                                                      }
                                                                  ),
                                                                  Text(
                                                                      widget.values[index],
                                                                      style: TextStyle(color: widget.color ?? Colors.black)
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                    ))
                                                )
                                            )
                                        )
                                    ),
                                    if (!showBelow) Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 14, bottom: 12),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                      widget.hint.toLowerCase().capitalizeFirst ?? '',
                                                      style: TextStyle(color: widget.color ?? Colors.black, fontSize: 12)
                                                  ),
                                                  Icon(Icons.keyboard_arrow_up_rounded, color: widget.color ?? Color(0xFF8A95A8))
                                                ]
                                            )
                                        )
                                    )
                                  ]
                              )
                          )
                      )
                  )
              )
            ]
        ))
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selected.isNotEmpty && (widget.reset ?? false)) {
      setState(() {
        selected = [];
      });
    }

    return Center(
        child: CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
                onTap: _toggleDropdown,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                        color: _overlayEntry != null ? Colors.transparent : widget.background ?? Colors.white,
                        border: Border.all(color: _overlayEntry == null && widget.borderColor != null ? widget.borderColor! : Color(0xFFDDE8EA), width: 2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              _overlayEntry != null ? '' : selected.isNotEmpty ? '${selected.length} из ${widget.values.length} выбрано' : widget.hint,
                              style: TextStyle(color: selected.isEmpty ? widget.hintColor ?? Color(0xFF8A95A8) : widget.color ?? Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)
                          ),
                          Icon(_overlayEntry != null ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: widget.color ?? Color(0xFF8A95A8))
                        ]
                    )
                )
            )
        )
    );
  }
}