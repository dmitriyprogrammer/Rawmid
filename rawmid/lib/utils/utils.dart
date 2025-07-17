import 'package:flutter/material.dart';
import 'constant.dart';

InputDecoration decorationInput({String? hint, Color? error, Widget? suffixIcon, Widget? prefixIcon, EdgeInsets? contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14)}) {
  return InputDecoration(
      hintText: hint,
      contentPadding: contentPadding,
      hintStyle: TextStyle(
          color: Color(0xFF8A95A8),
          fontSize: 12,
          fontWeight: FontWeight.w500
      ),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2,
              color: dangerColor
          ),
          borderRadius: BorderRadius.circular(8)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 2,
              color: error ?? Color(0xFFDDE8EA)
          ),
          borderRadius: BorderRadius.circular(8)
      ),
      errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2,
              color: dangerColor
          ),
          borderRadius: BorderRadius.circular(8)
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 2,
              color: error ?? Color(0xFFDDE8EA)
          ),
          borderRadius: BorderRadius.circular(8)
      ),
      disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2,
              color: Color(0xFFDDE8EA)
          ),
          borderRadius: BorderRadius.circular(8)
      ),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon
  );
}