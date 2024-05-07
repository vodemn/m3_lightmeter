import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/general/components/timer/bloc_list_tile_timer.dart';
import 'package:lightmeter/screens/settings/components/shared/disable/widget_disable.dart';
import 'package:lightmeter/utils/context_utils.dart';

class TimerListTile extends StatelessWidget {
  const TimerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Disable(
      disable: !context.isPro,
      child: BlocBuilder<TimerListTileBloc, bool>(
        builder: (context, state) => SwitchListTile(
          secondary: const Icon(Icons.timer_outlined),
          title: Text(S.of(context).autostartTimer),
          value: state && context.isPro,
          onChanged: context.read<TimerListTileBloc>().onChanged,
          contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
        ),
      ),
    );
  }
}
