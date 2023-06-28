import 'package:lightmeter/data/models/film.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:test/test.dart';

void main() {
  test('iso', () {
    expect(const Film.other().iso, 0);
    expect(const FomapanFilm.creative100().iso, 100);
    expect(const FomapanFilm.creative200().iso, 200);
    expect(const FomapanFilm.action400().iso, 400);
    expect(const IlfordFilm.ortho().iso, 80);
    expect(const IlfordFilm.delta100().iso, 100);
    expect(const IlfordFilm.delta400().iso, 400);
    expect(const IlfordFilm.delta3200().iso, 3200);
    expect(const IlfordFilm.fp4().iso, 125);
    expect(const IlfordFilm.hp5().iso, 400);
    expect(const IlfordFilm.panf().iso, 50);
    expect(const IlfordFilm.sfx200().iso, 200);
    expect(const IlfordFilm.xp2super().iso, 400);
    expect(const IlfordFilm.pan100().iso, 100);
    expect(const IlfordFilm.pan400().iso, 400);
    expect(const KodakFilm.tmax100().iso, 100);
    expect(const KodakFilm.tmax400().iso, 400);
    expect(const KodakFilm.tmax3200().iso, 3200);
    expect(const KodakFilm.trix320().iso, 320);
    expect(const KodakFilm.trix400().iso, 400);
  });

  test('toString()', () {
    expect(const Film.other().toString(), "");
    expect(const FomapanFilm.creative100().toString(), "Fomapan CREATIVE 100");
    expect(const FomapanFilm.creative200().toString(), "Fomapan CREATIVE 200");
    expect(const FomapanFilm.action400().toString(), "Fomapan ACTION 400");
    expect(const IlfordFilm.ortho().toString(), "Ilford ORTHO+");
    expect(const IlfordFilm.delta100().toString(), "Ilford DELTA 100");
    expect(const IlfordFilm.delta400().toString(), "Ilford DELTA 400");
    expect(const IlfordFilm.delta3200().toString(), "Ilford DELTA 3200");
    expect(const IlfordFilm.fp4().toString(), "Ilford FP4+");
    expect(const IlfordFilm.hp5().toString(), "Ilford HP5+");
    expect(const IlfordFilm.panf().toString(), "Ilford Pan F+");
    expect(const IlfordFilm.sfx200().toString(), "Ilford SFX 200");
    expect(const IlfordFilm.xp2super().toString(), "Ilford XP2 SUPER");
    expect(const IlfordFilm.pan100().toString(), "Kentemere 100");
    expect(const IlfordFilm.pan400().toString(), "Kentemere 400");
    expect(const KodakFilm.tmax100().toString(), "Kodak T-MAX 100");
    expect(const KodakFilm.tmax400().toString(), "Kodak T-MAX 400");
    expect(const KodakFilm.tmax3200().toString(), "Kodak T-MAX 3200");
    expect(const KodakFilm.trix320().toString(), "Kodak TRI-X 320");
    expect(const KodakFilm.trix400().toString(), "Kodak TRI-X 400");
  });

  group(
    'reciprocityFailure',
    () {
      const inputSpeeds = [
        ShutterSpeedValue(1000, true, StopType.full),
        ShutterSpeedValue(1, false, StopType.full),
        ShutterSpeedValue(16, false, StopType.full)
      ];
      test('No change `Film.other()`', () {
        expect(
          const Film.other().reciprocityFailure(inputSpeeds[0]),
          const ShutterSpeedValue(1000, true, StopType.full),
        );
        expect(
          const Film.other().reciprocityFailure(inputSpeeds[1]),
          const ShutterSpeedValue(1, false, StopType.full),
        );
        expect(
          const Film.other().reciprocityFailure(inputSpeeds[2]),
          const ShutterSpeedValue(16, false, StopType.full),
        );
      });

      test('pow `IlfordFilm.delta100()`', () {
        expect(
          const IlfordFilm.delta100().reciprocityFailure(inputSpeeds[0]),
          const ShutterSpeedValue(1000, true, StopType.full),
        );
        expect(
          const IlfordFilm.delta100().reciprocityFailure(inputSpeeds[1]),
          const ShutterSpeedValue(1, false, StopType.full),
        );
        expect(
          const IlfordFilm.delta100().reciprocityFailure(inputSpeeds[2]),
          const ShutterSpeedValue(32.899642452994128, false, StopType.full),
        );
      });

      test('log10polynomian `FomapanFilm.creative100()`', () {
        expect(
          const FomapanFilm.creative100().reciprocityFailure(inputSpeeds[0]),
          const ShutterSpeedValue(1000, true, StopType.full),
        );
        expect(
          const FomapanFilm.creative100().reciprocityFailure(inputSpeeds[1]),
          const ShutterSpeedValue(2, false, StopType.full),
        );
        expect(
          const FomapanFilm.creative100().reciprocityFailure(inputSpeeds[2]),
          const ShutterSpeedValue(151.52807753457483, false, StopType.full),
        );
      });

      test('log10polynomian `Kodak.tmax400()`', () {
        expect(
          const KodakFilm.tmax400().reciprocityFailure(inputSpeeds[0]),
          const ShutterSpeedValue(1000, true, StopType.full),
        );
        expect(
          const KodakFilm.tmax400().reciprocityFailure(inputSpeeds[1]),
          const ShutterSpeedValue(1.3333333333333333, false, StopType.full),
        );
        expect(
          const KodakFilm.tmax400().reciprocityFailure(inputSpeeds[2]),
          const ShutterSpeedValue(27.166026086819844, false, StopType.full),
        );
      });
    },
  );
}
