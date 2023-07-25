import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lightmeter/application.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeFirebase();
  } catch (e) {
    log(e.toString());
  }
  runApp(const Application(Environment.prod()));
}
