import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:sallay/core/localization/locales.dart';
import 'package:sallay/core/services/storage_service.dart';
import 'package:sallay/core/theme/app_theme.dart';
import 'package:sallay/ui/home/home_screen.dart';
import 'package:sallay/ui/location_setup/location_setup_screen.dart';
import 'package:sallay/ui/onboarding/onboarding_screen.dart';

import 'package:sallay/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  final storageService = StorageService();
  await storageService.init();
  final notificationService = NotificationService();
  await notificationService.init();

  // Preload initial data
  final onboardingComplete =
      storageService.getSetting('onboarding_completed') ?? false;
  final locationConfigured =
      storageService.getSetting('location_configured') ?? false;
  final cachedLocation = storageService.getCachedLocation();

  runApp(
    MyApp(
      onboardingComplete: onboardingComplete,
      locationConfigured: locationConfigured,
      cachedLocation: cachedLocation,
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool onboardingComplete;
  final bool locationConfigured;
  final Map<String, dynamic>? cachedLocation;

  const MyApp({
    super.key,
    required this.onboardingComplete,
    required this.locationConfigured,
    this.cachedLocation,
  });

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.system,
  );

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    final storageService = StorageService();
    final savedLanguage = storageService.getSetting('language_code');
    String initLang = 'en';

    if (savedLanguage != null) {
      initLang = savedLanguage;
    } else {
      // Auto-detect system language
      final systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
      if (systemLocales.isNotEmpty) {
        final systemLang = systemLocales.first.languageCode;
        if (systemLang == 'ar') {
          initLang = 'ar';
        }
      }
    }

    // Load theme preference
    final isDarkMode = storageService.getSetting('is_dark_mode');
    if (isDarkMode != null) {
      MyApp.themeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }

    _localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.en),
        const MapLocale('ar', AppLocale.ar),
      ],
      initLanguageCode: initLang,
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;

    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'Sallay',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          locale: _localization.currentLocale,
          home: _getHomeWidget(),
          debugShowCheckedModeBanner: false,
          supportedLocales: _localization.supportedLocales,
          localizationsDelegates: [
            ..._localization.localizationsDelegates,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }

  Widget _getHomeWidget() {
    if (!widget.onboardingComplete) {
      return const OnboardingScreen();
    } else if (!widget.locationConfigured) {
      return const LocationSetupScreen();
    } else {
      return HomeScreen(initialLocation: widget.cachedLocation);
    }
  }
}
