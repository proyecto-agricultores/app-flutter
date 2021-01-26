class MyUser {
  final int id;
  final String firstName;
  final String lastName;
  final String role;
  final String profilePicture;
  final String ubigeo;

  MyUser(
      {this.id,
      this.firstName,
      this.lastName,
      this.role,
      this.profilePicture,
      this.ubigeo});

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      ubigeo: json['district'],
      profilePicture: json['profile_picture_URL'],
    );
  }
}
