import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/metering_event.dart';

import 'components/bottom_controls/bottom_controls.dart';
import 'components/exposure_pairs_list/exposure_pairs_list.dart';
import 'components/topbar/topbar.dart';
import 'metering_bloc.dart';
import 'metering_state.dart';

class MeteringScreen extends StatelessWidget {
  const MeteringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocBuilder<MeteringBloc, MeteringState>(
        builder: (context, state) {
          return Column(
            children: [
              MeteringTopBar(
                fastest: state.fastest,
                slowest: state.slowest,
                ev: state.ev,
                iso: state.iso,
                nd: state.nd,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ExposurePairsList(state.exposurePairs),
                      ),
                      const SizedBox(width: Dimens.grid16),
                      const Spacer()
                    ],
                  ),
                ),
              ),
              MeteringBottomControls(
                onSourceChanged: () {},
                onMeasure: () => context.read<MeteringBloc>().add(const MeasureEvent()),
                onSettings: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}
