import 'package:flutter/material.dart';

import 'components/topbar/topbar.dart';

class MeteringScreen extends StatelessWidget {
  const MeteringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: const [
          MeteringTopBar(
            lux: 283,
            ev: 2.3,
            iso: 6400,
            nd: 0,
          ),
          Spacer()
        ],
      ),
    );
  }
}
