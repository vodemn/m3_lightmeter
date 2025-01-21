import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:meta/meta.dart';

void main() {
  const defaultEquipmentProfile = EquipmentProfile(
    id: "",
    name: 'Default',
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  );

  group('Edge cases', () {
    List<ExposurePair> exposurePairsFull(double ev) => MeteringContainerBuidler.buildExposureValues(
          ev,
          StopType.full,
          defaultEquipmentProfile,
        );

    test('isNan', () {
      expect(exposurePairsFull(double.nan), const []);
    });

    test('isInifinity', () {
      expect(exposurePairsFull(double.infinity), const []);
    });

    test('Small number', () {
      final exposurePairs = exposurePairsFull(-5);
      expect(
        exposurePairs.first,
        const ExposurePair(
          ApertureValue(1.0, StopType.full),
          ShutterSpeedValue(32, false, StopType.full),
        ),
      );
      expect(
        exposurePairs.last,
        const ExposurePair(
          ApertureValue(45, StopType.full),
          ShutterSpeedValue(65536, false, StopType.full),
        ),
      );
    });

    test('Big number', () {
      expect(exposurePairsFull(24), const []);
    });
  });

  _testEvForStops(
    'Default equipment profile /',
    equipmentProfile: defaultEquipmentProfile,
    ev10: (
      first: const ExposurePair(
        ApertureValue(1, StopType.full),
        ShutterSpeedValue(2, true, StopType.full),
      ),
      last: const ExposurePair(
        ApertureValue(45, StopType.full),
        ShutterSpeedValue(1024, false, StopType.full),
      ),
    ),
    ev13: (
      first: const ExposurePair(
        ApertureValue(1, StopType.full),
        ShutterSpeedValue(2.5, true, StopType.third),
      ),
      last: const ExposurePair(
        ApertureValue(45, StopType.full),
        ShutterSpeedValue(813, false, StopType.third),
      ),
    ),
    ev15: (
      first: const ExposurePair(
        ApertureValue(1, StopType.full),
        ShutterSpeedValue(3, true, StopType.half),
      ),
      last: const ExposurePair(
        ApertureValue(45, StopType.full),
        ShutterSpeedValue(724, false, StopType.full),
      ),
    ),
    ev17: (
      first: const ExposurePair(
        ApertureValue(1, StopType.full),
        ShutterSpeedValue(3, true, StopType.third),
      ),
      last: const ExposurePair(
        ApertureValue(45, StopType.full),
        ShutterSpeedValue(645, false, StopType.third),
      ),
    ),
    ev20: (
      first: const ExposurePair(
        ApertureValue(1, StopType.full),
        ShutterSpeedValue(4, true, StopType.full),
      ),
      last: const ExposurePair(
        ApertureValue(45, StopType.full),
        ShutterSpeedValue(512, false, StopType.full),
      ),
    ),
  );

  _testEvForStops(
    'Shutter speed 1/1000-1/2" /',
    equipmentProfile: EquipmentProfile(
      id: "1",
      name: 'Test1',
      apertureValues: ApertureValue.values,
      ndValues: NdValue.values,
      shutterSpeedValues: ShutterSpeedValue.values.sublist(
        ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(1000, true, StopType.full)),
        ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(2, true, StopType.full)) + 1,
      ),
      isoValues: IsoValue.values,
    ),
    ev10: (
      first: const ExposurePair(
        ApertureValue(1.0, StopType.full),
        ShutterSpeedValue(2, true, StopType.full),
      ),
      last: const ExposurePair(
        ApertureValue(1.0, StopType.full),
        ShutterSpeedValue(2, true, StopType.full),
      ),
    ),
    ev13: (
      first: const ExposurePair(
        ApertureValue(1.0, StopType.full),
        ShutterSpeedValue(2.5, true, StopType.third),
      ),
      last: const ExposurePair(
        ApertureValue(1.1, StopType.third),
        ShutterSpeedValue(2, true, StopType.full),
      ),
    ),
    ev15: (
      first: const ExposurePair(
        ApertureValue(1.0, StopType.full),
        ShutterSpeedValue(3, true, StopType.half),
      ),
      last: const ExposurePair(
        ApertureValue(1.2, StopType.half),
        ShutterSpeedValue(2, true, StopType.full),
      ),
    ),
    ev17: (
      first: const ExposurePair(
        ApertureValue(1.0, StopType.full),
        ShutterSpeedValue(3, true, StopType.third),
      ),
      last: const ExposurePair(
        ApertureValue(1.2, StopType.third),
        ShutterSpeedValue(2, true, StopType.full),
      ),
    ),
    ev20: (
      first: const ExposurePair(
        ApertureValue(1.0, StopType.full),
        ShutterSpeedValue(4, true, StopType.full),
      ),
      last: const ExposurePair(
        ApertureValue(1.4, StopType.full),
        ShutterSpeedValue(2, true, StopType.full),
      ),
    ),
  );

  _testEvForStops(
    'Shutter speed 1/1000-B /',
    equipmentProfile: EquipmentProfile(
      id: "1",
      name: 'Test1',
      apertureValues: ApertureValue.values.sublist(4),
      ndValues: NdValue.values,
      shutterSpeedValues: [ShutterSpeedValue.values.last],
      isoValues: IsoValue.values,
    ),
    ev10: (
      first: const ExposurePair(
        ApertureValue(1.4, StopType.full),
        ShutterSpeedValue(1, false, StopType.full),
      ),
      last: const ExposurePair(
        ApertureValue(45, StopType.full),
        ShutterSpeedValue(17 * 60 + 4, false, StopType.full),
      ),
    ),
    ev13: (
      first: const ExposurePair(
        ApertureValue(1.6, StopType.third),
        ShutterSpeedValue(1, false, StopType.full),
      ),
      last: const ExposurePair(
        ApertureValue(45, StopType.full),
        ShutterSpeedValue(13 * 60 + 33, false, StopType.full),
      ),
    ),
    ev15: (
      first: const ExposurePair(
        ApertureValue(1.7, StopType.half),
        ShutterSpeedValue(1, false, StopType.full),
      ),
      last: const ExposurePair(
        ApertureValue(45, StopType.full),
        ShutterSpeedValue(12 * 60 + 4, false, StopType.full),
      ),
    ),
    ev17: (
      first: const ExposurePair(
        ApertureValue(1.8, StopType.third),
        ShutterSpeedValue(1, false, StopType.full),
      ),
      last: const ExposurePair(
        ApertureValue(45, StopType.full),
        ShutterSpeedValue(10 * 60 + 45, false, StopType.full),
      ),
    ),
    ev20: (
      first: const ExposurePair(
        ApertureValue(2.0, StopType.full),
        ShutterSpeedValue(1, false, StopType.full),
      ),
      last: const ExposurePair(
        ApertureValue(45, StopType.full),
        ShutterSpeedValue(8 * 60 + 32, false, StopType.full),
      ),
    ),
  );
}

@isTestGroup
void _testEvForStops(
  String description, {
  required EquipmentProfile equipmentProfile,
  required ({ExposurePair first, ExposurePair last}) ev10,
  required ({ExposurePair first, ExposurePair last}) ev13,
  required ({ExposurePair first, ExposurePair last}) ev15,
  required ({ExposurePair first, ExposurePair last}) ev17,
  required ({ExposurePair first, ExposurePair last}) ev20,
}) {
  group(description, () {
    group("StopType.full /", () {
      List<ExposurePair> exposurePairsFull(double ev) => MeteringContainerBuidler.buildExposureValues(
            ev,
            StopType.full,
            equipmentProfile,
          );

      test('EV 1.0', () {
        final exposurePairs = exposurePairsFull(1);
        expect(exposurePairs.first, ev10.first);
        expect(exposurePairs.last, ev10.last);
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(exposurePairs.first, ev10.first);
        expect(exposurePairs.last, ev10.last);
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(exposurePairs.first, ev20.first);
        expect(exposurePairs.last, ev20.last);
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(exposurePairs.first, ev20.first);
        expect(exposurePairs.last, ev20.last);
      });

      test('EV 2.0', () {
        final exposurePairs = exposurePairsFull(2);
        expect(exposurePairs.first, ev20.first);
        expect(exposurePairs.last, ev20.last);
      });
    });

    group("StopType.half /", () {
      List<ExposurePair> exposurePairsFull(double ev) => MeteringContainerBuidler.buildExposureValues(
            ev,
            StopType.half,
            equipmentProfile,
          );

      test('EV 1.0', () {
        final exposurePairs = exposurePairsFull(1);
        expect(exposurePairs.first, ev10.first);
        expect(exposurePairs.last, ev10.last);
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(exposurePairs.first, ev15.first);
        expect(exposurePairs.last, ev15.last);
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(exposurePairs.first, ev15.first);
        expect(exposurePairs.last, ev15.last);
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(exposurePairs.first, ev15.first);
        expect(exposurePairs.last, ev15.last);
      });

      test('EV 2.0', () {
        final exposurePairs = exposurePairsFull(2);
        expect(exposurePairs.first, ev20.first);
        expect(exposurePairs.last, ev20.last);
      });
    });

    group("StopType.third /", () {
      List<ExposurePair> exposurePairsFull(double ev) => MeteringContainerBuidler.buildExposureValues(
            ev,
            StopType.third,
            equipmentProfile,
          );

      test('EV 1.0', () {
        final exposurePairs = exposurePairsFull(1);
        expect(exposurePairs.first, ev10.first);
        expect(exposurePairs.last, ev10.last);
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(exposurePairs.first, ev13.first);
        expect(exposurePairs.last, ev13.last);
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(exposurePairs.first, ev17.first);
        expect(exposurePairs.last, ev17.last);
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(exposurePairs.first, ev17.first);
        expect(exposurePairs.last, ev17.last);
      });

      test('EV 2.0', () {
        final exposurePairs = exposurePairsFull(2);
        expect(exposurePairs.first, ev20.first);
        expect(exposurePairs.last, ev20.last);
      });
    });
  });
}
