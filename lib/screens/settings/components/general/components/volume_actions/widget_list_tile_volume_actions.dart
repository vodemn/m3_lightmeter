import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/general/components/volume_actions/bloc_list_tile_volume_actions.dart';

class VolumeActionsListTile extends StatelessWidget {
  const VolumeActionsListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VolumeActionsListTileBloc, bool>(
      builder: (context, state) => SwitchListTile(
        secondary: const Icon(Icons.volume_up),
        title: Text(S.of(context).volumeKeysAction),
        value: state,
        onChanged: context.read<VolumeActionsListTileBloc>().onVolumeActionChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
      ),
    );
  }
}
