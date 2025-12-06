import 'dart:math' as math;
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:sallay/core/localization/locales.dart';
import 'package:sallay/core/services/location_service.dart';
import 'package:sallay/core/theme/app_colors.dart';

class QiblaScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  const QiblaScreen({super.key, this.latitude, this.longitude});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final LocationService _locationService = LocationService();
  double? _qiblaDirection;
  double? _heading;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initQibla();
    _initCompass();
  }

  Future<void> _initQibla() async {
    try {
      double lat, long;
      if (widget.latitude != null && widget.longitude != null) {
        lat = widget.latitude!;
        long = widget.longitude!;
      } else {
        final position = await _locationService.determinePosition();
        lat = position.latitude;
        long = position.longitude;
      }

      final coordinates = Coordinates(lat, long);
      final qibla = Qibla(coordinates);
      setState(() {
        _qiblaDirection = qibla.direction;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not determine location for Qibla.';
      });
    }
  }

  void _initCompass() {
    FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() {
          _heading = event.heading;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.qibla.getString(context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(child: _buildCompass()),
    );
  }

  Widget _buildCompass() {
    if (_error != null) {
      return Text(_error!, style: const TextStyle(color: AppColors.error));
    }

    if (_qiblaDirection == null || _heading == null) {
      return const CircularProgressIndicator();
    }

    // Calculate the angle to rotate the arrow
    // The arrow should point to Qibla.
    // If phone points North (0), arrow should point to Qibla (e.g. 100).
    // Rotation = Qibla - Heading
    final rotation = (_qiblaDirection! - _heading!) * (math.pi / 180);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Compass dial (static or rotating with heading)
            // For simplicity, let's rotate the arrow.
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  width: 2,
                ),
                gradient: RadialGradient(
                  colors: [
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            // Qibla Arrow
            Transform.rotate(
              angle: rotation,
              child: Icon(
                Icons.navigation,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          '${_qiblaDirection!.toStringAsFixed(1)}°',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AppLocale.qiblaDirection.getString(context),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
