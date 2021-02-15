class User{
  final int id;
  final String firstName;
  final String lastName;
  final String role;
  final String profilePicture;
  final String ubigeo;
  final isVerified;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.role,
    this.profilePicture,
    this.ubigeo,
    this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      ubigeo: json['district'],
      profilePicture: json['profile_picture_URL'],
      isVerified: json['is_verified'],
    );
  }
}