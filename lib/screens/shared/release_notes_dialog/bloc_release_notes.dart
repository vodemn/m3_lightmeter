import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/screens/shared/release_notes_dialog/state_release_notes.dart';
import 'package:lightmeter/utils/platform_utils.dart';

class ReleaseNotesBloc extends Cubit<ReleaseNotesState> {
  final UserPreferencesService _userPreferencesService;
  final PlatformUtils _platformUtils;

  ReleaseNotesBloc(
    this._userPreferencesService,
    this._platformUtils,
  ) : super(const HiddenReleaseNotesDialogState()) {
    _showDialogIfNeeded();
  }

  Future<void> _showDialogIfNeeded() async {
    _platformUtils.version.then((version) {
      if (version != _userPreferencesService.seenChangelogVersion) {
        emit(ShowReleaseNotesDialogState(version));
      }
    });
  }

  void setChangelogVersion() {
    _userPreferencesService.seenChangelogVersion = (state as ShowReleaseNotesDialogState).version;
  }
}
