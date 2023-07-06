import 'package:flutter/material.dart';
import 'package:lightmeter/application.dart';
import 'package:lightmeter/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Application(Environment.dev()));
}
