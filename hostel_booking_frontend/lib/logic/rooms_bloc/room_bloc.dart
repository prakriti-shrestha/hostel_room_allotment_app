import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/data/repositories/room_repository.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_event.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository repository;

  RoomBloc(this.repository) : super(RoomInitial()) {
    // --- Fetch All Rooms Handler ---
    on<FetchRoomsRequested>((event, emit) async {
      emit(RoomLoading());
      try {
        final rooms = await repository.fetchRooms(token: event.token);
        emit(RoomsLoadSuccess(rooms: rooms));
      } catch (e) {
        emit(RoomFailure(error: e.toString()));
      }
    });

    // --- Add New Room Handler ---
    on<AddRoomRequested>((event, emit) async {
      emit(RoomLoading());
      try {
        await repository.addRoom(room: event.room, token: event.token);
        emit(RoomAddSuccess());
      } catch (e) {
        emit(RoomFailure(error: e.toString()));
      }
    });
  }
}
