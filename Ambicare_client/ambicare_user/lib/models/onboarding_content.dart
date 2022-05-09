class UnboardingContent {
  String image;
  String title;
  String description;

  UnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    image: 'images/onBoarding1.png',
    title: 'Need an Ambulance',
    description: 'Ambicare is always there on your service',
  ),
  UnboardingContent(
    image: 'images/onBoarding2.png',
    title: 'Stand by',
    description:
        'Wait for an ambulance at the point you have marked, an ambulance will be there in few minutes',
  ),
  UnboardingContent(
    image: 'images/onBoarding3.png',
    title: 'Assurance',
    description: 'Ambicare is available 24/7 on your service',
  ),
];
