import 'package:flutter/material.dart';
import 'package:rawmid/utils/extension.dart';
import '../utils/constant.dart';

class SwitchTile extends StatelessWidget {
  const SwitchTile({super.key, required this.title, required this.value, required this.onChanged});

  final String title;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(
            title,
            style: TextStyle(
                color: Color(0xFF141414),
                fontSize: 14,
                height: 1.40,
                letterSpacing: 0.14
            )
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
          return primaryColor.withOpacityX(0.2);
        }),
        thumbColor: WidgetStatePropertyAll(Colors.white),
        inactiveThumbImage: AssetImage('assets/icon/inactive_color.png'),
        activeColor: primaryColor,
        inactiveTrackColor: Color(0xFFF6F8F9),
        inactiveThumbColor: primaryColor,
        contentPadding: EdgeInsets.zero,
        value: value,
        onChanged: onChanged
    );
  }
}