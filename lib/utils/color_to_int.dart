import 'dart:ui';

extension ColorToInt on Color {
  int toInt() {
    return value;

    // Wait for Flutter 3.27.1
    // final a = (this.a * 255).round();
    // final r = (this.r * 255).round();
    // final g = (this.g * 255).round();
    // final b = (this.b * 255).round();

    // return (a << 24) | (r << 16) | (g << 8) | b;
  }
}
