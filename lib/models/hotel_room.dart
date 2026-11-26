class HotelRoom {
  final String id;
  final String hotelID;
  final String title;
  final String roomType; // e.g. "AC", "Non-AC"
  final String seater; // e.g. "2 People", "1 Person", "3 People", "Dormitory"
  final double price;
  final double roomTariff;
  final double extraPersonCharges;
  final List<String> images;
  final String createdAt;

  const HotelRoom({
    required this.id,
    required this.hotelID,
    required this.title,
    required this.roomType,
    required this.seater,
    required this.price,
    required this.roomTariff,
    required this.extraPersonCharges,
    required this.images,
    required this.createdAt,
  });

  factory HotelRoom.fromMap(Map<String, dynamic> map, [String? id]) {
    double parseNum(dynamic val, [double def = 0.0]) {
      if (val == null) return def;
      if (val is num) return val.toDouble();
      final str = val.toString().trim();
      final parsed = double.tryParse(str);
      if (parsed == null || parsed.isNaN) return def;
      return parsed;
    }

    final rawImages = map['images'];
    final List<String> imgList = [];
    if (rawImages is List) {
      for (final img in rawImages) {
        if (img != null && img.toString().trim().isNotEmpty) {
          imgList.add(img.toString().trim());
        }
      }
    }

    final priceVal = parseNum(map['price'], 0.0);
    final tariffVal = parseNum(map['roomTariff'], priceVal);

    return HotelRoom(
      id: id ?? map['docId']?.toString() ?? '',
      hotelID: map['hotelID']?.toString().trim() ?? '',
      title: map['roomTitle']?.toString().trim() ?? 'Standard Room',
      roomType: map['roomType']?.toString().trim() ?? 'Non-AC',
      seater: map['seater']?.toString().trim() ?? '2 People',
      price: priceVal > 0 ? priceVal : (tariffVal > 0 ? tariffVal : 2500.0),
      roomTariff: tariffVal > 0 ? tariffVal : priceVal,
      extraPersonCharges: parseNum(map['extraPersonCharges'], 0.0),
      images: imgList,
      createdAt: map['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docId': id,
      'hotelID': hotelID,
      'roomTitle': title,
      'roomType': roomType,
      'seater': seater,
      'price': price.toStringAsFixed(2),
      'roomTariff': roomTariff.toStringAsFixed(2),
      'extraPersonCharges': extraPersonCharges.toStringAsFixed(2),
      'images': images,
      'created_at': createdAt,
    };
  }
}
