import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/photography_values/photography_value.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';

import 'components/bottom_controls/widget_bottom_controls.dart';
import 'components/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'components/topbar/widget_topbar.dart';
import 'bloc_metering.dart';
import 'event_metering.dart';
import 'state_metering.dart';

class MeteringScreen extends StatefulWidget {
  const MeteringScreen({super.key});

  @override
  State<MeteringScreen> createState() => _MeteringScreenState();
}

class _MeteringScreenState extends State<MeteringScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MeteringBloc>().add(StopTypeChangedEvent(context.watch<StopType>()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocBuilder<MeteringBloc, MeteringState>(
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: [
                  _topBar(state),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
                      child: Row(
                        children: [
                          Expanded(child: ExposurePairsList(state.exposurePairs)),
                        ],
                      ),
                    ),
                  ),
                  _bottomBar(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _topBar(MeteringState state) {
    return MeteringTopBar(
      fastest: state.fastest,
      slowest: state.slowest,
      ev: state.ev,
      iso: state.iso,
      nd: state.nd,
      onIsoChanged: (value) => context.read<MeteringBloc>().add(IsoChangedEvent(value)),
      onNdChanged: (value) => context.read<MeteringBloc>().add(NdChangedEvent(value)),
    );
  }

  Widget _bottomBar() {
    return MeteringBottomControls(
      onSourceChanged: () {},
      onMeasure: () => context.read<MeteringBloc>().add(const MeasureEvent()),
      onSettings: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
      },
    );
  }
}
