class Stall {
  final String id;
  final int order;
  final String stallName;
  final String owner;
  final String phone;
  final String category;
  final String location;
  final double latitude;
  final double longitude;

  const Stall({
    this.id = '',
    this.order = 0,
    required this.stallName,
    required this.owner,
    required this.phone,
    this.category = 'Main',
    this.location = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  bool get hasPhone =>
      phone.trim().isNotEmpty && phone.trim().toLowerCase() != 'null';

  bool get hasLocation =>
      (location.trim().isNotEmpty && location.trim().toLowerCase() != 'null') ||
      (latitude != 0.0 && longitude != 0.0);

  factory Stall.fromMap(Map<String, dynamic> map, [String? docId]) {
    final rawOrder = map['order'];
    int orderInt = 0;
    if (rawOrder is int) {
      orderInt = rawOrder;
    } else if (rawOrder is num) {
      orderInt = rawOrder.toInt();
    } else if (rawOrder is String) {
      orderInt = int.tryParse(rawOrder) ?? 0;
    }

    double parseD(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return Stall(
      id: docId ?? map['docId']?.toString() ?? map['id']?.toString() ?? '',
      order: orderInt,
      stallName: map['stallName']?.toString() ?? map['title']?.toString() ?? '',
      owner: map['owner']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      category: map['category']?.toString() ?? 'Main',
      location: map['location']?.toString() ?? map['address']?.toString() ?? '',
      latitude: parseD(map['latitude']),
      longitude: parseD(map['longitude']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order': order,
      'stallName': stallName,
      'owner': owner,
      'phone': phone,
      'category': category,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
