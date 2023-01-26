import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/ev_source/camera/bloc_camera.dart';
import 'package:lightmeter/screens/metering/ev_source/camera/event_camera.dart';
import 'package:lightmeter/screens/metering/ev_source/camera/state_camera.dart';
import 'package:lightmeter/screens/shared/centered_slider/widget_slider_centered.dart';
import 'package:lightmeter/utils/to_string_signed.dart';

class CameraExposureSlider extends StatelessWidget {
  const CameraExposureSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        if (state is CameraActiveState) {
          return Column(
            children: [
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed: state.currentExposureOffset != 0.0
                    ? () => context.read<CameraBloc>().add(const ExposureOffsetChangedEvent(0.0))
                    : null,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimens.grid8),
                      child: _Ruler(state.minExposureOffset, state.maxExposureOffset),
                    ),
                    CenteredSlider(
                      isVertical: true,
                      icon: const Icon(Icons.light_mode),
                      value: state.currentExposureOffset,
                      min: state.minExposureOffset,
                      max: state.maxExposureOffset,
                      onChanged: (value) {
                        context.read<CameraBloc>().add(ExposureOffsetChangedEvent(value));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _Ruler extends StatelessWidget {
  final double min;
  final double max;

  const _Ruler(this.min, this.max);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        (max - min + 1).toInt(),
        (index) {
          final bool showValue = index % 2 == 0.0 || index == 0.0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showValue)
                Text(
                  (index + min).toStringSigned(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              const SizedBox(width: Dimens.grid8),
              ColoredBox(
                color: Theme.of(context).colorScheme.onBackground,
                child: SizedBox(
                  height: 1,
                  width: showValue ? Dimens.grid16 : Dimens.grid8,
                ),
              ),
              const SizedBox(width: Dimens.grid8),
            ],
          );
        },
      ).reversed.toList(),
    );
  }
}
