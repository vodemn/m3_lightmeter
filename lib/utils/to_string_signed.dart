extension SignedString on num {
  String toStringSigned() {
    if (this > 0) {
      return "+${toString()}";
    } else {
      return toString();
    }
  }
}
