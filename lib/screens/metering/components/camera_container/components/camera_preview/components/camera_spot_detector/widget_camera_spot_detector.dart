import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class CameraSpotDetector extends StatefulWidget {
  final ValueChanged<Offset?> onSpotTap;

  const CameraSpotDetector({
    required this.onSpotTap,
    super.key,
  });

  @override
  State<CameraSpotDetector> createState() => _CameraSpotDetectorState();
}

class _CameraSpotDetectorState extends State<CameraSpotDetector> {
  Offset? spot;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (TapDownDetails details) => onViewFinderTap(details, constraints),
        onLongPress: () => onViewFinderTap(null, constraints),
        child: Stack(
          children: [
            if (spot != null)
              AnimatedPositioned(
                duration: Dimens.durationS,
                left: spot!.dx - Dimens.grid16 / 2,
                top: spot!.dy - Dimens.grid16 / 2,
                height: Dimens.grid16,
                width: Dimens.grid16,
                child: const _Spot(),
              ),
          ],
        ),
      ),
    );
  }

  void onViewFinderTap(TapDownDetails? details, BoxConstraints constraints) {
    setState(() {
      spot = details?.localPosition;
    });

    widget.onSpotTap(
      details != null
          ? Offset(
              details.localPosition.dx / constraints.maxWidth,
              details.localPosition.dy / constraints.maxHeight,
            )
          : null,
    );
  }
}

class _Spot extends StatelessWidget {
  const _Spot();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white70,
        shape: BoxShape.circle,
      ),
    );
  }
}
