class Landmark {
  final String title;
  final String category;
  final double latitude;
  final double longitude;
  final String? photo;
  final double? distance;

  const Landmark({
    required this.title,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.photo,
    this.distance,
  });

  double get distanceKm => distance ?? 1721.7;
}
