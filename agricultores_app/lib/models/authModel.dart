class AuthenticateUser {
  final String access;
  final String refresh;

  AuthenticateUser({this.access, this.refresh});

  factory AuthenticateUser.fromJson(Map<String, dynamic> json) {
    return AuthenticateUser(
      access: json['access'],
      refresh: json['refresh'],
    );
  }
}
