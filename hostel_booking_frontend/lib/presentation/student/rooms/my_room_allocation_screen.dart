import 'package:flutter/material.dart';
import 'package:hostel_booking_frontend/data/models/room.dart';
import 'package:hostel_booking_frontend/presentation/constants/constants.dart'; // Import Constants
import 'package:hostel_booking_frontend/presentation/customs/app_bar.dart'; // Import CustomAppBar

class MyRoomAllocationScreen extends StatelessWidget {
  final Room? bookedRoom;

  const MyRoomAllocationScreen({Key? key, this.bookedRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isBooked = bookedRoom != null;
    final String title = isBooked ? 'My Allocated Room' : 'Room Not Allocated';

    final Widget cardContent =
        isBooked
            ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Congratulations!',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You have successfully booked a room.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Text(
                  'Room Number: ${bookedRoom!.roomNumber}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Room Type: ${bookedRoom!.type}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Total Beds: ${bookedRoom!.bedsTotal}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Nationality Restriction: ${bookedRoom!.nationalityRestriction}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            )
            : Center(
              child: const Text(
                'Room not allocated yet',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );

    return Scaffold(
      // Use the custom app bar
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: title),
      body: Container(
        // Set the custom background decoration
        decoration: Constants.buildBackgroundDecoration(),
        child: SafeArea(
          child: Center(
            child:
                isBooked
                    ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: cardContent,
                        ),
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: cardContent),
                    ),
          ),
        ),
      ),
    );
  }
}
