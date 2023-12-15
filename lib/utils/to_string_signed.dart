/// Returns value in form -1 or + 1. The only exception - 0.
extension SignedStringDouble on double {
  String toStringSignedAsFixed(int fractionDigits) {
    if (this > 0) {
      return "+${toStringAsFixed(fractionDigits)}";
    } else {
      return toStringAsFixed(fractionDigits);
    }
  }
}
