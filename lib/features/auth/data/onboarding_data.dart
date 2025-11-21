class OnboardingData {
  final String title;
  final String description;
  final String imagePath;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

List<OnboardingData> onboardingDataList = [
  OnboardingData(
    title: 'Welcome to Game Vault',
    description: 'Discover and purchase game accounts securely.',
    imagePath: 'assets/images/onboarding1.png',
  ),
  OnboardingData(
    title: 'Browse Game Accounts',
    description:
        'Explore a wide variety of game accounts available for purchase.',
    imagePath: 'assets/images/onboarding2.png',
  ),
  OnboardingData(
    title: 'Secure Transactions',
    description:
        'Enjoy safe and secure transactions with our trusted platform.',
    imagePath: 'assets/images/onboarding3.png',
  ),
];
