import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthProvider {
  final String baseUrl = "http://10.0.2.2:5000/api/auth/users";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['error'] ?? "Login failed");
    }
  }

  Future<List<dynamic>> getAllUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<Map<String, dynamic>> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
    int? studentRank,
  }) async {
    final Map<String, dynamic> body = {
      'user_name': name,
      'email': email,
      'password': password,
      'user_role': role,
    };

    if (studentRank != null) {
      body['student_rank'] = studentRank;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 409) {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['error'] ?? 'Registration failed');
    } else {
      throw Exception('An unexpected error occurred during registration.');
    }
  }
}
