import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_preview/components/camera_view/widget_camera_view.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_preview/components/camera_view_placeholder/widget_placeholder_camera_view.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_preview/components/histogram/widget_histogram.dart';
import 'package:lightmeter/screens/metering/components/camera_container/models/camera_error_type.dart';

class CameraPreview extends StatefulWidget {
  final CameraController? controller;
  final CameraErrorType? error;

  const CameraPreview({this.controller, this.error, super.key});

  @override
  State<CameraPreview> createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<CameraPreview> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: PlatformConfig.cameraPreviewAspectRatio,
      child: Center(
        child: Stack(
          children: [
            const CameraViewPlaceholder(error: null),
            AnimatedSwitcher(
              duration: Dimens.switchDuration,
              child: widget.controller != null
                  ? ValueListenableBuilder<CameraValue>(
                      valueListenable: widget.controller!,
                      builder: (_, __, ___) => Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          if (widget.controller!.value.isInitialized)
                            CameraView(controller: widget.controller!),
                          if (widget.controller!.value.isInitialized)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: Dimens.borderRadiusM,
                              child: CameraHistogram(controller: widget.controller!),
                            ),
                        ],
                      ),
                    )
                  : CameraViewPlaceholder(error: widget.error),
            ),
          ],
        ),
      ),
    );
  }
}
