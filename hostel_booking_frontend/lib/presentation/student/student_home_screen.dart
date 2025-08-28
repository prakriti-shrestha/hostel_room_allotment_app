import 'package:flutter/material.dart';
import 'package:hostel_booking_frontend/presentation/customs/dashboard_button.dart';
import 'package:hostel_booking_frontend/presentation/customs/app_bar.dart';
import 'package:hostel_booking_frontend/presentation/constants/constants.dart';

class StudentHomeScreen extends StatelessWidget {
  final String name;

  const StudentHomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Allows body to go behind a transparent app bar
      appBar: CustomAppBar(title: "Student Dashboard"),
      body: Container(
        decoration: Constants.buildBackgroundDecoration(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWelcomeHeader(),
                const SizedBox(height: 50),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white70,
          child: Icon(Icons.school_rounded, size: 50, color: Color(0xFF6A82FB)),
        ),
        const SizedBox(height: 16),
        Text(
          "Welcome,",
          style: TextStyle(fontSize: 26, color: Colors.white.withOpacity(0.9)),
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 34,
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
        icon: Icons.hotel,
        label: "Book a Room",
        onPressed: () {
          // TODO: Navigate to Room Booking screen
          print("Navigating to Book a Room...");
        },
      ),
      const SizedBox(height: 20),
      DashboardButton(
        icon: Icons.assignment_ind,
        label: "My Room Allocation",
        onPressed: () {
          // TODO: Navigate to My Allocation screen
          print("Navigating to My Room Allocation...");
        },
      ),
      const SizedBox(height: 20),
      DashboardButton(
        icon: Icons.person,
        label: "My Profile",
        onPressed: () {
          // TODO: Navigate to Profile/Details screen
          print("Navigating to My Profile...");
        },
      ),
    ];
  }
}
