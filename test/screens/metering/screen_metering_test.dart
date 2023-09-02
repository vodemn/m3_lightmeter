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

    test('Big ass number', () {
      expect(exposurePairsFull(23), const []);
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

  group('Shutter speed 1/1000-1/2"', () {
    final equipmentProfile = EquipmentProfile(
      id: "1",
      name: 'Test1',
      apertureValues: ApertureValue.values,
      ndValues: NdValue.values,
      shutterSpeedValues: ShutterSpeedValue.values.sublist(
        ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(1000, true, StopType.full)),
        ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(2, true, StopType.full)) + 1,
      ),
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
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(4, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(4, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 2', () {
        final exposurePairs = exposurePairsFull(2);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(4, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
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
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(3, true, StopType.half),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.2, StopType.half),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(3, true, StopType.half),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.2, StopType.half),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(3, true, StopType.half),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.2, StopType.half),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 2', () {
        final exposurePairs = exposurePairsFull(2);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(4, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
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
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 1.3', () {
        final exposurePairs = exposurePairsFull(1.3);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(2.5, true, StopType.third),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.1, StopType.third),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(3, true, StopType.third),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.2, StopType.third),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(3, true, StopType.third),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.2, StopType.third),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });

      test('EV 2', () {
        final exposurePairs = exposurePairsFull(2);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(1.0, StopType.full),
            ShutterSpeedValue(4, true, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(1.4, StopType.full),
            ShutterSpeedValue(2, true, StopType.full),
          ),
        );
      });
    });
  });

  group('Shutter speed 2"-16"', () {
    final equipmentProfile = EquipmentProfile(
      id: "1",
      name: 'Test1',
      apertureValues: ApertureValue.values.sublist(4),
      ndValues: NdValue.values,
      shutterSpeedValues: ShutterSpeedValue.values.sublist(
        ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(2, false, StopType.full)),
      ),
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
            ApertureValue(2.0, StopType.full),
            ShutterSpeedValue(2, false, StopType.full),
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
            ApertureValue(2.0, StopType.full),
            ShutterSpeedValue(2, false, StopType.full),
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
            ApertureValue(2.8, StopType.full),
            ShutterSpeedValue(2, false, StopType.full),
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
            ApertureValue(2.8, StopType.full),
            ShutterSpeedValue(2, false, StopType.full),
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
            ApertureValue(2.8, StopType.full),
            ShutterSpeedValue(2, false, StopType.full),
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
            equipmentProfile,
            const Film.other(),
          );

      test('EV 1', () {
        final exposurePairs = exposurePairsFull(1);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(2.0, StopType.full),
            ShutterSpeedValue(2, false, StopType.full),
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
            ApertureValue(2.4, StopType.half),
            ShutterSpeedValue(2, false, StopType.full),
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
            ApertureValue(2.4, StopType.half),
            ShutterSpeedValue(2, false, StopType.full),
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
            ApertureValue(2.4, StopType.half),
            ShutterSpeedValue(2, false, StopType.full),
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
            ApertureValue(2.8, StopType.full),
            ShutterSpeedValue(2, false, StopType.full),
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
            equipmentProfile,
            const Film.other(),
          );

      test('EV 1', () {
        final exposurePairs = exposurePairsFull(1);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(2.0, StopType.full),
            ShutterSpeedValue(2, false, StopType.full),
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
            ApertureValue(2.2, StopType.full),
            ShutterSpeedValue(2, false, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(6.3, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 1.5', () {
        final exposurePairs = exposurePairsFull(1.5);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(2.4, StopType.full),
            ShutterSpeedValue(2, false, StopType.full),
          ),
        );
        expect(
          exposurePairs.last,
          const ExposurePair(
            ApertureValue(7.1, StopType.full),
            ShutterSpeedValue(16, false, StopType.full),
          ),
        );
      });

      test('EV 1.7', () {
        final exposurePairs = exposurePairsFull(1.7);
        expect(
          exposurePairs.first,
          const ExposurePair(
            ApertureValue(2.4, StopType.full),
            ShutterSpeedValue(2, false, StopType.third),
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
            ApertureValue(2.8, StopType.full),
            ShutterSpeedValue(2, false, StopType.full),
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
}
