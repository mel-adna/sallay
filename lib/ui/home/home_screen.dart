import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geocoding/geocoding.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:sallay/core/localization/locales.dart';
import 'package:sallay/core/services/location_service.dart';
import 'package:sallay/core/services/notification_service.dart';
import 'package:sallay/core/services/prayer_time_service.dart';
import 'package:sallay/core/services/storage_service.dart';
import 'package:sallay/data/models/prayer_log.dart';
import 'package:sallay/ui/qibla/qibla_screen.dart';
import 'package:sallay/ui/settings/settings_screen.dart';
import 'package:sallay/ui/stats/stats_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? initialLocation;

  const HomeScreen({super.key, this.initialLocation});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService _locationService = LocationService();
  final PrayerTimeService _prayerTimeService = PrayerTimeService();
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();

  PrayerTimes? _prayerTimes;
  bool _isLoading = true;
  String? _errorMessage;
  String? _locationName;

  // Track status of each prayer for the current day
  final Map<String, bool> _prayerStatus = {
    'Fajr': false,
    'Dhuhr': false,
    'Asr': false,
    'Maghrib': false,
    'Isha': false,
  };

  @override
  void initState() {
    super.initState();

    // Synchronous load if initial data is provided
    if (widget.initialLocation != null) {
      _loadInitialData(widget.initialLocation!);
    }

    _initData();
  }

  Future<void> _initData() async {
    await _notificationService.requestPermissions();
    _loadData();
  }

  void _loadInitialData(Map<String, dynamic> location) {
    final latitude = location['latitude'] as double;
    final longitude = location['longitude'] as double;
    final city = location['name'] as String;

    final methodIndex = _storageService.getSetting(
      'calculation_method',
      defaultValue: CalculationMethod.muslim_world_league.index,
    );
    final method = CalculationMethod.values[methodIndex];

    final prayerTimes = _prayerTimeService.getPrayerTimes(
      latitude: latitude,
      longitude: longitude,
      method: method,
    );

    _prayerTimes = prayerTimes;
    _locationName = city;
    _isLoading = false;

    // We don't need setState here because it's called in initState
    // But we should update widget data
    // _updateWidget(prayerTimes); // This is async, maybe skip for now or fire and forget
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    // If we already loaded initial data, we don't need to show loading
    if (_prayerTimes == null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      if (!mounted) return;
      final locale = Localizations.localeOf(context).languageCode;
      final manualLocation = _storageService.getManualLocation();
      double latitude;
      double longitude;
      String? city;

      if (manualLocation != null) {
        latitude = manualLocation['latitude'];
        longitude = manualLocation['longitude'];
        city = manualLocation['name'];
      } else {
        // Stale-While-Revalidate Strategy
        // If we have initial location and no manual location, we are already showing it.
        // We just need to trigger background refresh.

        final cachedLocation = _storageService.getCachedLocation();

        if (cachedLocation != null) {
          // If we didn't have initial location for some reason, use cache now
          if (_prayerTimes == null) {
            latitude = cachedLocation['latitude'];
            longitude = cachedLocation['longitude'];
            city = cachedLocation['name'];
          } else {
            // We already have data, just refresh background
            if (_prayerTimes != null) {
              await _scheduleNotifications(_prayerTimes!);
            }
            _refreshLocationInBackground(locale);
            return; // Exit, background refresh will handle updates
          }
        } else {
          // 3. No cache, must wait for fresh location
          try {
            final position = await _locationService.determinePosition();
            latitude = position.latitude;
            longitude = position.longitude;

            final placemarks = await _locationService.getPlacemarks(
              latitude,
              longitude,
              localeIdentifier: locale,
            );
            if (placemarks.isNotEmpty) {
              city = placemarks.first.locality ?? placemarks.first.country;
            }

            // Save to cache
            if (city != null) {
              await _storageService.saveCachedLocation(
                latitude,
                longitude,
                city,
              );
            }
          } catch (e) {
            rethrow;
          }
        }
      }

      // Get calculation method from settings
      final methodIndex = _storageService.getSetting(
        'calculation_method',
        defaultValue: CalculationMethod.muslim_world_league.index,
      );
      final method = CalculationMethod.values[methodIndex];

      final prayerTimes = _prayerTimeService.getPrayerTimes(
        latitude: latitude,
        longitude: longitude,
        method: method,
      );

      if (!mounted) return;

      final logs = _storageService.getPrayerLogs();
      final today = DateTime.now();

      for (var key in _prayerStatus.keys) {
        _prayerStatus[key] = false;
      }

      for (var log in logs) {
        if (log.timestamp.year == today.year &&
            log.timestamp.month == today.month &&
            log.timestamp.day == today.day &&
            log.status == 'done') {
          if (_prayerStatus.containsKey(log.prayerName)) {
            _prayerStatus[log.prayerName] = true;
          }
        }
      }

      await _scheduleNotifications(prayerTimes);

      if (!mounted) return;
      setState(() {
        _prayerTimes = prayerTimes;
        _locationName = city;
        _isLoading = false;
      });

      _updateWidget(prayerTimes);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateWidget(PrayerTimes prayerTimes) async {
    final nextPrayer = prayerTimes.nextPrayer();
    String nextPrayerName = '';
    DateTime? nextPrayerTime;

    switch (nextPrayer) {
      case Prayer.fajr:
        nextPrayerName = 'Fajr';
        nextPrayerTime = prayerTimes.fajr;
        break;
      case Prayer.dhuhr:
        nextPrayerName = 'Dhuhr';
        nextPrayerTime = prayerTimes.dhuhr;
        break;
      case Prayer.asr:
        nextPrayerName = 'Asr';
        nextPrayerTime = prayerTimes.asr;
        break;
      case Prayer.maghrib:
        nextPrayerName = 'Maghrib';
        nextPrayerTime = prayerTimes.maghrib;
        break;
      case Prayer.isha:
        nextPrayerName = 'Isha';
        nextPrayerTime = prayerTimes.isha;
        break;
      case Prayer.none:
        nextPrayerName = 'Fajr (Tomorrow)';
        nextPrayerTime = prayerTimes.fajr.add(const Duration(days: 1));
        break;
      default:
        nextPrayerName = 'Unknown';
    }

    if (nextPrayerTime != null) {
      final formattedTime = DateFormat.jm().format(nextPrayerTime);
      await HomeWidget.saveWidgetData<String>('prayer_name', nextPrayerName);
      await HomeWidget.saveWidgetData<String>('prayer_time', formattedTime);
      await HomeWidget.updateWidget(
        name: 'PrayerWidget',
        iOSName: 'PrayerWidget',
      );
    }
  }

  Future<void> _markAsPrayed(String prayerName) async {
    final isDone = _prayerStatus[prayerName] ?? false;
    final now = DateTime.now();

    if (isDone) {
      await _storageService.deletePrayerLog(prayerName, now);
      setState(() {
        _prayerStatus[prayerName] = false;
      });
    } else {
      final log = PrayerLog(
        prayerName: prayerName,
        timestamp: now,
        status: 'done',
      );
      await _storageService.savePrayerLog(log);
      setState(() {
        _prayerStatus[prayerName] = true;
      });
    }
  }

  Future<void> _refreshLocationInBackground(String locale) async {
    try {
      final position = await _locationService.determinePosition();
      final latitude = position.latitude;
      final longitude = position.longitude;

      final placemarks = await _locationService.getPlacemarks(
        latitude,
        longitude,
        localeIdentifier: locale,
      );

      String? city;
      if (placemarks.isNotEmpty) {
        city = placemarks.first.locality ?? placemarks.first.country;
      }

      if (city != null) {
        // Save new location to cache
        await _storageService.saveCachedLocation(latitude, longitude, city);

        if (!mounted) return;

        // Check if we need to update (simple check: name changed)
        if (city != _locationName) {
          // Re-run calculation with new coords
          final methodIndex = _storageService.getSetting(
            'calculation_method',
            defaultValue: CalculationMethod.muslim_world_league.index,
          );
          final method = CalculationMethod.values[methodIndex];

          final prayerTimes = _prayerTimeService.getPrayerTimes(
            latitude: latitude,
            longitude: longitude,
            method: method,
          );

          setState(() {
            _prayerTimes = prayerTimes;
            _locationName = city;
          });

          _updateWidget(prayerTimes);
        }
      }
    } catch (e) {
      // Silent failure for background refresh
      debugPrint('Background location refresh failed: $e');
    }
  }

  Future<void> _scheduleNotifications(PrayerTimes prayerTimes) async {
    if (!mounted) return;

    final notifications = <PrayerNotificationData>[];
    final prayerNames = {
      'Fajr': AppLocale.fajr.getString(context),
      'Dhuhr': AppLocale.dhuhr.getString(context),
      'Asr': AppLocale.asr.getString(context),
      'Maghrib': AppLocale.maghrib.getString(context),
      'Isha': AppLocale.isha.getString(context),
    };

    final times = {
      'Fajr': prayerTimes.fajr,
      'Dhuhr': prayerTimes.dhuhr,
      'Asr': prayerTimes.asr,
      'Maghrib': prayerTimes.maghrib,
      'Isha': prayerTimes.isha,
    };

    times.forEach((key, time) {
      final name = prayerNames[key]!;

      // Main Notification
      notifications.add(
        PrayerNotificationData(
          title: name,
          body: AppLocale.timeForPrayer
              .getString(context)
              .replaceFirst('%s', name),
          time: time,
        ),
      );

      // Pre-Alert
      final preAlertMinutes =
          _storageService.getSetting('pre_alert_minutes', defaultValue: 15)
              as int;

      if (preAlertMinutes > 0) {
        final preTime = time.subtract(Duration(minutes: preAlertMinutes));
        notifications.add(
          PrayerNotificationData(
            title: AppLocale.upcomingPrayer
                .getString(context)
                .replaceFirst('%s', name),
            body: AppLocale.prayerInMinutes
                .getString(context)
                .replaceFirst('%s', name)
                .replaceFirst('%s', '$preAlertMinutes'),
            time: preTime,
          ),
        );
      }
    });

    await _notificationService.schedulePrayerNotifications(
      notifications: notifications,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 16.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            child: IconButton(
              icon: Icon(
                Icons.bar_chart,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const StatsScreen()),
                );
              },
            ),
          ),
        ),
        centerTitle: true,
        title: _locationName != null
            ? InkWell(
                onTap: _showLocationDialog,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          _locationName!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              child: IconButton(
                icon: Icon(
                  Icons.explore,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QiblaScreen(
                        latitude: _prayerTimes?.coordinates.latitude,
                        longitude: _prayerTimes?.coordinates.longitude,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      )
                      .then((_) => _loadData());
                },
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_prayerTimes == null) return const SizedBox.shrink();

    // Determine Next Prayer
    final nextPrayer = _prayerTimes!.nextPrayer();
    String nextPrayerName = '';
    DateTime? nextPrayerTime;

    switch (nextPrayer) {
      case Prayer.fajr:
        nextPrayerName = AppLocale.fajr.getString(context);
        nextPrayerTime = _prayerTimes!.fajr;
        break;
      case Prayer.dhuhr:
        nextPrayerName = AppLocale.dhuhr.getString(context);
        nextPrayerTime = _prayerTimes!.dhuhr;
        break;
      case Prayer.asr:
        nextPrayerName = AppLocale.asr.getString(context);
        nextPrayerTime = _prayerTimes!.asr;
        break;
      case Prayer.maghrib:
        nextPrayerName = AppLocale.maghrib.getString(context);
        nextPrayerTime = _prayerTimes!.maghrib;
        break;
      case Prayer.isha:
        nextPrayerName = AppLocale.isha.getString(context);
        nextPrayerTime = _prayerTimes!.isha;
        break;
      case Prayer.none:
        nextPrayerName = AppLocale.fajrTomorrow.getString(context);
        nextPrayerTime = _prayerTimes!.fajr.add(const Duration(days: 1));
        break;
      default:
        nextPrayerName = AppLocale.unknown.getString(context);
    }

    final prayers = [
      {
        'name': 'Fajr',
        'displayName': AppLocale.fajr.getString(context),
        'time': _prayerTimes!.fajr,
      },
      {
        'name': 'Dhuhr',
        'displayName': AppLocale.dhuhr.getString(context),
        'time': _prayerTimes!.dhuhr,
      },
      {
        'name': 'Asr',
        'displayName': AppLocale.asr.getString(context),
        'time': _prayerTimes!.asr,
      },
      {
        'name': 'Maghrib',
        'displayName': AppLocale.maghrib.getString(context),
        'time': _prayerTimes!.maghrib,
      },
      {
        'name': 'Isha',
        'displayName': AppLocale.isha.getString(context),
        'time': _prayerTimes!.isha,
      },
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero Section
            Text(
              nextPrayer == Prayer.none
                  ? AppLocale.allDone.getString(context)
                  : AppLocale.nextPrayer.getString(context),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              nextPrayerName,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 42,
              ),
            ),
            if (nextPrayerTime != null) ...[
              const SizedBox(height: 8),
              Text(
                DateFormat.jm().format(nextPrayerTime),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],

            const SizedBox(height: 48), // Spacing between Hero and Pills
            // Prayer List (Pills)
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate width: (total width - spacing) / 2
                // We have 24 horizontal padding on parent, so constraints.maxWidth is the available width.
                // Spacing is 12.
                final pillWidth = (constraints.maxWidth - 12) / 2;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: prayers.map((prayer) {
                    final name = prayer['name'] as String;
                    final displayName = prayer['displayName'] as String;
                    final isDone = _prayerStatus[name] ?? false;
                    final isNext = displayName == nextPrayerName;

                    return _buildPrayerPill(
                      name,
                      displayName,
                      isDone,
                      isNext,
                      pillWidth,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            AppLocale.setLocation.getString(context),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: AppLocale.enterCityName.getString(context),
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _storageService.clearManualLocation();
                if (context.mounted) {
                  Navigator.pop(context);
                  _loadData();
                }
              },
              child: Text(AppLocale.useGps.getString(context)),
            ),
            TextButton(
              onPressed: () async {
                final query = controller.text;
                if (query.isNotEmpty) {
                  try {
                    final locations = await locationFromAddress(query);
                    if (locations.isNotEmpty) {
                      final loc = locations.first;
                      await _storageService.saveManualLocation(
                        loc.latitude,
                        loc.longitude,
                        query,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        _loadData();
                      }
                    }
                  } catch (e) {
                    // Handle error
                  }
                }
              },
              child: Text(AppLocale.save.getString(context)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrayerPill(
    String keyName,
    String displayName,
    bool isDone,
    bool isNext,
    double width,
  ) {
    return InkWell(
      onTap: () => _markAsPrayed(keyName),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDone
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: isNext
              ? Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.5),
                  width: 1,
                )
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDone ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: isDone
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              displayName,
              style: TextStyle(
                color: isDone
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    final isLocationError =
        _errorMessage?.contains('Location services are disabled') ?? false;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              isLocationError
                  ? AppLocale.locationDisabled.getString(context)
                  : AppLocale.error.getString(context),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isLocationError
                  ? AppLocale.locationDisabledDesc.getString(context)
                  : _errorMessage ?? AppLocale.unknown.getString(context),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (isLocationError) ...[
              ElevatedButton.icon(
                onPressed: () async {
                  await _locationService.openLocationSettings();
                  // Wait a bit for user to enable it, then retry
                  // Or just let them come back and click retry.
                  // Better: Just open settings. The user will have to click retry manually or we can try to auto-reload on resume (complex).
                  // For now, let's just open settings and reload.
                  if (context.mounted) {
                    _loadData();
                  }
                },
                icon: const Icon(Icons.settings),
                label: Text(AppLocale.openSettings.getString(context)),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _showLocationDialog,
                icon: const Icon(Icons.edit_location),
                label: Text(AppLocale.setLocation.getString(context)),
              ),
              const SizedBox(height: 12),
            ],
            OutlinedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocale.retry.getString(context)),
            ),
          ],
        ),
      ),
    );
  }
}
