class UserModel {
  final String userId;
  final String email;
  final String fullName;
  final String phone;
  final String gender;
  final String state;
  final String country;
  final bool isActive;
  final String dateCreated;

  UserModel({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.gender,
    required this.state,
    required this.country,
    this.isActive = true,
    this.dateCreated = '',
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      userId: map['userID']?.toString() ?? docId,
      email: map['email']?.toString() ?? '',
      fullName: map['fullName']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      gender: map['gender']?.toString() ?? 'Female',
      state: map['states']?.toString() ?? 'Nagaland',
      country: map['country']?.toString() ?? 'India',
      isActive: map['isActive'] == true,
      dateCreated: map['date_created']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userId,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'gender': gender,
      'states': state,
      'country': country,
      'isActive': isActive,
      'date_created': dateCreated,
    };
  }
}
