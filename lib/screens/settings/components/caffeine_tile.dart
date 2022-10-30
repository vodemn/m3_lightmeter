import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

class CaffeineListTile extends StatefulWidget {
  const CaffeineListTile({super.key});

  @override
  State<CaffeineListTile> createState() => _CaffeineListTileState();
}

class _CaffeineListTileState extends State<CaffeineListTile> {
  bool _isCaffeineOn = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.coffee),
      title: Text(S.of(context).caffeine),
      subtitle: Text(S.of(context).keepsScreenOn),
      value: _isCaffeineOn,
      onChanged: (value) {
        setState(() {
          _isCaffeineOn = value;
        });
      },
    );
  }
}
