class Landmark {
  final String id;
  final String title;
  final String category;
  final double latitude;
  final double longitude;
  final String? photo;
  final String? localAsset;
  final double? distance;
  final String? phone;
  final String? address;

  const Landmark({
    this.id = '',
    required this.title,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.photo,
    this.localAsset,
    this.distance,
    this.phone,
    this.address,
  });

  double get distanceKm => distance ?? 1721.7;

  bool get hasLocation =>
      (latitude != 0.0 && longitude != 0.0) ||
      (address != null &&
          address!.trim().isNotEmpty &&
          address!.trim().toLowerCase() != 'null');

  bool get hasPhone =>
      phone != null &&
      phone!.trim().isNotEmpty &&
      phone!.trim().toLowerCase() != 'null';

  factory Landmark.fromMap(Map<String, dynamic> map, [String? id]) {
    double parseD(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    final photoVal = map['photo']?.toString().trim();
    final docId = id ?? map['docId']?.toString() ?? '';
    final localAssetVal = map['localAsset']?.toString().trim();
    final phoneVal = map['phone']?.toString().trim() ??
        map['phoneNumber']?.toString().trim() ??
        map['contact']?.toString().trim();
    final addressVal =
        map['address']?.toString().trim() ?? map['location']?.toString().trim();

    return Landmark(
      id: docId,
      title: map['title']?.toString().trim() ?? 'Landmark',
      category: map['category']?.toString().trim() ?? 'Landmark',
      latitude: parseD(map['latitude']),
      longitude: parseD(map['longitude']),
      photo: (photoVal != null &&
              photoVal.isNotEmpty &&
              photoVal.toLowerCase() != 'null')
          ? photoVal
          : null,
      localAsset: localAssetVal != null && localAssetVal.isNotEmpty
          ? localAssetVal
          : (docId.isNotEmpty ? 'assets/images/landmarks/$docId.jpg' : null),
      distance: map['distance'] != null ? parseD(map['distance']) : null,
      phone: (phoneVal != null &&
              phoneVal.isNotEmpty &&
              phoneVal.toLowerCase() != 'null')
          ? phoneVal
          : null,
      address: (addressVal != null &&
              addressVal.isNotEmpty &&
              addressVal.toLowerCase() != 'null')
          ? addressVal
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docId': id,
      'title': title,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'photo': photo,
      'localAsset': localAsset,
      'distance': distance,
      'phone': phone,
      'address': address,
    };
  }
}
