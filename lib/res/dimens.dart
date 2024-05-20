import 'package:flutter/material.dart';

/// `valueM` represents the base value.
/// All other values differs by 8dp.
class Dimens {
  static const double borderRadiusM = 16;
  static const double borderRadiusL = 24;
  static const double borderRadiusXL = 32;

  static const double elevationLevel0 = 0;
  static const double elevationLevel1 = 1;
  static const double elevationLevel2 = 3;
  static const double elevationLevel3 = 6;

  static const double grid4 = 4;
  static const double grid8 = 8;
  static const double grid16 = 16;
  static const double grid24 = 24;
  static const double grid48 = 48;
  static const double grid56 = 56;
  static const double grid72 = 72;

  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;

  static const Duration durationS = Duration(milliseconds: 100);
  static const Duration durationSM = Duration(milliseconds: 150);
  static const Duration durationM = Duration(milliseconds: 200);
  static const Duration durationML = Duration(milliseconds: 250);
  static const Duration durationL = Duration(milliseconds: 300);
  static const Duration switchDuration = Duration(milliseconds: 100);

  static const double enabledOpacity = 1.0;
  static const double disabledOpacity = 0.38;

  static const double sliverAppBarExpandedHeight = 168;

  // TopBar
  static const double readingContainerDoubleValueHeight = 128;
  static const double readingContainerSingleValueHeight = 76;

  // `CenteredSlider`
  static const double cameraSliderTrackHeight = grid4;
  static const double cameraSliderTrackRadius = cameraSliderTrackHeight / 2;
  static const double cameraSliderHandleArea = 32;
  static const double cameraSliderHandleSize = 24;
  static const double cameraSliderHandleIconSize = cameraSliderHandleSize * 2 / 3;

  // Dialog
  // Taken from `Dialog` documentation
  static const EdgeInsets dialogTitlePadding = EdgeInsets.fromLTRB(
    paddingL,
    paddingL,
    paddingL,
    paddingM,
  );
  static const EdgeInsets dialogIconTitlePadding = EdgeInsets.fromLTRB(
    paddingL,
    0,
    paddingL,
    paddingM,
  );
  static const EdgeInsets dialogActionsPadding = EdgeInsets.fromLTRB(
    paddingM,
    paddingM,
    paddingL,
    paddingL,
  );
  static const EdgeInsets dialogMargin = EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0);
}
