import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class CameraHistogram extends StatefulWidget {
  final CameraController controller;

  const CameraHistogram({required this.controller, super.key});

  @override
  _CameraHistogramState createState() => _CameraHistogramState();
}

class _CameraHistogramState extends State<CameraHistogram> {
  List<int> histogramR = List.filled(256, 0);
  List<int> histogramG = List.filled(256, 0);
  List<int> histogramB = List.filled(256, 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startImageStream();
    });
  }

  @override
  void dispose() {
    /// There is no need to stop image stream here,
    /// because this widget will be disposed when CameraController is disposed
    /// widget.controller.stopImageStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        HistogramChannel(
          color: Colors.red,
          values: histogramR,
        ),
        const SizedBox(height: Dimens.grid4),
        HistogramChannel(
          color: Colors.green,
          values: histogramG,
        ),
        const SizedBox(height: Dimens.grid4),
        HistogramChannel(
          color: Colors.blue,
          values: histogramB,
        ),
      ],
    );
  }

  void _startImageStream() {
    widget.controller.startImageStream((CameraImage image) {
      histogramR = List.filled(256, 0);
      histogramG = List.filled(256, 0);
      histogramB = List.filled(256, 0);

      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel!;

      for (int x = 0; x < image.width; x++) {
        for (int y = 0; y < image.height; y++) {
          final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          final int index = y * image.width + x;

          final yp = image.planes[0].bytes[index];
          final up = image.planes[1].bytes[uvIndex];
          final vp = image.planes[2].bytes[uvIndex];

          final r = yp + vp * 1436 / 1024 - 179;
          final g = yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91;
          final b = yp + up * 1814 / 1024 - 227;

          histogramR[r.round().clamp(0, 255)]++;
          histogramG[g.round().clamp(0, 255)]++;
          histogramB[b.round().clamp(0, 255)]++;
        }
      }

      if (mounted) setState(() {});
    });
  }
}

class HistogramChannel extends StatelessWidget {
  final List<int> values;
  final Color color;

  final int _maxOccurences;

  HistogramChannel({
    required this.values,
    required this.color,
    super.key,
  }) : _maxOccurences = values.reduce((value, element) => max(value, element));

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pixelWidth = constraints.maxWidth / values.length;
        return Column(
          children: [
            SizedBox(
              height: Dimens.grid16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: values
                    .map(
                      (e) => SizedBox(
                        height: _maxOccurences == 0 ? 0 : Dimens.grid16 * (e / _maxOccurences),
                        width: pixelWidth,
                        child: ColoredBox(color: color),
                      ),
                    )
                    .toList(),
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
