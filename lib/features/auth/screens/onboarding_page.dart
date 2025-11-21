import 'package:flutter/material.dart';
import 'package:game_vault_seller/core/theme/app_colors.dart';
import 'package:game_vault_seller/features/auth/data/onboarding_data.dart';
import 'package:game_vault_seller/features/auth/screens/auth_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  Future<void> onBoardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _goToAuthScreen,
                child: Text(
                  'Skip',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Color(AppColors.textPrimary),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingDataList.length,
                onPageChanged: (index) {
                  if (index == onboardingDataList.length) {
                    _goToAuthScreen();
                    return;
                  }
                },
                itemBuilder: (context, index) {
                  final data = onboardingDataList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(data.image, height: 300),÷
                        const SizedBox(height: 32),
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Color(AppColors.textPrimary),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Color(AppColors.border)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(AppColors.primary),
                borderRadius: BorderRadius.all(Radius.circular(99)),
              ),
              child: IconButton(
                onPressed: () {
                  if (_pageController.page == onboardingDataList.length - 1) {
                    _goToAuthScreen();
                    return;
                  }
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Icon(Icons.arrow_forward, size: 32, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _goToAuthScreen() async {
    await onBoardingComplete();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }
}
