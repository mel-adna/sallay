import 'package:hive/hive.dart';

part 'prayer_log.g.dart';

@HiveType(typeId: 0)
class PrayerLog extends HiveObject {
  @HiveField(0)
  final String prayerName;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final String status; // 'done', 'missed'

  PrayerLog({
    required this.prayerName,
    required this.timestamp,
    required this.status,
  });
}
