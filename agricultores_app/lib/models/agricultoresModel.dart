class agricultores{
  final int id;
  final String firstName;
  final String lastName;
  final String role;
  final String profilePicture;
  final String ubigeo;
  final isVerified;

  agricultores({
    this.id,
    this.firstName,
    this.lastName,
    this.role,
    this.profilePicture,
    this.ubigeo,
    this.isVerified,
  });

  factory agricultores.fromJson(Map<String, dynamic> json) {
    return agricultores(
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
