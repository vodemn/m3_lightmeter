import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

double log10(double x) => log(x) / log(10);

double log10polynomian(
  double x,
  double a,
  double b,
  double c,
) =>
    a * pow(log10(x), 2) + b * log10(x) + c;

/// Only Ilford films have reciprocity formulas provided by the manufacturer:
/// https://www.ilfordphoto.com/wp/wp-content/uploads/2017/06/Reciprocity-Failure-Compensation.pdf
///
/// Reciprocity formulas for Fomapan films and Kodak films are from here:
/// https://www.flickr.com/groups/86738082@N00/discuss/72157626050157470/
///
/// Cinema films like Kodak 5222/7222 Double-X and respective CineStill films (cause they are basically a modification of Kodak)
/// do not have any reciprocity failure information, as these films are ment to be used in cinema
/// with appropriate light and pretty short shutter speeds.
///
/// Because of this: https://github.com/dart-lang/sdk/issues/38934#issuecomment-803938315
/// `super` calls are ignored in test coverage
class Film {
  final String name;
  final int iso;

  const Film(this.name, this.iso);

  const Film.other()
      : name = '',
        iso = 0;

  @override
  String toString() => name;

  ShutterSpeedValue reciprocityFailure(ShutterSpeedValue shutterSpeed) {
    if (shutterSpeed.isFraction) {
      return shutterSpeed;
    } else {
      return ShutterSpeedValue(
        reciprocityFormula(shutterSpeed.rawValue),
        shutterSpeed.isFraction,
        shutterSpeed.stopType,
      );
    }
  }

  @protected
  double reciprocityFormula(double t) => t;

  static const List<Film> values = [
    Film.other(),
    FomapanFilm.creative100(),
    FomapanFilm.creative200(),
    FomapanFilm.action400(),
    IlfordFilm.ortho(),
    IlfordFilm.delta100(),
    IlfordFilm.delta400(),
    IlfordFilm.delta3200(),
    IlfordFilm.fp4(),
    IlfordFilm.hp5(),
    IlfordFilm.panf(),
    IlfordFilm.sfx200(),
    IlfordFilm.xp2super(),
    IlfordFilm.pan100(),
    IlfordFilm.pan400(),
    KodakFilm.tmax100(),
    KodakFilm.tmax400(),
    KodakFilm.tmax3200(),
    KodakFilm.trix320(),
    KodakFilm.trix400(),
  ];
}

/// https://www.tate.org.uk/documents/598/page_6_7_agfa_stocks_0.pdf
/// https://www.filmwasters.com/forum/index.php?topic=5298.0
// {{1,1.87},{2,3.73},{3,8.06},{4,13.93},{5,21.28},{6,23.00},{7,30.12},{8,38.05},{9,44.75},{10,50.12},{20,117},{30,202},{40,293},{50,413},{60,547},{70,694},{80,853},{90,1022},{100,1202}};
// class AgfaFilm extends Film {
//   final double a;
//   final double b;
//   final double c;

//   const AgfaFilm.apx100()
//       : a = 1,
//         b = 5,
//         c = 2,
//         super('Agfa APX 100', 100); // coverage:ignore-line

//   const AgfaFilm.apx400()
//       : a = 1.5,
//         b = 4.5,
//         c = 3,
//         super('Agfa APX 400', 400); // coverage:ignore-line

//   @override
//   double reciprocityFormula(double t) => t * log10polynomian(t, a, b, c);
// }

class FomapanFilm extends Film {
  final double a;
  final double b;
  final double c;

  /// https://www.foma.cz/en/fomapan-100
  const FomapanFilm.creative100()
      : a = 1,
        b = 5,
        c = 2,
        super('Fomapan CREATIVE 100', 100); // coverage:ignore-line

  /// https://www.foma.cz/en/fomapan-200
  const FomapanFilm.creative200()
      : a = 1.5,
        b = 4.5,
        c = 3,
        super('Fomapan CREATIVE 200', 200); // coverage:ignore-line

  /// https://www.foma.cz/en/fomapan-100
  const FomapanFilm.action400()
      : a = -1.25, // coverage:ignore-line
        b = 5.75,
        c = 1.5,
        super('Fomapan ACTION 400', 400); // coverage:ignore-line

  @override
  double reciprocityFormula(double t) => t * log10polynomian(t, a, b, c);
}

class IlfordFilm extends Film {
  final double reciprocityPower;

  /// https://www.ilfordphoto.com/amfile/file/download/file/1948/product/1650/
  const IlfordFilm.ortho()
      : reciprocityPower = 1.25,
        super('Ilford ORTHO+', 80); // coverage:ignore-line

  /// https://www.ilfordphoto.com/amfile/file/download/file/1919/product/686/
  const IlfordFilm.fp4()
      : reciprocityPower = 1.26,
        super('Ilford FP4+', 125); // coverage:ignore-line

  /// https://www.ilfordphoto.com/amfile/file/download/file/1903/product/691/
  const IlfordFilm.hp5()
      : reciprocityPower = 1.31,
        super('Ilford HP5+', 400); // coverage:ignore-line

  /// https://www.ilfordphoto.com/amfile/file/download/file/3/product/679/
  const IlfordFilm.delta100()
      : reciprocityPower = 1.26,
        super('Ilford DELTA 100', 100); // coverage:ignore-line

  /// https://www.ilfordphoto.com/amfile/file/download/file/1915/product/684/
  const IlfordFilm.delta400()
      : reciprocityPower = 1.41,
        super('Ilford DELTA 400', 400); // coverage:ignore-line

  /// https://www.ilfordphoto.com/amfile/file/download/file/1913/product/682/
  const IlfordFilm.delta3200()
      : reciprocityPower = 1.33,
        super('Ilford DELTA 3200', 3200); // coverage:ignore-line

  /// https://www.ilfordphoto.com/amfile/file/download/file/1905/product/699/
  const IlfordFilm.panf()
      : reciprocityPower = 1.33,
        super('Ilford Pan F+', 50); // coverage:ignore-line

  /// https://www.ilfordphoto.com/amfile/file/download/file/1907/product/701/
  const IlfordFilm.sfx200()
      : reciprocityPower = 1.31,
        super('Ilford SFX 200', 200); // coverage:ignore-line

  /// https://www.ilfordphoto.com/amfile/file/download/file/1909/product/703/
  const IlfordFilm.xp2super()
      : reciprocityPower = 1.31,
        super('Ilford XP2 SUPER', 400); // coverage:ignore-line

  /// https://www.ilfordphoto.com/amfile/file/download/file/1958/product/696/
  const IlfordFilm.pan100()
      : reciprocityPower = 1.26,
        super('Kentemere 100', 100); // coverage:ignore-line

  /// https://www.ilfordphoto.com/amfile/file/download/file/1959/product/697/
  const IlfordFilm.pan400()
      : reciprocityPower = 1.30,
        super('Kentemere 400', 400); // coverage:ignore-line

  @override
  double reciprocityFormula(double t) => pow(t, reciprocityPower).toDouble();
}

class KodakFilm extends Film {
  final double a;
  final double b;
  final double c;

  const KodakFilm.tmax100()
      : a = 1 / 6, // coverage:ignore-line
        b = 0, // coverage:ignore-line
        c = 4 / 3, // coverage:ignore-line
        super('Kodak T-MAX 100', 100); // coverage:ignore-line

  const KodakFilm.tmax400()
      : a = 2 / 3, // coverage:ignore-line
        b = -1 / 2, // coverage:ignore-line
        c = 4 / 3, // coverage:ignore-line
        super('Kodak T-MAX 400', 400); // coverage:ignore-line

  const KodakFilm.tmax3200()
      : a = 7 / 6, // coverage:ignore-line
        b = -1, // coverage:ignore-line
        c = 4 / 3, // coverage:ignore-line
        super('Kodak T-MAX 3200', 3200); // coverage:ignore-line

  const KodakFilm.trix320()
      : a = 2,
        b = 1,
        c = 2,
        super('Kodak TRI-X 320', 320); // coverage:ignore-line

  const KodakFilm.trix400()
      : a = 2,
        b = 1,
        c = 2,
        super('Kodak TRI-X 400', 400); // coverage:ignore-line

  @override
  double reciprocityFormula(double t) => t * log10polynomian(t, a, b, c);
}
