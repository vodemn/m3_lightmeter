import 'package:flutter/material.dart';

class LightmeterTextField extends TextFormField {
  LightmeterTextField({
    super.controller,
    super.autofocus,
    super.initialValue,
    super.inputFormatters,
    super.maxLength,
    super.onChanged,
    super.style,
    super.textAlign,
    Widget? leading,
    String? hintText,
  }) : super(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: 1,
          decoration: InputDecoration(
            counter: const SizedBox(),
            contentPadding: EdgeInsets.zero,
            errorStyle: const TextStyle(fontSize: 0),
            icon: leading,
            hintText: hintText,
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
