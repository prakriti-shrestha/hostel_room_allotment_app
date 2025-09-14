import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/data/models/room.dart';
import 'package:hostel_booking_frontend/logic/booking_bloc/booking_bloc.dart';
import 'package:hostel_booking_frontend/logic/booking_bloc/booking_event.dart';
import 'package:hostel_booking_frontend/logic/booking_bloc/booking_state.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_bloc.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_event.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_state.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_bloc.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_state.dart';
import 'package:hostel_booking_frontend/presentation/constants/constants.dart';
import 'package:hostel_booking_frontend/presentation/customs/app_bar.dart';

// Converted to a StatefulWidget to use initState
class AvailableRoomsScreen extends StatefulWidget {
  final String roomType;
  final int beds;
  final String nationality;

  const AvailableRoomsScreen({
    super.key,
    required this.roomType,
    required this.beds,
    required this.nationality,
  });

  @override
  State<AvailableRoomsScreen> createState() => _AvailableRoomsScreenState();
}

class _AvailableRoomsScreenState extends State<AvailableRoomsScreen> {
  @override
  void initState() {
    super.initState();
    // Get auth state once and dispatch the event to fetch rooms.
    // initState is the perfect place for one-time setup calls.
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<RoomBloc>().add(FetchRoomsRequested(token: authState.token));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch for auth changes. If the user logs out while on this screen,
    // it will react accordingly.
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthSuccess) {
          return const Scaffold(
            body: Center(
              child: Text("Authentication error. Please log in again."),
            ),
          );
        }

        // Main screen UI
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(title: "Available Rooms"),
          body: Container(
            decoration: Constants.buildBackgroundDecoration(),
            child: SafeArea(
              child: BlocListener<BookingBloc, BookingState>(
                listener: (context, state) {
                  if (state is BookingAddSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Room booked successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                  if (state is BookingFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Booking failed: ${state.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: BlocBuilder<RoomBloc, RoomState>(
                  builder: (context, state) {
                    if (state is RoomLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    if (state is RoomFailure) {
                      return Center(
                        child: Text(
                          'Failed to load rooms: ${state.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    if (state is RoomsLoadSuccess) {
                      final filteredRooms =
                          state.rooms.where((room) {
                            final typeMatch =
                                room.type.toLowerCase() ==
                                widget.roomType.toLowerCase();
                            final bedsMatch = room.bedsTotal == widget.beds;
                            final nationalityMatch =
                                (widget.nationality.toLowerCase() == 'any') ||
                                (room.nationalityRestriction.toLowerCase() ==
                                    widget.nationality.toLowerCase());
                            return typeMatch &&
                                bedsMatch &&
                                nationalityMatch &&
                                room.isAvailable;
                          }).toList();

                      if (filteredRooms.isEmpty) {
                        return const Center(
                          child: Text(
                            'No rooms match your preferences.',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredRooms.length,
                        itemBuilder: (context, index) {
                          final room = filteredRooms[index];
                          return Card(
                            color: Colors.black.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: ListTile(
                                title: Text(
                                  'Room: ${room.roomNumber}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  '${room.type}, ${room.bedsTotal} Beds\nBeds Available: ${room.bedsAvailable}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: ElevatedButton(
                                  onPressed:
                                      () => _confirmBooking(
                                        context,
                                        room,
                                        authState,
                                      ), // Pass the auth state
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF6A82FB,
                                    ).withOpacity(0.8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Book',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: Text(
                        'Select preferences to see rooms.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmBooking(BuildContext context, Room room, AuthSuccess authState) {
    // The real token and user ID are taken from the authState passed into this function
    final String token = authState.token;
    final int userId = authState.user.id;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2c3e50),
          title: const Text(
            'Confirm Booking',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to book room ${room.roomNumber}?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: Color(0xFF6A82FB)),
              ),
              onPressed: () {
                context.read<BookingBloc>().add(
                  AddBookingRequested(
                    roomId: room.id!,
                    bookedBy: userId,
                    bookedAt: DateTime.now(),
                    token: token,
                  ),
                );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
