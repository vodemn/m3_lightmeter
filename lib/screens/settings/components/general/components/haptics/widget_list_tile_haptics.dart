import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';

import 'package:lightmeter/screens/settings/components/general/components/haptics/bloc_list_tile_haptics.dart';

class HapticsListTile extends StatelessWidget {
  const HapticsListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HapticsListTileBloc, bool>(
      builder: (context, state) => SwitchListTile(
        secondary: const Icon(Icons.vibration),
        title: Text(S.of(context).haptics),
        value: state,
        onChanged: context.read<HapticsListTileBloc>().onHapticsChanged,
      ),
    );
  }
}
