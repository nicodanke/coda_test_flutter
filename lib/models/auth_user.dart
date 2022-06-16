class AuthUser {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String accessToken;

  AuthUser({required this.id, required this.firstName, required this.lastName, required this.email, required this.accessToken});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthUser && runtimeType == other.runtimeType && accessToken == other.accessToken;

  @override
  int get hashCode => accessToken.hashCode;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'],
    firstName: json['firstname'],
    lastName: json['lastname'],
    email: json['email'],
    accessToken: json['access_token'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['firstname'] = firstName;
    data['lastname'] = lastName;
    data['email'] = email;
    data['access_token'] = accessToken;
    return data;
  }
}
