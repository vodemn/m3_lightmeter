import 'package:flutter/material.dart';
import 'package:lightmeter/environment.dart';

import 'application.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Application(Environment.dev()));
}
