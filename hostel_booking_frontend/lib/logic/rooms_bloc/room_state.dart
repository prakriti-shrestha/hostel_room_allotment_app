import 'package:equatable/equatable.dart';
import 'package:hostel_booking_frontend/data/models/room.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomsLoadSuccess extends RoomState {
  final List<Room> rooms;

  const RoomsLoadSuccess({required this.rooms});
}

class RoomAddSuccess extends RoomState {}

class RoomFailure extends RoomState {
  final String error;

  const RoomFailure({required this.error});
}
