import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/screens/shared/release_notes_dialog/bloc_release_notes.dart';
import 'package:lightmeter/screens/shared/release_notes_dialog/state_release_notes.dart';
import 'package:lightmeter/screens/shared/release_notes_dialog/widget_dialog_release_notes.dart';
import 'package:lightmeter/utils/platform_utils.dart';

class ReleaseNotesFlow extends StatelessWidget {
  final Widget child;

  const ReleaseNotesFlow({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReleaseNotesBloc(
        ServicesProvider.of(context).userPreferencesService,
        const PlatformUtils(),
      ),
      child: BlocListener<ReleaseNotesBloc, ReleaseNotesState>(
        listener: (context, state) {
          if (state is ShowReleaseNotesDialogState) {
            final bloc = context.read<ReleaseNotesBloc>();
            showDialog(
              context: context,
              builder: (_) => ReleaseNotesDialog(version: state.version),
            ).then((_) => bloc.setChangelogVersion());
          }
        },
        child: child,
      ),
    );
  }
}
