import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/data/models/photography_value.dart';
import 'package:lightmeter/utils/stop_type_provider.dart';
import 'package:provider/provider.dart';

import 'dialog_fractional_stops.dart';

class FractionalStopsListTile extends StatefulWidget {
  const FractionalStopsListTile({super.key});

  @override
  State<FractionalStopsListTile> createState() => _FractionalStopsListTileState();
}

class _FractionalStopsListTileState extends State<FractionalStopsListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(S.of(context).fractionalStops),
      trailing: Text(selectedType),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => FractionalStopsDialog(selectedType: context.read<StopType>()),
        ).then((value) {
          if (value != null) {
            StopTypeProvider.of(context).set(value);
          }
        });
      },
    );
  }

  String get selectedType {
    switch (context.watch<StopType>()) {
      case StopType.full:
        return S.of(context).none;
      case StopType.half:
        return S.of(context).halfStops;
      case StopType.third:
        return S.of(context).thirdStops;
    }
  }
}
