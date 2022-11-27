import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/settings_screen.dart';

import 'bloc_permissions_check.dart';
import 'state_permissions_check.dart';

class PermissionsCheckScreen extends StatelessWidget {
  const PermissionsCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.paddingM * 2),
          child: Center(
            child: BlocConsumer<PermissionsCheckBloc, PermissionsCheckState>(
              listener: (context, state) {
                if (state is PermissionsGrantedState) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SettingsScreen()));
                }
              },
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: Dimens.durationS,
                  child: state is LoadingState
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              S.of(context).permissionNeeded,
                              style: Theme.of(context).textTheme.headlineLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Dimens.grid16),
                            Text(
                              S.of(context).permissionNeededMessage,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Dimens.grid24),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              ),
                              onPressed: () {},
                              child: Text(S.of(context).openSettings),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
