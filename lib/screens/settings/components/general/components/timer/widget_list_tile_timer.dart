import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/general/components/timer/bloc_list_tile_timer.dart';
import 'package:lightmeter/screens/settings/components/shared/iap_switch_list_tile/widget_iap_switch_list_tile.dart';

class TimerListTile extends StatelessWidget {
  const TimerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerListTileBloc, bool>(
      builder: (context, state) => IAPSwitchListTile(
        secondary: const Icon(Icons.timer_outlined),
        title: Text(S.of(context).autostartTimer),
        value: state,
        onChanged: context.read<TimerListTileBloc>().onChanged,
      ),
    );
  }
}
