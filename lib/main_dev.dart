import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lightmeter/application.dart';
import 'package:lightmeter/application_wrapper.dart';
import 'package:lightmeter/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ApplicationWrapper(Environment.dev(), child: Application()));
}
