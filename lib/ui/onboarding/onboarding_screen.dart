import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:sallay/core/localization/locales.dart';
import 'package:sallay/core/services/storage_service.dart';
import 'package:sallay/ui/location_setup/location_setup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPage(
                    title: AppLocale.welcomeTitle.getString(context),
                    description: AppLocale.welcomeDesc.getString(context),
                    icon: Icons.mosque,
                  ),
                  _buildPage(
                    title: AppLocale.stayOnTimeTitle.getString(context),
                    description: AppLocale.stayOnTimeDesc.getString(context),
                    icon: Icons.access_time,
                  ),
                  _buildPage(
                    title: AppLocale.privacyFirstTitle.getString(context),
                    description: AppLocale.privacyFirstDesc.getString(context),
                    icon: Icons.security,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage < 2)
                    ElevatedButton(
                      onPressed: () {
                        _pageController.jumpToPage(2);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface,
                      ),
                      child: Text(AppLocale.skip.getString(context)),
                    )
                  else
                    const SizedBox(width: 64),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  if (_currentPage < 2)
                    ElevatedButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(AppLocale.next.getString(context)),
                    )
                  else
                    ElevatedButton(
                      onPressed: () async {
                        final storageService = StorageService();
                        await storageService.saveSetting(
                          'onboarding_completed',
                          true,
                        );
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LocationSetupScreen(),
                            ),
                          );
                        }
                      },
                      child: Text(AppLocale.getStarted.getString(context)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 32),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
