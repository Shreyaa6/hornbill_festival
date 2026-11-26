class Hotel {
  final String id;
  final String? hotelID;
  final String name;
  final String type;
  final String district;
  final String address;
  final double rating;
  final int price;
  final int strikethroughPrice;
  final String image;
  final String? photoUrl;
  final String? gmaps;
  final String? document;
  final String? owner;
  final String? town;
  final String phone;
  final bool isFeatured;
  final bool roomsAvailable;
  final bool isActive;
  final bool isAC;
  final bool isFooding;
  final bool isFridge;
  final bool isParking;
  final bool isPowerBackup;
  final bool isSwimming;
  final bool isWifi;
  final String? createdAt;
  final List<String> facilities;

  const Hotel({
    required this.id,
    this.hotelID,
    required this.name,
    required this.type,
    required this.district,
    required this.address,
    this.rating = 4.5,
    this.price = 3500,
    this.strikethroughPrice = 4500,
    required this.image,
    this.photoUrl,
    this.gmaps,
    this.document,
    this.owner,
    this.town,
    required this.phone,
    this.isFeatured = false,
    this.roomsAvailable = true,
    this.isActive = true,
    this.isAC = false,
    this.isFooding = false,
    this.isFridge = false,
    this.isParking = false,
    this.isPowerBackup = false,
    this.isSwimming = false,
    this.isWifi = false,
    this.createdAt,
    this.facilities = const [],
  });

  factory Hotel.fromMap(Map<String, dynamic> data, String docId) {
    final hotelName = data['hotelName']?.toString().trim() ?? 'Hotel';
    final prop = data['property']?.toString().trim() ?? 'Hotel';
    final isResort = prop.toLowerCase().contains('resort') ||
        data['isFeatured'] == true ||
        hotelName.toLowerCase().contains('resort') ||
        hotelName.toLowerCase().contains('rudi') ||
        hotelName.toLowerCase().contains('rüdi') ||
        docId == 'TugCrwLHmkLAtw6x90Vj';
    final photoStr = data['photo']?.toString().trim() ?? '';
    final hotelIdVal = data['hotelID']?.toString().trim() ?? docId;

    final isWifi = data['isWifi'] == true;
    final isFooding = data['isFooding'] == true;
    final isPowerBackup = data['isPowerBackup'] == true;
    final isParking = data['isParking'] == true;
    final isFridge = data['isFridge'] == true;
    final isAC = data['isAC'] == true;
    final isSwimming = data['isSwimming'] == true;

    final facilities = <String>[];
    if (isWifi) facilities.add('Free Wifi');
    if (isFooding) facilities.add('Fooding');
    if (isPowerBackup) facilities.add('24x7 Power');
    if (isParking) facilities.add('Parking');
    if (isFridge) facilities.add('Fridge');
    if (isAC) facilities.add('AC Rooms');
    if (isSwimming) facilities.add('Pool');

    return Hotel(
      id: docId,
      hotelID: hotelIdVal.isNotEmpty ? hotelIdVal : docId,
      name: hotelName,
      type: isResort ? 'Resort' : prop,
      district: data['district']?.toString().trim() ?? 'Kohima',
      address: data['address']?.toString().trim() ?? '',
      town: data['town']?.toString().trim(),
      owner: data['owner']?.toString().trim(),
      phone: data['phoneNumber']?.toString().trim() ?? '',
      image: photoStr.isNotEmpty ? photoStr : 'assets/images/hotels/$docId.jpg',
      photoUrl: photoStr.isNotEmpty ? photoStr : null,
      gmaps: data['gmaps']?.toString().trim(),
      document: data['document']?.toString().trim(),
      rating: isResort ? 4.8 : 4.5,
      price: isResort ? 6500 : 3500,
      strikethroughPrice: isResort ? 8000 : 4500,
      isFeatured: isResort,
      roomsAvailable: data['isActive'] != false && data['isActive'] != 'false',
      isActive: data['isActive'] != false && data['isActive'] != 'false',
      isAC: isAC,
      isFooding: isFooding,
      isFridge: isFridge,
      isParking: isParking,
      isPowerBackup: isPowerBackup,
      isSwimming: isSwimming,
      isWifi: isWifi,
      createdAt: data['created_at']?.toString(),
      facilities: facilities,
    );
  }
}
