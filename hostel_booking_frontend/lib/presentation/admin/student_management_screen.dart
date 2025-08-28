import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/data/models/user.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_bloc.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_event.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_state.dart';
import 'package:hostel_booking_frontend/presentation/admin/add_student_screen.dart';
import 'package:hostel_booking_frontend/presentation/constants/constants.dart';
import 'package:hostel_booking_frontend/presentation/customs/app_bar.dart';
import 'package:hostel_booking_frontend/presentation/customs/dashboard_button.dart';

// Convert the screen to a StatefulWidget to fetch data on load
class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the list of users as soon as the screen is loaded
    context.read<AuthBloc>().add(const GetAllUsersRequested(token: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Student Management"),
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
                  label: "Add New Student",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddStudentScreen(),
                      ),
                    ).then((_) {
                      // After returning from the add screen, refresh the list
                      context.read<AuthBloc>().add(
                        const GetAllUsersRequested(token: ''),
                      );
                    });
                  },
                ),
              ),

              // 2. List of students in the bottom part
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Text(
                  "All Students",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (state is UsersLoadSuccess) {
                      final students =
                          state.users
                              .where((user) => user.role == 'student')
                              .toList();
                      if (students.isEmpty) {
                        return const Center(
                          child: Text(
                            "No students found.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }
                      return _buildStudentList(students);
                    } else if (state is AuthFailure) {
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

  // Widget to build the list view of students
  Widget _buildStudentList(List<User> students) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AuthBloc>().add(const GetAllUsersRequested(token: ''));
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
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
                  student.name[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF6A82FB),
                  ),
                ),
              ),
              title: Text(
                student.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                student.email,
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
            ),
          );
        },
      ),
    );
  }
}
