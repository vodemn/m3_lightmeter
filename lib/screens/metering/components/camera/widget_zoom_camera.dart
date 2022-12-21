import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/screens/metering/ev_source/camera/bloc_camera.dart';
import 'package:lightmeter/screens/metering/ev_source/camera/event_camera.dart';
import 'package:lightmeter/screens/metering/ev_source/camera/state_camera.dart';

import 'shared/widget_slider_camera.dart';

class CameraZoomSlider extends StatelessWidget {
  const CameraZoomSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        if (state is CameraActiveState) {
          return CameraSlider(
            icon: const Icon(Icons.search),
            value: state.currentZoom,
            min: state.minZoom,
            max: state.maxZoom,
            onChanged: (value) {
              context.read<CameraBloc>().add(ZoomChangedEvent(value));
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
