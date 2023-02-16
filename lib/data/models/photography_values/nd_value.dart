import 'package:lightmeter/utils/log_2.dart';

import 'photography_value.dart';

class NdValue extends PhotographyValue<int> {
  const NdValue(super.rawValue);

  double get stopReduction => value == 0 ? 0.0 : log2(value);

  @override
  String toString() => 'ND$value';
}

/// https://shuttermuse.com/neutral-density-filter-numbers-names/
const List<NdValue> ndValues = [
  NdValue(0),
  NdValue(2),
  NdValue(4),
  NdValue(8),
  NdValue(16),
  NdValue(32),
  NdValue(64),
  NdValue(100),
  NdValue(128),
  NdValue(256),
  NdValue(400),
  NdValue(512),
  NdValue(1024),
  NdValue(2048),
  NdValue(4096),
  NdValue(6310),
  NdValue(8192),
  NdValue(10000),
];
