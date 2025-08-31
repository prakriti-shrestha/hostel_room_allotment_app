import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/data/models/room.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_bloc.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_state.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_bloc.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_event.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_state.dart';
import 'package:hostel_booking_frontend/presentation/constants/constants.dart';
import 'package:hostel_booking_frontend/presentation/customs/app_bar.dart';
import 'package:hostel_booking_frontend/presentation/customs/dashboard_button.dart';
import 'package:hostel_booking_frontend/presentation/admin/rooms/add_room_screen.dart';

class RoomManagementScreen extends StatefulWidget {
  const RoomManagementScreen({super.key});

  @override
  State<RoomManagementScreen> createState() => _RoomManagementScreenState();
}

class _RoomManagementScreenState extends State<RoomManagementScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthSuccess) {
      final String token = authState.token;
      context.read<RoomBloc>().add(FetchRoomsRequested(token: token));
    } else {
      print("User is not authenticated, cannot fetch rooms");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Room Management"),
      body: Container(
        decoration: Constants.buildBackgroundDecoration(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Button at the top
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
                child: DashboardButton(
                  icon: Icons.person_add_alt_1_rounded,
                  label: "Add New Room",
                  onPressed: () {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is AuthSuccess) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  AddRoomScreen(token: authState.token),
                        ),
                      ).then((success) {
                        // After returning from the add screen, refresh the list
                        if (success == true) {
                          context.read<RoomBloc>().add(
                            FetchRoomsRequested(token: authState.token),
                          );
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Authentication error. Please log in again.",
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),

              // 2. List of rooms in the bottom part
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Text(
                  "All Rooms",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<RoomBloc, RoomState>(
                  builder: (context, state) {
                    if (state is RoomLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (state is RoomsLoadSuccess) {
                      final rooms = state.rooms;
                      if (rooms.isEmpty) {
                        return const Center(
                          child: Text(
                            "No rooms found.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }
                      return _buildRoomList(rooms, context);
                    } else if (state is RoomFailure) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Error: ${state.error}",
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: Text(
                        "Loading...",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildRoomList(List<Room> rooms, BuildContext context) {
  return RefreshIndicator(
    onRefresh: () async {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthSuccess) {
        context.read<RoomBloc>().add(
          FetchRoomsRequested(token: authState.token),
        );
      }
    },
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          color: Colors.white.withOpacity(0.15),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                room.roomNumber[0].toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF6A82FB),
                ),
              ),
            ),
            title: Text(
              room.roomNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              room.buildingId.toString(),
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
          ),
        );
      },
    ),
  );
}
