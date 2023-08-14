import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';

/// Listening to multiple dependencies at the same time causes firing an event for all dependencies
/// even though some of them didn't change:
/// ```dart
/// @override
/// void didChangeDependencies() {
///   super.didChangeDependencies();
///   _bloc.add(EquipmentProfileChangedEvent(EquipmentProfile.of(context)));
///   if (!MeteringScreenLayout.featureStatusOf(context, MeteringScreenLayoutFeature.filmPicker)) {
///     _bloc.add(const FilmChangedEvent(Film.other()));
///   }
/// }
/// ```
/// To overcome this issue I've decided to create a generic listener,
/// that will listen to each dependency separately.
class MeteringScreenLayoutFeatureListener extends StatefulWidget {
  final MeteringScreenLayoutFeature feature;
  final ValueChanged<bool> onDidChangeDependencies;
  final Widget child;

  const MeteringScreenLayoutFeatureListener({
    required this.feature,
    required this.onDidChangeDependencies,
    required this.child,
    super.key,
  });

  @override
  State<MeteringScreenLayoutFeatureListener> createState() =>
      _MeteringScreenLayoutFeatureListenerState();
}

class _MeteringScreenLayoutFeatureListenerState extends State<MeteringScreenLayoutFeatureListener> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onDidChangeDependencies(
      UserPreferencesProvider.meteringScreenFeatureOf(
        context,
        widget.feature,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
