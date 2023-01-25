import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/photography_values/photography_value.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/bottom_controls/widget_bottom_controls.dart';
import 'components/camera/widget_exposure_slider.dart';
import 'components/camera/widget_zoom_camera.dart';
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
  double topBarOverflow = 0.0;

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
                  MeteringTopBar(
                    fastest: state.fastest,
                    slowest: state.slowest,
                    ev: state.ev,
                    iso: state.iso,
                    nd: state.nd,
                    onIsoChanged: (value) => context.read<MeteringBloc>().add(IsoChangedEvent(value)),
                    onNdChanged: (value) => context.read<MeteringBloc>().add(NdChangedEvent(value)),
                    onCutoutLayout: (value) => topBarOverflow = value,
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => OverflowBox(
                        alignment: Alignment.bottomCenter,
                        maxHeight: constraints.maxHeight + topBarOverflow.abs(),
                        maxWidth: constraints.maxWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: topBarOverflow >= 0 ? EdgeInsets.only(top: topBarOverflow) : EdgeInsets.zero,
                                  child: ExposurePairsList(state.exposurePairs),
                                ),
                              ),
                              const SizedBox(width: Dimens.grid8),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimens.paddingM).add(
                                      topBarOverflow <= 0 ? EdgeInsets.only(top: -topBarOverflow) : EdgeInsets.zero),
                                  child: Column(
                                    children: const [
                                      Expanded(child: CameraExposureSlider()),
                                      SizedBox(height: Dimens.grid24),
                                      CameraZoomSlider(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  MeteringBottomControls(
                    onMeasure: () => context.read<MeteringBloc>().add(const MeasureEvent()),
                    onSettings: () => Navigator.pushNamed(context, 'settings'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
