class Tribe {
  final int id;
  final String docId;
  final String name;
  final String district;
  final String festival;
  final String image;
  final String description;
  final String? createdAt;

  const Tribe({
    required this.id,
    this.docId = '',
    required this.name,
    required this.district,
    required this.festival,
    required this.image,
    required this.description,
    this.createdAt,
  });

  String get uniqueKey => docId.isNotEmpty ? docId : '${id}_$name';

  factory Tribe.fromMap(Map<String, dynamic> map, [String? docId, int? fallbackId]) {
    final name = (map['name'] ?? map['tribe'] ?? '').toString();
    final district = (map['district'] ?? '').toString();
    final description = (map['description'] ?? '').toString();
    final photo = (map['photo'] ?? map['image'] ?? map['imageUrl'] ?? '').toString();
    final festival = (map['festival'] ?? map['festivalName'] ?? '').toString();
    final createdAt = map['createdAt']?.toString();

    // Determine numerical serialno / ID
    int id = fallbackId ?? 0;
    final rawSerial = map['serialno'] ?? map['serialNo'] ?? map['serial_no'] ?? map['id'];
    if (rawSerial != null) {
      if (rawSerial is num) {
        id = rawSerial.toInt();
      } else {
        id = int.tryParse(rawSerial.toString()) ?? id;
      }
    }
    if (id <= 0) {
      id = idFromName(name);
    }
    if (id <= 0) {
      id = 999;
    }

    return Tribe(
      id: id,
      docId: docId ?? map['docId']?.toString() ?? '',
      name: name,
      district: district,
      festival: festival,
      image: photo,
      description: description,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'docId': docId,
      'name': name,
      'district': district,
      'festival': festival,
      'image': image,
      'photo': image,
      'description': description,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  static int idFromName(String name) {
    final lower = name.toLowerCase().trim();
    if (lower.contains('angami')) return 1;
    if (lower.contains('ao')) return 2;
    if (lower.contains('chakhesang')) return 3;
    if (lower.contains('chang')) return 4;
    if (lower.contains('garo')) return 5;
    if (lower.contains('kachari')) return 6;
    if (lower.contains('khiamniungan') || lower.contains('khiam')) return 7;
    if (lower.contains('konyak')) return 8;
    if (lower.contains('kuki')) return 9;
    if (lower.contains('lotha')) return 10;
    if (lower.contains('phom')) return 11;
    if (lower.contains('pochury')) return 12;
    if (lower.contains('rengma')) return 13;
    if (lower.contains('sangtam')) return 14;
    if (lower.contains('sumi')) return 15;
    if (lower.contains('tikhir')) return 16;
    if (lower.contains('yimkhiung') || lower.contains('yimchunger')) return 17;
    if (lower.contains('zeliang')) return 18;
    return 1;
  }
}
