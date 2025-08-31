import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/data/models/booking.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_bloc.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_state.dart';
import 'package:hostel_booking_frontend/logic/booking_bloc/booking_bloc.dart';
import 'package:hostel_booking_frontend/logic/booking_bloc/booking_event.dart';
import 'package:hostel_booking_frontend/logic/booking_bloc/booking_state.dart';
import 'package:hostel_booking_frontend/presentation/constants/constants.dart';
import 'package:hostel_booking_frontend/presentation/customs/app_bar.dart';

class ViewBookingsScreen extends StatefulWidget {
  const ViewBookingsScreen({super.key});

  @override
  State<ViewBookingsScreen> createState() => _ViewBookingsScreenState();
}

class _ViewBookingsScreenState extends State<ViewBookingsScreen> {
  @override
  void initState() {
    super.initState();
    // Get the authentication token from the AuthBloc
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthSuccess) {
      // Dispatch the event to fetch all bookings using the real token
      context.read<BookingBloc>().add(
        FetchAllBookingsRequested(token: authState.token),
      );
    } else {
      // Handle cases where the user might not be authenticated
      print("Authentication Error: Cannot fetch bookings.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "All Bookings"),
      body: Container(
        decoration: Constants.buildBackgroundDecoration(),
        child: SafeArea(
          child: BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              if (state is BookingLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (state is BookingsLoadSuccess) {
                if (state.bookings.isEmpty) {
                  return const Center(
                    child: Text(
                      "No bookings found.",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  );
                }
                return _buildBookingList(state.bookings, context);
              }
              if (state is BookingFailure) {
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
                  "Loading Bookings...",
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper widget to build the list of bookings
  Widget _buildBookingList(List<Booking> bookings, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthSuccess) {
          context.read<BookingBloc>().add(
            FetchAllBookingsRequested(token: authState.token),
          );
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          // Format the date to be more readable (e.g., 2025-08-31)
          final formattedDate =
              booking.bookedAt.toLocal().toString().split(' ')[0];

          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            color: Colors.white.withOpacity(0.15),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16.0,
              ),
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.event_available_rounded,
                  color: Color(0xFF6A82FB),
                ),
              ),
              title: Text(
                booking.bookedByName, // Display the student's name
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                "Room: ${booking.roomNumber} on $formattedDate",
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
            ),
          );
        },
      ),
    );
  }
}
