import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class ExpandableSectionNameDialog extends StatefulWidget {
  final String title;
  final String hint;
  final String initialValue;

  const ExpandableSectionNameDialog({
    this.initialValue = '',
    required this.title,
    required this.hint,
    super.key,
  });

  @override
  State<ExpandableSectionNameDialog> createState() => _ExpandableSectionNameDialogState();
}

class _ExpandableSectionNameDialogState extends State<ExpandableSectionNameDialog> {
  late final _nameController = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.edit_outlined),
      titlePadding: Dimens.dialogIconTitlePadding,
      title: Text(widget.title),
      content: TextField(
        autofocus: true,
        controller: _nameController,
        decoration: InputDecoration(hintText: widget.hint),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(S.of(context).cancel),
        ),
        ValueListenableBuilder(
          valueListenable: _nameController,
          builder: (_, value, __) => TextButton(
            onPressed: value.text.isNotEmpty ? () => Navigator.of(context).pop(value.text) : null,
            child: Text(S.of(context).save),
          ),
        ),
      ],
    );
  }
}
