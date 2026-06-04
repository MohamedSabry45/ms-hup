class BrandModel {
  final int id;
  final String name;
  final String? image;
  final String? logo;
  final int features;

  BrandModel({
    required this.id,
    required this.name,
    this.image,
    this.logo,
    this.features = 0,
  });

  String? get bestLogoUrl {
    final vLogo = (logo ?? '').trim();
    if (vLogo.isNotEmpty) return vLogo;
    final vImage = (image ?? '').trim();
    if (vImage.isNotEmpty) return vImage;
    return null;
  }

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    final featuresValue = json['features'];
    int features = 0;
    if (featuresValue is int) {
      features = featuresValue;
    } else if (featuresValue is bool) {
      features = featuresValue ? 1 : 0;
    }
    return BrandModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String?,
      logo: json['logo'] as String?,
      features: features,
    );
  }
}
