import 'package:flutter_test/flutter_test.dart';
import 'package:adhan/adhan.dart';
import 'package:sallay/core/services/prayer_time_service.dart';

void main() {
  group('PrayerTimeService', () {
    final service = PrayerTimeService();

    test('calculates prayer times for a specific location', () {
      // Casablanca coordinates
      final latitude = 33.5731;
      final longitude = -7.5898;
      final date = DateTime(2023, 1, 1);

      final prayerTimes = service.getPrayerTimes(
        latitude: latitude,
        longitude: longitude,
        date: date,
        method: CalculationMethod.muslim_world_league,
      );

      expect(prayerTimes.fajr, isNotNull);
      expect(prayerTimes.dhuhr, isNotNull);
      expect(prayerTimes.asr, isNotNull);
      expect(prayerTimes.maghrib, isNotNull);
      expect(prayerTimes.isha, isNotNull);
    });
  });
}
