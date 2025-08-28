import 'package:hostel_booking_frontend/data/models/room.dart';
import 'package:hostel_booking_frontend/data/providers/room_providers.dart';

class RoomRepository {
  final RoomProvider provider;
  RoomRepository(this.provider);

  Future<List<Room>> fetchRooms({required String token}) async {
    final List<dynamic> roomListJson = await provider.fetchRooms(token: token);

    return roomListJson.map((json) => Room.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> addRoom({
    required Room room,
    required String token,
  }) async {
    try {
      return await provider.addRoom(room: room, token: token);
    } catch (e) {
      rethrow;
    }
  }
}
