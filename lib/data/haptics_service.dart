import 'package:vibration/vibration.dart';

class HapticsService {
  const HapticsService();

  Future<void> quickVibration() async => _tryVibrate(duration: 25, amplitude: 96);

  Future<void> responseVibration() async => _tryVibrate(duration: 50, amplitude: 128);

  Future<void> errorVibration() async => _tryVibrate(duration: 100, amplitude: 128);

  Future<void> _tryVibrate({required int duration, required int amplitude}) async {
    if (await _canVibrate()) {
      await Vibration.vibrate(
        duration: duration,
        amplitude: amplitude,
      );
    }
  }

  Future<bool> _canVibrate() async => await Vibration.hasVibrator() ?? false;
}
