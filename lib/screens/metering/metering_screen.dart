import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/models/photography_value.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/settings_page_route_builder.dart';

import 'components/animated_surface/animated_surface.dart';
import 'components/bottom_controls/bottom_controls.dart';
import 'components/exposure_pairs_list/exposure_pairs_list.dart';
import 'components/topbar/topbar.dart';
import 'metering_bloc.dart';
import 'metering_event.dart';
import 'metering_state.dart';

class MeteringScreen extends StatefulWidget {
  final AnimationController animationController;

  const MeteringScreen({required this.animationController, super.key});

  @override
  State<MeteringScreen> createState() => _MeteringScreenState();
}

class _MeteringScreenState extends State<MeteringScreen> {
  final _topBarKey = GlobalKey(debugLabel: 'TopBarKey');
  final _middleAreaKey = GlobalKey(debugLabel: 'MiddleAreaKey');
  final _bottomBarKey = GlobalKey(debugLabel: 'BottomBarKey');

  bool _secondBuild = false;
  late double _topBarHeight;
  late double _middleAreaHeight;
  late double _bottomBarHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _topBarHeight = _getHeight(_topBarKey);
      _middleAreaHeight = _getHeight(_middleAreaKey);
      _bottomBarHeight = _getHeight(_bottomBarKey);
      setState(() {
        _secondBuild = true;
      });
    });
  }

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
                  if (_secondBuild) SizedBox(height: _topBarHeight) else _topBar(state),
                  Expanded(
                    key: _middleAreaKey,
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
                  if (_secondBuild) SizedBox(height: _bottomBarHeight) else _bottomBar(),
                ],
              ),
              if (_secondBuild)
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  child: MeteringScreenAnimatedSurface.top(
                    controller: widget.animationController,
                    areaHeight: _topBarHeight,
                    overflowSize: _middleAreaHeight / 2,
                    child: _topBar(state),
                  ),
                ),
              if (_secondBuild)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MeteringScreenAnimatedSurface.bottom(
                    controller: widget.animationController,
                    areaHeight: _bottomBarHeight,
                    overflowSize: _middleAreaHeight / 2,
                    child: _bottomBar(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _topBar(MeteringState state) {
    return MeteringTopBar(
      key: _topBarKey,
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
      key: _bottomBarKey,
      onSourceChanged: () {},
      onMeasure: () => context.read<MeteringBloc>().add(const MeasureEvent()),
      onSettings: () {
        Navigator.push(context, SettingsPageRouteBuilder());
      },
    );
  }

  double _getHeight(GlobalKey key) => key.currentContext!.size!.height;
}
