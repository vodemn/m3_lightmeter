import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LightmeterTextField extends StatefulWidget {
  const LightmeterTextField({
    this.autofocus = false,
    this.controller,
    this.hintText,
    this.initialValue,
    this.inputFormatters,
    this.leading,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
    this.style,
    this.textAlign = TextAlign.start,
  });

  final bool autofocus;
  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? leading;
  final int? maxLength;
  final int? maxLines;
  final void Function(String)? onChanged;
  final TextStyle? style;
  final TextAlign textAlign;

  @override
  State<LightmeterTextField> createState() => _LightmeterTextFieldState();
}

class _LightmeterTextFieldState extends State<LightmeterTextField> {
  late final focusNode = FocusNode(debugLabel: widget.hintText);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autofocus,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      focusNode: focusNode,
      initialValue: widget.initialValue,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      style: widget.style,
      textAlign: widget.textAlign,
      decoration: InputDecoration(
        counter: const SizedBox(),
        contentPadding: EdgeInsets.zero,
        errorStyle: const TextStyle(fontSize: 0),
        icon: widget.leading,
        hintText: widget.hintText,
      ),
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        } else {
          return null;
        }
      },
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
