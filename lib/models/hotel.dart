class Hotel {
  final String id;
  final String name;
  final String type;
  final String district;
  final String address;
  final double rating;
  final int price;
  final int strikethroughPrice;
  final String image;
  final String phone;
  final bool isFeatured;
  final bool roomsAvailable;
  final List<String> facilities;

  const Hotel({
    required this.id,
    required this.name,
    required this.type,
    required this.district,
    required this.address,
    required this.rating,
    required this.price,
    required this.strikethroughPrice,
    required this.image,
    required this.phone,
    required this.isFeatured,
    required this.roomsAvailable,
    required this.facilities,
  });
}
