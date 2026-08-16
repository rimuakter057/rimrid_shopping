class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String buttonText;
  final String categoryFilter;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.buttonText,
    required this.categoryFilter,
  });
}
