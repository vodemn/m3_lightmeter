import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker.dart/widget_dialog_picker.dart';
import 'package:lightmeter/utils/stop_type_provider.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:provider/provider.dart';

class StopTypeListTile extends StatelessWidget {
  const StopTypeListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.straighten),
      title: Text(S.of(context).fractionalStops),
      trailing: Text(_typeToString(context, context.watch<StopType>())),
      onTap: () {
        showDialog<StopType>(
          context: context,
          builder: (_) => DialogPicker<StopType>(
            title: S.of(context).showFractionalStops,
            selectedValue: context.read<StopType>(),
            values: StopType.values,
            titleAdapter: _typeToString,
          ),
        ).then((value) {
          if (value != null) {
            StopTypeProvider.of(context).set(value);
          }
        });
      },
    );
  }

  String _typeToString(BuildContext context, StopType stopType) {
    switch (stopType) {
      case StopType.full:
        return S.of(context).none;
      case StopType.half:
        return S.of(context).halfStops;
      case StopType.third:
        return S.of(context).thirdStops;
    }
  }
}
