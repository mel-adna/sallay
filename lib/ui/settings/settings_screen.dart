import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:sallay/core/localization/locales.dart';
import 'package:sallay/core/services/notification_service.dart';
import 'package:sallay/core/services/storage_service.dart';
import 'package:sallay/main.dart';
import 'package:sallay/ui/onboarding/onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();

  // Settings State
  CalculationMethod _calculationMethod = CalculationMethod.muslim_world_league;
  bool _notificationsEnabled = true;
  int _preAlertMinutes = 15;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final methodIndex = _storageService.getSetting(
      'calculation_method',
      defaultValue: CalculationMethod.muslim_world_league.index,
    );
    final notifications = _storageService.getSetting(
      'notifications_enabled',
      defaultValue: true,
    );
    final preAlert = _storageService.getSetting(
      'pre_alert_minutes',
      defaultValue: 15,
    );

    _calculationMethod = CalculationMethod.values[methodIndex];
    _notificationsEnabled = notifications;
    _preAlertMinutes = preAlert;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocale.settings.getString(context))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, AppLocale.general.getString(context)),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.language,
            title: AppLocale.language.getString(context),
            subtitle: _getCurrentLanguageName(),
            onTap: _showLanguageDialog,
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.dark_mode,
            title: AppLocale.darkMode.getString(context),
            isSwitch: true,
            switchValue: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              final mode = value ? ThemeMode.dark : ThemeMode.light;
              MyApp.themeNotifier.value = mode;
              _storageService.saveSetting('is_dark_mode', value);
            },
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.calculate,
            title: AppLocale.calculationMethod.getString(context),
            subtitle: _getCalculationMethodName(_calculationMethod),
            onTap: _showCalculationMethodDialog,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            context,
            AppLocale.notifications.getString(context),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.notifications,
            title: AppLocale.enableNotifications.getString(context),
            isSwitch: true,
            switchValue: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          if (_notificationsEnabled) ...[
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.timer,
              title: AppLocale.preAlert.getString(context),
              subtitle:
                  '$_preAlertMinutes ${AppLocale.minutes.getString(context)} ${AppLocale.preAlert.getString(context)}',
              onTap: _showPreAlertDialog,
            ),
          ],
          const SizedBox(height: 24),
          _buildSectionHeader(
            context,
            AppLocale.dataPrivacy.getString(context),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.backup,
            title: AppLocale.backupData.getString(context),
            subtitle: AppLocale.syncToCloud.getString(context),
            onTap: _showBackupDialog,
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.delete_forever,
            iconColor: Colors.red,
            title: AppLocale.resetData.getString(context),
            titleColor: Colors.red,
            onTap: _showResetConfirmationDialog,
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.privacy_tip,
            title: AppLocale.privacyPolicy.getString(context),
            onTap: _showPrivacyPolicyDialog,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getCurrentLanguageName() {
    switch (_localization.currentLocale?.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
      default:
        return 'English';
    }
  }

  String _getCalculationMethodName(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.muslim_world_league:
        return AppLocale.mwl.getString(context);
      case CalculationMethod.egyptian:
        return AppLocale.egyptian.getString(context);
      case CalculationMethod.karachi:
        return AppLocale.karachi.getString(context);
      case CalculationMethod.umm_al_qura:
        return AppLocale.ummAlQura.getString(context);
      case CalculationMethod.dubai:
        return AppLocale.dubai.getString(context);
      case CalculationMethod.qatar:
        return AppLocale.qatar.getString(context);
      case CalculationMethod.kuwait:
        return AppLocale.kuwait.getString(context);
      case CalculationMethod.singapore:
        return AppLocale.singapore.getString(context);
      case CalculationMethod.turkey:
        return AppLocale.turkey.getString(context);
      case CalculationMethod.tehran:
        return AppLocale.tehran.getString(context);
      case CalculationMethod.north_america:
        return AppLocale.northAmerica.getString(context);
      default:
        return AppLocale.other.getString(context);
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).cardTheme.color,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocale.language.getString(context),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                _buildLanguageOption('en', 'English', '🇺🇸'),
                const SizedBox(height: 10),
                _buildLanguageOption('ar', 'العربية', '🇸🇦'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String code, String name, String flag) {
    final isSelected = _localization.currentLocale?.languageCode == code;
    return InkWell(
      onTap: () {
        _localization.translate(code);
        _storageService.saveSetting('language_code', code);
        Navigator.pop(context);
        setState(() {});
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  void _showCalculationMethodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).cardTheme.color,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocale.calculationMethod.getString(context),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildMethodOption(
                          CalculationMethod.muslim_world_league,
                        ),
                        const SizedBox(height: 10),
                        _buildMethodOption(CalculationMethod.egyptian),
                        const SizedBox(height: 10),
                        _buildMethodOption(CalculationMethod.karachi),
                        const SizedBox(height: 10),
                        _buildMethodOption(CalculationMethod.umm_al_qura),
                        const SizedBox(height: 10),
                        _buildMethodOption(CalculationMethod.north_america),
                        const SizedBox(height: 10),
                        _buildMethodOption(CalculationMethod.dubai),
                        const SizedBox(height: 10),
                        _buildMethodOption(CalculationMethod.qatar),
                        const SizedBox(height: 10),
                        _buildMethodOption(CalculationMethod.kuwait),
                        const SizedBox(height: 10),
                        _buildMethodOption(CalculationMethod.singapore),
                        const SizedBox(height: 10),
                        _buildMethodOption(CalculationMethod.turkey),
                        const SizedBox(height: 10),
                        _buildMethodOption(CalculationMethod.tehran),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMethodOption(CalculationMethod method) {
    final isSelected = _calculationMethod == method;
    return InkWell(
      onTap: () {
        setState(() {
          _calculationMethod = method;
        });
        _storageService.saveSetting('calculation_method', method.index);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _getCalculationMethodName(method),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  void _toggleNotifications(bool value) async {
    if (value) {
      await _notificationService.requestPermissions();
    } else {
      await _notificationService.cancelAllNotifications();
    }

    setState(() {
      _notificationsEnabled = value;
    });
    _storageService.saveSetting('notifications_enabled', value);
  }

  void _showPreAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).cardTheme.color,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocale.preAlert.getString(context),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                ...[0, 5, 10, 15, 30].map((minutes) {
                  return _buildPreAlertOption(minutes);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreAlertOption(int minutes) {
    final isSelected = _preAlertMinutes == minutes;
    return InkWell(
      onTap: () {
        setState(() {
          _preAlertMinutes = minutes;
        });
        _storageService.saveSetting('pre_alert_minutes', minutes);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
        ),
        child: Row(
          children: [
            Text(
              '$minutes ${AppLocale.minutes.getString(context)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).cardTheme.color,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocale.backupData.getString(context),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.upload),
                  title: Text(AppLocale.exportData.getString(context)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _storageService.exportData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocale.dataExported.getString(context),
                          ),
                        ),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: Text(AppLocale.importData.getString(context)),
                  onTap: () async {
                    Navigator.pop(context);
                    final success = await _storageService.importData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? AppLocale.dataImported.getString(context)
                                : AppLocale.error.getString(context),
                          ),
                          backgroundColor: success
                              ? Colors.green
                              : Theme.of(context).colorScheme.error,
                        ),
                      );
                      if (success) {
                        // Reload settings
                        _loadSettings();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocale.resetData.getString(context)),
          content: Text(AppLocale.resetDataConfirm.getString(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocale.cancel.getString(context)),
            ),
            TextButton(
              onPressed: () async {
                await _storageService.clearAllData();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const OnboardingScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(AppLocale.resetData.getString(context)),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocale.privacyPolicy.getString(context),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocale.privacyPolicyContent.getString(context),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocale.close.getString(context)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onChanged;
  final Color? iconColor;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isSwitch = false,
    this.switchValue = false,
    this.onChanged,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSwitch ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (iconColor ?? Theme.of(context).colorScheme.primary)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: titleColor,
                            ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSwitch)
                  Switch(
                    value: switchValue,
                    onChanged: onChanged,
                    activeThumbColor: Theme.of(context).colorScheme.primary,
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Theme.of(context).disabledColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
