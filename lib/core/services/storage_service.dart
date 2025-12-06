import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sallay/data/models/prayer_log.dart';
import 'package:share_plus/share_plus.dart';

class StorageService {
  static const String prayerLogBoxName = 'prayer_logs';
  static const String settingsBoxName = 'settings';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PrayerLogAdapter());
    await Hive.openBox<PrayerLog>(prayerLogBoxName);
    await Hive.openBox(settingsBoxName);
  }

  Future<void> savePrayerLog(PrayerLog log) async {
    final box = Hive.box<PrayerLog>(prayerLogBoxName);
    await box.add(log);
  }

  List<PrayerLog> getPrayerLogs() {
    final box = Hive.box<PrayerLog>(prayerLogBoxName);
    return box.values.toList();
  }

  Future<void> deletePrayerLog(String prayerName, DateTime date) async {
    final box = Hive.box<PrayerLog>(prayerLogBoxName);
    final Map<dynamic, PrayerLog> map = box.toMap();
    dynamic keyToDelete;

    for (var entry in map.entries) {
      final log = entry.value;
      if (log.prayerName == prayerName &&
          log.timestamp.year == date.year &&
          log.timestamp.month == date.month &&
          log.timestamp.day == date.day) {
        keyToDelete = entry.key;
        break;
      }
    }

    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }

  Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(settingsBoxName);
    await box.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(settingsBoxName);
    return box.get(key, defaultValue: defaultValue);
  }

  Future<void> saveManualLocation(double lat, double long, String name) async {
    final box = Hive.box(settingsBoxName);
    await box.put('manual_lat', lat);
    await box.put('manual_long', long);
    await box.put('manual_name', name);
  }

  Map<String, dynamic>? getManualLocation() {
    final box = Hive.box(settingsBoxName);
    final lat = box.get('manual_lat');
    final long = box.get('manual_long');
    final name = box.get('manual_name');

    if (lat != null && long != null && name != null) {
      return {'latitude': lat, 'longitude': long, 'name': name};
    }
    return null;
  }

  Future<void> clearManualLocation() async {
    final box = Hive.box(settingsBoxName);
    await box.delete('manual_lat');
    await box.delete('manual_long');
    await box.delete('manual_name');
  }

  Future<void> saveCachedLocation(double lat, double long, String name) async {
    final box = Hive.box(settingsBoxName);
    await box.put('cached_lat', lat);
    await box.put('cached_long', long);
    await box.put('cached_name', name);
  }

  Map<String, dynamic>? getCachedLocation() {
    final box = Hive.box(settingsBoxName);
    final lat = box.get('cached_lat');
    final long = box.get('cached_long');
    final name = box.get('cached_name');

    if (lat != null && long != null && name != null) {
      return {'latitude': lat, 'longitude': long, 'name': name};
    }
    return null;
  }

  Future<void> clearCachedLocation() async {
    final box = Hive.box(settingsBoxName);
    await box.delete('cached_lat');
    await box.delete('cached_long');
    await box.delete('cached_name');
  }

  Future<void> exportData() async {
    final logsBox = Hive.box<PrayerLog>(prayerLogBoxName);
    final settingsBox = Hive.box(settingsBoxName);

    final logs = logsBox.values.map((log) {
      return {
        'prayerName': log.prayerName,
        'timestamp': log.timestamp.toIso8601String(),
        'status': log.status,
      };
    }).toList();

    final settings = settingsBox.toMap().map((key, value) {
      return MapEntry(key.toString(), value);
    });

    final data = {'logs': logs, 'settings': settings, 'version': 1};

    final jsonString = jsonEncode(data);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/sallay_backup.json');
    await file.writeAsString(jsonString);

    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], text: 'Sallay Backup');
  }

  Future<bool> importData() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString);

        if (data is Map<String, dynamic>) {
          final logsBox = Hive.box<PrayerLog>(prayerLogBoxName);
          final settingsBox = Hive.box(settingsBoxName);

          // Clear existing data
          await logsBox.clear();
          await settingsBox.clear();

          // Restore Settings
          if (data['settings'] != null) {
            final settings = data['settings'] as Map<String, dynamic>;
            for (var entry in settings.entries) {
              await settingsBox.put(entry.key, entry.value);
            }
          }

          // Restore Logs
          if (data['logs'] != null) {
            final logs = data['logs'] as List;
            for (var item in logs) {
              final log = PrayerLog(
                prayerName: item['prayerName'],
                timestamp: DateTime.parse(item['timestamp']),
                status: item['status'],
              );
              await logsBox.add(log);
            }
          }
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error importing data: $e');
    }
    return false;
  }

  Future<void> clearAllData() async {
    final logsBox = Hive.box<PrayerLog>(prayerLogBoxName);
    final settingsBox = Hive.box(settingsBoxName);
    await logsBox.clear();
    await settingsBox.clear();
  }
}
