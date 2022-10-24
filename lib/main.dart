import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'res/theme.dart';
import 'screens/metering/metering_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      home: const MeteringScreen(),
    );
  }
}
