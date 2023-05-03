import 'package:flutter/material.dart';
import 'package:lightmeter/environment.dart';

import 'application.dart';
import 'firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  runApp(const Application(Environment.prod()));
}
