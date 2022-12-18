import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';

import 'application.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Application(EvSourceType.mock));
}