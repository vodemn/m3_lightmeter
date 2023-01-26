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

  MeteringBloc get _bloc => context.read<MeteringBloc>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc.add(StopTypeChangedEvent(context.watch<StopType>()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocBuilder<MeteringBloc, MeteringState>(
        builder: (context, state) => Column(
          children: [
            MeteringTopBar(
              fastest: state.fastest,
              slowest: state.slowest,
              ev: state.ev,
              iso: state.iso,
              nd: state.nd,
              onIsoChanged: (value) => _bloc.add(IsoChangedEvent(value)),
              onNdChanged: (value) => _bloc.add(NdChangedEvent(value)),
              onCutoutLayout: (value) => topBarOverflow = value,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
                child: _MiddleContentWrapper(
                  topBarOverflow: topBarOverflow,
                  leftContent: ExposurePairsList(state.exposurePairs),
                  rightContent: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimens.paddingM),
                    child: Column(
                      children: const [
                        Expanded(child: CameraExposureSlider()),
                        SizedBox(height: Dimens.grid24),
                        CameraZoomSlider(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            MeteringBottomControls(
              onMeasure: () => _bloc.add(const MeasureEvent()),
              onSettings: () => Navigator.pushNamed(context, 'settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiddleContentWrapper extends StatelessWidget {
  final double topBarOverflow;
  final Widget leftContent;
  final Widget rightContent;

  const _MiddleContentWrapper({
    required this.topBarOverflow,
    required this.leftContent,
    required this.rightContent,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => OverflowBox(
        alignment: Alignment.bottomCenter,
        maxHeight: constraints.maxHeight + topBarOverflow.abs(),
        maxWidth: constraints.maxWidth,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: topBarOverflow >= 0 ? topBarOverflow : 0),
                child: leftContent,
              ),
            ),
            const SizedBox(width: Dimens.grid8),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: topBarOverflow <= 0 ? -topBarOverflow : 0),
                child: rightContent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
