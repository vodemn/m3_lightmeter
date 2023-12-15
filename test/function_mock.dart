import 'package:mocktail/mocktail.dart';

class _ValueChanged<T> {
  void onChanged(T value) {}
}

class MockValueChanged<T> extends Mock implements _ValueChanged<T> {}
