import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/general/components/volume_actions/bloc_list_tile_volume_actions.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker.dart/widget_dialog_picker.dart';

class VolumeActionsListTile extends StatelessWidget {
  const VolumeActionsListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VolumeActionsListTileBloc, VolumeAction>(
      builder: (context, state) => ListTile(
        leading: const Icon(Icons.volume_up),
        title: Text(S.of(context).volumeKeysAction),
        trailing: Text(actionToString(context, state)),
        onTap: () {
          showDialog<VolumeAction>(
            context: context,
            builder: (_) => DialogPicker<VolumeAction>(
              icon: Icons.volume_up,
              title: S.of(context).volumeKeysAction,
              selectedValue: state,
              values: VolumeAction.values,
              titleAdapter: (context, value) => actionToString(context, value),
            ),
          ).then((value) {
            if (value != null) {
              context.read<VolumeActionsListTileBloc>().onVolumeActionChanged(value);
            }
          });
        },
      ),
    );
  }

  String actionToString(BuildContext context, VolumeAction themeType) {
    switch (themeType) {
      case VolumeAction.shutter:
        return S.of(context).shutter;
      case VolumeAction.zoom:
        return S.of(context).zoom;
      case VolumeAction.none:
        return S.of(context).none;
    }
  }
}
