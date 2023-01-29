/// `valueM` represents the base value.
/// All other values differs by 8dp.
class Dimens {
  static const double borderRadiusM = 16;
  static const double borderRadiusL = 24;
  static const double borderRadiusXL = 32;

  static const double grid4 = 4;
  static const double grid8 = 8;
  static const double grid16 = 16;
  static const double grid24 = 24;
  static const double grid48 = 48;
  static const double grid56 = 56;
  static const double grid168 = 168;

  static const double paddingM = 16;
  static const double paddingL = 24;

  static const Duration durationS = Duration(milliseconds: 100);
  static const Duration durationSM = Duration(milliseconds: 150);
  static const Duration durationM = Duration(milliseconds: 200);
  static const Duration durationML = Duration(milliseconds: 250);
  static const Duration durationL = Duration(milliseconds: 300);

  // TopBar
  /// Probably this is a bad practice, but with text size locked, the height is always 212
  static const double readingContainerHeight = 212;

  // `CenteredSlider`
  static const double cameraSliderTrackHeight = grid4;
  static const double cameraSliderTrackRadius = cameraSliderTrackHeight / 2;
  static const double cameraSliderHandleSize = 32;
  static const double cameraSliderHandleIconSize = cameraSliderHandleSize * 2 / 3;
}
