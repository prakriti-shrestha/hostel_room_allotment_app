import 'package:hostel_booking_frontend/data/providers/auth_providers.dart';
import 'package:hostel_booking_frontend/data/models/user.dart';

class AuthRepository {
  final AuthProvider provider;
  AuthRepository(this.provider);

  Future<(User, String)> login(String email, String password) async {
    try {
      final Map<String, dynamic> data = await provider.login(email, password);

      final user = User.fromJson(data["user"]);
      final token = data["token"] as String;

      return (user, token);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> getAllUsers() async {
    final List<dynamic> userListJson = await provider.getAllUsers();

    return userListJson.map((json) => User.fromJson(json)).toList();
  }

  Future<User> getUserById(int id) async {
    final Map<String, dynamic> userJson = await provider.getUserById(id);

    return User.fromJson(userJson);
  }

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
    int? studentRank,
  }) async {
    try {
      return await provider.registerUser(
        name: name,
        email: email,
        password: password,
        role: role,
        studentRank: studentRank,
      );
    } catch (e) {
      rethrow;
    }
  }
}
