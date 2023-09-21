import 'package:flutter/material.dart';
import 'package:lightmeter/application.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase(handleErrors: false);
  runApp(const Application(Environment.prod()));
}
