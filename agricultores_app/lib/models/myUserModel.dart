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
      id: json['pk'],
      firstName: json['fields']['first_name'],
      lastName: json['fields']['last_name'],
      role: json['fields']['role'],
      ubigeo: json['fields']['district'],
      profilePicture: json['fields']['profile_picture_URL'],
    );
  }
}
