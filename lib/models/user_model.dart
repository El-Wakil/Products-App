class User {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String nationalId;
  final String gender;
  final String? profileImage;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.nationalId,
    required this.gender,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['_id'] ?? json['id'],
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        nationalId: json['nationalId']?.toString() ?? '',
        gender: json['gender']?.toString() ?? '',
        profileImage: json['profileImage']?.toString(),
      );
    } catch (e) {
      // Return a default User object if parsing fails
      return User(
        name: 'Unknown User',
        email: 'unknown@example.com',
        phone: '',
        nationalId: '',
        gender: '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'nationalId': nationalId,
      'gender': gender,
      if (profileImage != null) 'profileImage': profileImage,
    };
  }
}
