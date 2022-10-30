import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

class HapticsListTile extends StatefulWidget {
  const HapticsListTile({super.key});

  @override
  State<HapticsListTile> createState() => _HapticsListTileState();
}

class _HapticsListTileState extends State<HapticsListTile> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.vibration),
      title: Text(S.of(context).haptics),
      value: _value,
      onChanged: (value) {
        setState(() {
          _value = value;
        });
      },
    );
  }
}
