import 'package:flutter/material.dart';
import 'package:lightmeter/screens/metering/components/topbar/components/reading_container.dart';

import 'components/topbar/topbar.dart';

class MeteringScreen extends StatelessWidget {
  const MeteringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          MeteringTopBar(
            lux: 283,
            ev: 2.3,
            iso: 6400,
            nd: 0,
          ),
          const Spacer()
        ],
      ),
    );
  }
}
