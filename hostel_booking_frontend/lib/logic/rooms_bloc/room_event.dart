import 'package:equatable/equatable.dart';
import 'package:hostel_booking_frontend/data/models/room.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class FetchRoomsRequested extends RoomEvent {
  final String token;

  const FetchRoomsRequested({required this.token});
}

class AddRoomRequested extends RoomEvent {
  final Room room;
  final String token;

  const AddRoomRequested({required this.room, required this.token});
}
