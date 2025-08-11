import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/general/components/timer/bloc_list_tile_timer.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:lightmeter/utils/guard_pro_tap.dart';

class TimerListTile extends StatelessWidget {
  const TimerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerListTileBloc, bool>(
      builder: (context, state) => SwitchListTile(
        secondary: const Icon(Icons.timer_outlined),
        title: Text(S.of(context).autostartTimer),
        value: context.isPro && state,
        contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
        onChanged: (value) {
          guardProTap(
            context,
            () => context.read<TimerListTileBloc>().onChanged(value),
          );
        },
      ),
    );
  }
}
