import 'package:flutter/material.dart';
import '../../utils/constant.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    this.text,
    this.disable = false,
    this.child,
    this.textStyle = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600
    ),
    this.background,
    this.borderColor,
    this.loaderColor = Colors.white,
    this.borderRadius = 6,
    this.borderWidth = 1,
    this.width = double.infinity,
    this.height = 60,
    this.onPressed,
    this.loader = false,
    this.shadowColor
  });

  final String? text;
  final bool? disable;
  final Widget? child;
  final TextStyle? textStyle;
  final Color? background;
  final Color? borderColor;
  final Color? loaderColor;
  final double? borderRadius;
  final double? borderWidth;
  final double? width;
  final double? height;
  final Function()? onPressed;
  final bool? loader;
  final Color? shadowColor;

  @override
  PrimaryButtonState createState() => PrimaryButtonState();
}

class PrimaryButtonState extends State<PrimaryButton> {
  bool pressButton = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.disable ?? false) ? null : () async {
          if (widget.onPressed != null && !pressButton) {
            if (widget.loader != null) {
              setState(() {
                pressButton = true;
              });
            }

            await widget.onPressed!();

            if (widget.loader != null) {
              setState(() {
                pressButton = false;
              });
            }
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: widget.disable! ? const Color(0xFFCDD9FF) : (widget.background ?? primaryColor),
          minimumSize: Size(widget.width!, widget.height!),
          elevation: 0,
          shadowColor: widget.shadowColor,
          overlayColor: widget.shadowColor,
          disabledBackgroundColor: widget.shadowColor ?? const Color(0xFFCDD9FF),
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              side: BorderSide(width: widget.borderWidth!, color: widget.disable! ? const Color(0xFFCDD9FF) : (widget.borderColor ?? (widget.background ?? Colors.transparent)))
          )
        ),
        child: pressButton ? SizedBox(
            width: (widget.height! / 2.5),
            height: (widget.height! / 2.5),
            child: CircularProgressIndicator(color: widget.loaderColor!)
        ) : widget.child != null ? widget.child! : widget.text != null ? Text(
            widget.text!,
            textAlign: TextAlign.center,
            style: widget.textStyle
        ) : const SizedBox.shrink()
    );
  }
}