import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/photography_value.dart';
import 'res/theme.dart';
import 'screens/metering/metering_bloc.dart';
import 'screens/metering/metering_screen.dart';
import 'utils/stop_type_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StopTypeProvider(
      child: BlocProvider(
        create: (context) => MeteringBloc(context.read<StopType>()),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
          ),
          home: const MeteringScreen(),
        ),
      ),
    );
  }
}
