import 'package:flutter/material.dart';

import 'application.dart';
import 'environment.dart';

void launchApp(Environment env) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Application(env));
}
