import 'package:hostel_booking_frontend/data/providers/auth_providers.dart';
import 'package:hostel_booking_frontend/data/models/user.dart';

class AuthRepository {
  final AuthProvider provider;
  AuthRepository(this.provider);

  Future<User> login(String email, String password) async {
    try {
      final Map<String, dynamic> data = await provider.login(email, password);
      final user = User.fromJson(data["user"]);
      return user;
    } catch (e) {
      throw Exception("Login failed");
    }
  }
}
