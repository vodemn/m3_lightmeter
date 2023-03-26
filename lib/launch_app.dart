import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/firebase_options.dart';

import 'application.dart';
import 'environment.dart';

Future<void> launchApp(Environment env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(Application(env));
}
