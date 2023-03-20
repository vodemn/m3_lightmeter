import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

class EquipmentProfileNameDialog extends StatefulWidget {
  const EquipmentProfileNameDialog({super.key});

  @override
  State<EquipmentProfileNameDialog> createState() => _EquipmentProfileNameDialogState();
}

class _EquipmentProfileNameDialogState extends State<EquipmentProfileNameDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).equipmentProfileName),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(hintText: S.of(context).equipmentProfileNameHint),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(S.of(context).cancel),
        ),
        ValueListenableBuilder(
          valueListenable: _nameController,
          builder: (_, value, __) => TextButton(
            onPressed: value.text.isNotEmpty
                ? () => Navigator.of(context).pop(value.text.isNotEmpty)
                : null,
            child: Text(S.of(context).save),
          ),
        ),
      ],
    );
  }
}
