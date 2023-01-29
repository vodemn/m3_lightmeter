import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/exposure_offset_slider/widget_slider_exposure_offset.dart';
import 'components/zoom_slider/widget_slider_zoom.dart';

class CameraControls extends StatelessWidget {
  final RangeValues exposureOffsetRange;
  final double exposureOffsetValue;
  final ValueChanged<double> onExposureOffsetChanged;

  final RangeValues zoomRange;
  final double zoomValue;
  final ValueChanged<double> onZoomChanged;

  const CameraControls({
    required this.exposureOffsetRange,
    required this.exposureOffsetValue,
    required this.onExposureOffsetChanged,
    required this.zoomRange,
    required this.zoomValue,
    required this.onZoomChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ExposureOffsetSlider(
            range: exposureOffsetRange,
            value: exposureOffsetValue,
            onChanged: onExposureOffsetChanged,
          ),
        ),
        const SizedBox(height: Dimens.grid24),
        ZoomSlider(
          range: zoomRange,
          value: zoomValue,
          onChanged: onZoomChanged,
        ),
      ],
    );
  }
}
