class Taxi {
  final String id;
  final String driverName;
  final String vehicleName;
  final String vehicleType;
  final String district;
  final String phone;
  final double rating;
  final String price;
  final List<String> servingDistricts;
  final String address;
  final String document;
  final bool isActive;
  final Map<String, dynamic> rawData;

  const Taxi({
    required this.id,
    required this.driverName,
    required this.vehicleName,
    required this.vehicleType,
    required this.district,
    required this.phone,
    required this.rating,
    required this.price,
    required this.servingDistricts,
    this.address = '',
    this.document = '',
    this.isActive = true,
    this.rawData = const {},
  });

  factory Taxi.fromFirestore(Map<String, dynamic> data, String docId) {
    final List<String> serving = [];
    final flagMap = {
      'isDimapur': 'Dimapur / Chümoukedima',
      'isChumoukedima': 'Dimapur / Chümoukedima',
      'isKiphire': 'Kiphire',
      'isKohima': 'Kohima',
      'isLongleng': 'Longleng',
      'isMeluri': 'Meluri',
      'isMokokchung': 'Mokokchung',
      'isMon': 'Mon',
      'isNiuland': 'Niuland',
      'isNoklak': 'Noklak',
      'isPeren': 'Peren',
      'isPhek': 'Phek',
      'isShamator': 'Shamator',
      'isTseminyu': 'Tseminyü',
      'isTuensang': 'Tuensang',
      'isWokha': 'Wokha',
      'isZunheboto': 'Zünheboto',
    };

    flagMap.forEach((flag, name) {
      if (data[flag] == true && !serving.contains(name)) {
        serving.add(name);
      }
    });

    if (serving.isEmpty && data['servingDistricts'] is List) {
      for (final item in data['servingDistricts']) {
        final str = item.toString();
        final normalized = (str == 'Dimapur' || str == 'Chümoukedima')
            ? 'Dimapur / Chümoukedima'
            : str;
        if (!serving.contains(normalized)) {
          serving.add(normalized);
        }
      }
    }

    final carModel = data['carModel']?.toString().trim() ?? data['model']?.toString().trim() ?? 'Cab';
    final seater = data['seater']?.toString().trim() ?? data['seats']?.toString().trim() ?? '4 seater';
    final vehicleName = carModel.toLowerCase().contains(seater.toLowerCase())
        ? carModel
        : '$carModel - $seater';

    final addr = data['address']?.toString().trim() ?? '';
    final driver = data['driver']?.toString().trim() ?? 'Driver';
    final phone = data['phoneNumber']?.toString().trim() ?? data['phone']?.toString().trim() ?? '';

    return Taxi(
      id: data['taxiID']?.toString() ?? docId,
      driverName: driver.isNotEmpty ? driver : 'Driver',
      vehicleName: vehicleName,
      vehicleType: seater,
      district: addr.isNotEmpty ? addr : 'Nagaland',
      phone: phone,
      rating: (data['rating'] is num) ? (data['rating'] as num).toDouble() : 4.8,
      price: data['price']?.toString() ?? "₹3,000 / day",
      servingDistricts: serving,
      address: addr,
      document: data['document']?.toString() ?? '',
      isActive: data['isActive'] == true,
      rawData: data,
    );
  }

  bool isServingDistrict(String districtName) {
    final clean = districtName
        .toLowerCase()
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll(RegExp(r'[^a-z]'), '');

    if (clean.isEmpty || clean == 'all' || clean == 'alldistricts') return true;

    // Check raw boolean flags
    if (rawData.isNotEmpty) {
      if (clean.contains('dimapur') || clean.contains('chumoukedima')) {
        if (rawData['isDimapur'] == true || rawData['isChumoukedima'] == true) {
          return true;
        }
      }

      final flagMap = {
        'kiphire': 'isKiphire',
        'kohima': 'isKohima',
        'longleng': 'isLongleng',
        'meluri': 'isMeluri',
        'mokokchung': 'isMokokchung',
        'mon': 'isMon',
        'niuland': 'isNiuland',
        'noklak': 'isNoklak',
        'peren': 'isPeren',
        'phek': 'isPhek',
        'shamator': 'isShamator',
        'tseminyu': 'isTseminyu',
        'tuensang': 'isTuensang',
        'wokha': 'isWokha',
        'zunheboto': 'isZunheboto',
      };

      for (final entry in flagMap.entries) {
        if (clean.contains(entry.key) || entry.key.contains(clean)) {
          if (rawData[entry.value] == true) return true;
        }
      }
    }

    for (final d in servingDistricts) {
      final dClean = d
          .toLowerCase()
          .replaceAll('ü', 'u')
          .replaceAll('ö', 'o')
          .replaceAll(RegExp(r'[^a-z]'), '');
      if (dClean == clean || dClean.contains(clean) || clean.contains(dClean)) {
        return true;
      }
    }

    final addrClean = address
        .toLowerCase()
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll(RegExp(r'[^a-z]'), '');
    if (addrClean.contains(clean)) {
      return true;
    }

    return false;
  }
}
