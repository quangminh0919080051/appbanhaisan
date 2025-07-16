// lib/models/user.dart
class User {
  final String? id;
  final String? name;
  final String? email;
  final String? role; // 'user' or 'admin'

  User({this.id, this.name, this.email, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
    );
  }
}