import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingProviders {
  final String baseUrl = "http://10.0.2.2:5000/api/booking/bookings";

  Future<List<dynamic>> getAllBookings({required String token}) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Authorization failed. Please log in again.');
    } else {
      throw Exception('Failed to load bookings.');
    }
  }

  Future<Map<String, dynamic>> getBookingsById({
    required int id,
    required String token,
  }) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Authorization failed. Please log in again.');
    } else {
      throw Exception('Failed to load bookings.');
    }
  }

  Future<Map<String, dynamic>> addBooking({
    required int roomId,
    required int bookedBy,
    required DateTime bookedAt,
    required String token,
  }) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    final Map<String, dynamic> body = {
      "room_id": roomId,
      "booked_by": bookedBy,
      "booked_at": bookedAt.toIso8601String().substring(0, 10),
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Authorization failed. Please log in again.');
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['error'] ?? 'Failed to create booking.');
    }
  }
}
