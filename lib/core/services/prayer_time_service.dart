import 'package:adhan/adhan.dart';

class PrayerTimeService {
  PrayerTimes getPrayerTimes({
    required double latitude,
    required double longitude,
    CalculationMethod method = CalculationMethod.muslim_world_league,
    DateTime? date,
  }) {
    final myCoordinates = Coordinates(latitude, longitude);
    final params = method.getParameters();
    params.madhab = Madhab.shafi;

    final dateComponents = DateComponents.from(date ?? DateTime.now());

    return PrayerTimes(myCoordinates, dateComponents, params);
  }

  PrayerTimes getPrayerTimesForDate({
    required double latitude,
    required double longitude,
    required DateTime date,
    CalculationMethod method = CalculationMethod.muslim_world_league,
  }) {
    return getPrayerTimes(
      latitude: latitude,
      longitude: longitude,
      method: method,
      date: date,
    );
  }
}
