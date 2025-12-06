import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sallay/core/localization/locales.dart';
import 'package:sallay/core/services/location_service.dart';
import 'package:sallay/core/services/storage_service.dart';
import 'package:sallay/ui/home/home_screen.dart';

class LocationSetupScreen extends StatefulWidget {
  const LocationSetupScreen({super.key});

  @override
  State<LocationSetupScreen> createState() => _LocationSetupScreenState();
}

class _LocationSetupScreenState extends State<LocationSetupScreen> {
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();

  bool _isDetecting = false;
  String? _errorMessage;

  Future<void> _useGPS() async {
    setState(() {
      _isDetecting = true;
      _errorMessage = null;
    });

    try {
      // Capture context before async operations
      if (!mounted) return;
      final locale = Localizations.localeOf(context).languageCode;

      final position = await _locationService.determinePosition();

      // Get city name
      final placemarks = await _locationService.getPlacemarks(
        position.latitude,
        position.longitude,
        localeIdentifier: locale,
      );

      String? cityName;
      if (placemarks.isNotEmpty) {
        cityName = placemarks.first.locality ?? placemarks.first.country;
      }

      // Save location
      await _storageService.saveManualLocation(
        position.latitude,
        position.longitude,
        cityName ?? 'Unknown',
      );

      await _storageService.saveSetting('location_configured', true);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDetecting = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _enterManually() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocale.setLocation.getString(context)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: AppLocale.enterCityName.getString(context),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocale.cancel.getString(context)),
            ),
            TextButton(
              onPressed: () async {
                final query = controller.text.trim();
                if (query.isEmpty) return;

                try {
                  final locations = await locationFromAddress(query);
                  if (locations.isNotEmpty) {
                    final loc = locations.first;
                    await _storageService.saveManualLocation(
                      loc.latitude,
                      loc.longitude,
                      query,
                    );
                    await _storageService.saveSetting(
                      'location_configured',
                      true,
                    );

                    if (context.mounted) {
                      Navigator.pop(context); // Close dialog
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    setState(() {
                      _errorMessage =
                          'Could not find location. Please try again.';
                    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Icon(
                Icons.location_on,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                AppLocale.locationSetupTitle.getString(context),
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocale.locationSetupDesc.getString(context),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!.contains('Location services')
                              ? AppLocale.locationDisabledDesc.getString(
                                  context,
                                )
                              : _errorMessage!,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_errorMessage!.contains('Location services')) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await _locationService.openLocationSettings();
                    },
                    icon: const Icon(Icons.settings),
                    label: Text(AppLocale.openSettings.getString(context)),
                  ),
                ],
              ],
              const SizedBox(height: 48),
              if (_isDetecting)
                Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      AppLocale.detectingLocation.getString(context),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _useGPS,
                        icon: const Icon(Icons.gps_fixed),
                        label: Text(AppLocale.useGpsButton.getString(context)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _enterManually,
                        icon: const Icon(Icons.edit_location),
                        label: Text(
                          AppLocale.enterManuallyButton.getString(context),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
