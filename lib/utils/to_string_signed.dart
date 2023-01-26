extension SignedString on num {
  String toStringSigned() {
    if (this > 0) {
      return "+${toString()}";
    } else {
      return toString();
    }
  }
}

extension SignedStringDouble on double {
  String toStringSignedAsFixed(fractionDigits) {
    if (this > 0) {
      return "+${toStringAsFixed(fractionDigits)}";
    } else {
      return toStringAsFixed(fractionDigits);
    }
  }
}
