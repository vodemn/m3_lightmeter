import 'dart:async';

import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/screens/metering/utils/notifier_volume_keys.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../function_mock.dart';

class _MockVolumeEventsService extends Mock implements VolumeEventsService {}

void main() {
  late _MockVolumeEventsService mockVolumeEventsService;

  setUp(() {
    mockVolumeEventsService = _MockVolumeEventsService();
  });

  test(
    'Listen to `volumeButtonsEventStream()`',
    () async {
      final StreamController<int> volumeButtonsEvents = StreamController<int>();
      when(() => mockVolumeEventsService.volumeButtonsEventStream()).thenAnswer((_) => volumeButtonsEvents.stream);

      final volumeKeysNotifier = VolumeKeysNotifier(mockVolumeEventsService);
      final functions = MockValueChanged<VolumeKey>();
      volumeKeysNotifier.addListener(() => functions.onChanged(volumeKeysNotifier.value));
      expect(volumeKeysNotifier.value, VolumeKey.up);

      volumeButtonsEvents.add(25);
      volumeButtonsEvents.add(25);
      volumeButtonsEvents.add(25);
      volumeButtonsEvents.add(24);
      volumeButtonsEvents.add(24);
      volumeButtonsEvents.add(25);
      await Future.delayed(Duration.zero);
      verify(() => functions.onChanged(VolumeKey.up)).called(2);
      verify(() => functions.onChanged(VolumeKey.down)).called(4);

      volumeKeysNotifier.removeListener(() => functions.onChanged(volumeKeysNotifier.value));
      await volumeKeysNotifier.dispose();
      await volumeButtonsEvents.close();
    },
  );
}
