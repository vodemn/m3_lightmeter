import 'package:geolocator/geolocator.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class GeolocationService {
  const GeolocationService();

  /// Gets the current position and returns Coordinates if successful
  /// Returns null if location services are disabled or permission is denied
  Future<Coordinates?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      final isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        return null;
      }

      // Check location permission
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestedPermission = await Geolocator.requestPermission();
        if (requestedPermission == LocationPermission.denied ||
            requestedPermission == LocationPermission.deniedForever) {
          return null;
        }
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          timeLimit: Duration(seconds: 10),
        ),
      );

      return Coordinates(position.latitude, position.longitude);
    } catch (e) {
      // Return null if any error occurs (timeout, no GPS signal, etc.)
      return null;
    }
  }

  /// Checks if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Checks current location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Requests location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }
}
