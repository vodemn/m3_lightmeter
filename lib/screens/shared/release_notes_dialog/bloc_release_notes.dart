import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/screens/shared/release_notes_dialog/state_release_notes.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ReleaseNotesBloc extends Cubit<ReleaseNotesState> {
  final UserPreferencesService _userPreferencesService;

  ReleaseNotesBloc(this._userPreferencesService) : super(const HiddenReleaseNotesDialogState()) {
    _showDialogIfNeeded();
  }

  Future<void> _showDialogIfNeeded() async {
    PackageInfo.fromPlatform().then((value) {
      if (value.version != _userPreferencesService.seenChangelogVersion) {
        emit(ShowReleaseNotesDialogState(value.version));
      }
    });
  }

  void setChangelogVersion() {
    _userPreferencesService.seenChangelogVersion = (state as ShowReleaseNotesDialogState).version;
  }
}
