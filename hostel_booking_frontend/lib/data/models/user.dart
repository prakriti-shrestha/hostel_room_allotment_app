class User {
  final int id;
  final String email;
  final String role;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['user_id'],
      name: json['name'] ?? json['user_name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? json['user_role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'role': role, 'name': name};
  }
}
