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
  });
}
