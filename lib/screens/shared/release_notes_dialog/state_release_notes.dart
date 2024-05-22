import 'package:flutter/material.dart';

@immutable
sealed class ReleaseNotesState {
  const ReleaseNotesState();
}

class HiddenReleaseNotesDialogState extends ReleaseNotesState {
  const HiddenReleaseNotesDialogState();
}

class ShowReleaseNotesDialogState extends ReleaseNotesState {
  final String version;

  const ShowReleaseNotesDialogState(this.version);
}
