import 'package:flutter/material.dart';
import 'package:hostel_booking_frontend/presentation/customs/app_bar.dart';
import 'package:hostel_booking_frontend/presentation/customs/dashboard_button.dart';
import 'package:hostel_booking_frontend/presentation/constants/constants.dart';
import 'package:hostel_booking_frontend/presentation/admin/students/student_management_screen.dart';
import 'package:hostel_booking_frontend/presentation/admin/rooms/room_management_screen.dart';
import 'package:hostel_booking_frontend/presentation/admin/bookings/booking_management_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  final String name;

  const AdminHomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: "Admin Dashboard"),
      body: Container(
        decoration: Constants.buildBackgroundDecoration(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildWelcomeHeader(),
                const SizedBox(height: 40),
                ..._buildDashboardButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.admin_panel_settings_rounded,
          size: 60,
          color: Colors.white70,
        ),
        const SizedBox(height: 16),
        Text(
          "Welcome back,",
          style: TextStyle(fontSize: 24, color: Colors.white.withOpacity(0.8)),
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDashboardButtons(BuildContext context) {
    return [
      DashboardButton(
        icon: Icons.meeting_room,
        label: "Manage Rooms",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RoomManagementScreen(),
            ),
          );
        },
      ),
      const SizedBox(height: 20),
      DashboardButton(
        icon: Icons.people,
        label: "View Students",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentManagementScreen(),
            ),
          );
        },
      ),
      const SizedBox(height: 20),
      DashboardButton(
        icon: Icons.assignment_turned_in,
        label: "Room Allotment",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ViewBookingsScreen()),
          );
        },
      ),
    ];
  }
}
