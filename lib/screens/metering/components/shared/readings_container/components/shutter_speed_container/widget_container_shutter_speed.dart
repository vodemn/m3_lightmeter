import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class ShutterSpeedContainer extends StatelessWidget {
  final ShutterSpeedValue? shutterSpeedValue;

  const ShutterSpeedContainer({
    required this.shutterSpeedValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ReadingValueContainer.singleValue(
      value: ReadingValue(
        label: S.of(context).shutterSpeed,
        value: _shutterSpeed(context),
      ),
    );
  }

  String _shutterSpeed(BuildContext context) {
    if (shutterSpeedValue case final shutterSpeedValue?) {
      return Films.selectedOf(context).reciprocityFailure(shutterSpeedValue).toString();
    } else {
      return '-';
    }
  }
}
