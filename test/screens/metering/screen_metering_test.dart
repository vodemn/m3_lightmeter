import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

void main() {
  const defaultEquipmentProfile = EquipmentProfile(
    id: "",
    name: 'Default',
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  );

  group('Empty list', () {
    List<ExposurePair> exposurePairsFull(double ev) => MeteringContainerBuidler.buildExposureValues(
          ev,
          StopType.full,
          defaultEquipmentProfile,
          const Film.other(),
        );

    test('isNan', () {
      expect(exposurePairsFull(double.nan), const []);
    });

    test('isInifinity', () {
      expect(exposurePairsFull(double.infinity), const []);
    });
  });

  group('Default equipment profile', () {
    group("StopType.full", () {
      List<ExposurePair> exposurePairsFull(double ev) =>
          MeteringContainerBuidler.buildExposureValues(
            ev,
            StopType.full,
            defaultEquipmentProfile,
            const Film.other(),
          );

      test('EV 1', () {
        final exposurePairs = exposurePairsFull(1);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(5.6, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(5.6, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(4, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(8, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(4, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(8, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 2', () {
        final exposurePairs = exposurePairsFull(2);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(4, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(8, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });
    });

    group("StopType.half", () {
      List<ExposurePair> exposurePairsFull(double ev) =>
          MeteringContainerBuidler.buildExposureValues(
            ev,
            StopType.half,
            defaultEquipmentProfile,
            const Film.other(),
          );

      test('EV 1', () {
        final exposurePairs = exposurePairsFull(1);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(5.6, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(3, true, StopType.half),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(6.7, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(3, true, StopType.half),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(6.7, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(3, true, StopType.half),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(6.7, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 2', () {
        final exposurePairs = exposurePairsFull(2);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(4, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(8, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });
    });

    group("StopType.third", () {
      List<ExposurePair> exposurePairsFull(double ev) =>
          MeteringContainerBuidler.buildExposureValues(
            ev,
            StopType.third,
            defaultEquipmentProfile,
            const Film.other(),
          );

      test('EV 1', () {
        final exposurePairs = exposurePairsFull(1);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(5.6, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(2.5, true, StopType.third),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(6.3, StopType.third),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(3, true, StopType.third),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(7.1, StopType.third),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(3, true, StopType.third),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(7.1, StopType.third),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 2', () {
        final exposurePairs = exposurePairsFull(2);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1, StopType.full),
            ShutterSpeedValue(4, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(8, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });
    });
  });

  group('Reduced equipment profile', () {
    final equipmentProfile = EquipmentProfile(
      id: "1",
      name: 'Test1',
      apertureValues: ApertureValue.values.sublist(4),
      ndValues: NdValue.values,
      shutterSpeedValues: ShutterSpeedValue.values.sublist(0, ShutterSpeedValue.values.length - 4),
      isoValues: IsoValue.values,
    );

    group("StopType.full", () {
      List<ExposurePair> exposurePairsFull(double ev) =>
          MeteringContainerBuidler.buildExposureValues(
            ev,
            StopType.full,
            equipmentProfile,
            const Film.other(),
          );

      test('EV 1', () {
        final exposurePairs = exposurePairsFull(1);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(1, false, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(4, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(1, false, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(4, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(5.6, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(5.6, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 2', () {
        final exposurePairs = exposurePairsFull(2);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(5.6, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });
    });

    group("StopType.half", () {
      List<ExposurePair> exposurePairsFull(double ev) =>
          MeteringContainerBuidler.buildExposureValues(
            ev,
            StopType.half,
            equipmentProfile,
            const Film.other(),
          );

      test('EV 1', () {
        final exposurePairs = exposurePairsFull(1);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(1, false, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(4.0, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(1.5, true, StopType.half),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(4.8, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(1.5, true, StopType.half),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(4.8, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(1.5, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(4.8, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 2', () {
        final exposurePairs = exposurePairsFull(2);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(5.6, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });
    });

    group("StopType.third", () {
      List<ExposurePair> exposurePairsFull(double ev) =>
          MeteringContainerBuidler.buildExposureValues(
            ev,
            StopType.third,
            equipmentProfile,
            const Film.other(),
          );

      test('EV 1', () {
        final exposurePairs = exposurePairsFull(1);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(1, false, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(4, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(1.3, true, StopType.third),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(4.5, StopType.third),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(1.6, true, StopType.third),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(5.0, StopType.third),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(1.6, true, StopType.third),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(5.0, StopType.third),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });

      test('EV 2', () {
        final exposurePairs = exposurePairsFull(2);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(5.6, StopType.full),
            ShutterSpeedValue(8, false, StopType.full),
          ),
        );
      });
    });
  });
}
