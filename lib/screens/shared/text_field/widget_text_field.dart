import 'package:flutter/material.dart';

class LightmeterTextField extends TextFormField {
  LightmeterTextField({
    super.controller,
    super.focusNode,
    super.initialValue,
    super.inputFormatters,
    super.onChanged,
    super.style,
    super.textAlign,
    Widget? leading,
  }) : super(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: 1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            errorStyle: const TextStyle(fontSize: 0),
            icon: leading,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            } else {
              return null;
            }
          },
        );
}
