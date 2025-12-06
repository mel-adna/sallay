import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sallay/core/services/location_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGeolocatorPlatform extends GeolocatorPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<LocationPermission> checkPermission() async {
    return LocationPermission.whileInUse;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return LocationPermission.whileInUse;
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return true;
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    return Position(
      latitude: 33.5731,
      longitude: -7.5898,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  @override
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) async {
    return LocationAccuracyStatus.precise;
  }

  @override
  Future<Position?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) async {
    return null;
  }

  @override
  Future<bool> openAppSettings() async {
    return true;
  }

  @override
  Future<bool> openLocationSettings() async {
    return true;
  }

  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    throw UnimplementedError();
  }

  @override
  Stream<ServiceStatus> getServiceStatusStream() {
    throw UnimplementedError();
  }

  @override
  double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return 0.0;
  }

  @override
  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return 0.0;
  }

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() async {
    return LocationAccuracyStatus.precise;
  }
}

void main() {
  group('LocationService', () {
    late LocationService service;

    setUp(() {
      service = LocationService();
      GeolocatorPlatform.instance = MockGeolocatorPlatform();
    });

    test('returns position when permission is granted', () async {
      final position = await service.determinePosition();
      expect(position.latitude, 33.5731);
      expect(position.longitude, -7.5898);
    });
  });
}
