import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hostel_booking_frontend/data/models/room.dart';

class RoomProvider {
  final String baseUrl = "http://10.0.2.2:5000/api/hostel/rooms";

  Future<List<dynamic>> fetchRooms({required String token}) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> roomListJson = jsonDecode(response.body);
      return roomListJson.map((json) => Room.fromJson(json)).toList();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception(
        'Authorization failed. You are not permitted to perform this action.',
      );
    } else {
      throw Exception('Failed to load rooms.');
    }
  }

  Future<Map<String, dynamic>> addRoom({
    required Room room,
    required String token,
  }) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    final body = room.toJson()..remove('id');

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception(
        'Authorization failed. You are not permitted to perform this action.',
      );
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['error'] ?? 'Failed to add room.');
    }
  }
}
