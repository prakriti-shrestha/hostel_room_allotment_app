import 'package:flutter/material.dart';
import 'package:hostel_booking_frontend/presentation/constants/constants.dart';
import 'package:hostel_booking_frontend/presentation/customs/app_bar.dart';
import 'package:hostel_booking_frontend/presentation/customs/dashboard_button.dart';
import 'package:hostel_booking_frontend/presentation/student/rooms/available_rooms_screen.dart';

class RoomPreferenceScreen extends StatefulWidget {
  const RoomPreferenceScreen({super.key});

  @override
  State<RoomPreferenceScreen> createState() => _RoomPreferenceScreenState();
}

class _RoomPreferenceScreenState extends State<RoomPreferenceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;
  int? _selectedBeds;
  String? _selectedNationality;

  final List<String> _roomTypes = ['AC', 'Non-AC'];
  final List<int> _bedOptions = [1, 2, 4, 6];
  final List<String> _nationalityOptions = ['Local', 'International', 'Any'];

  void _submitPreferences() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => AvailableRoomsScreen(
                roomType: _selectedType!,
                beds: _selectedBeds!,
                nationality: _selectedNationality!,
              ),
        ),
      );
    }
  }

  // Helper method for consistent input decoration
  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.black.withOpacity(0.2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
      errorStyle: const TextStyle(color: Colors.yellowAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: "Select Preferences"),
      body: Container(
        decoration: Constants.buildBackgroundDecoration(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Find Your Perfect Room',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Styled Dropdowns
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        hint: const Text('Select Room Type'),
                        decoration: _buildInputDecoration('Select Room Type'),
                        dropdownColor: const Color(0xFF2c3e50),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white70,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        items:
                            _roomTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                        onChanged:
                            (newValue) =>
                                setState(() => _selectedType = newValue),
                        validator:
                            (value) =>
                                value == null
                                    ? 'Please select a room type'
                                    : null,
                      ),
                      const SizedBox(height: 20),

                      DropdownButtonFormField<int>(
                        value: _selectedBeds,
                        decoration: _buildInputDecoration(
                          'Select Number of Beds',
                        ),
                        dropdownColor: const Color(0xFF2c3e50),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white70,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        items:
                            _bedOptions.map((int beds) {
                              return DropdownMenuItem<int>(
                                value: beds,
                                child: Text('$beds Beds'),
                              );
                            }).toList(),
                        onChanged:
                            (newValue) =>
                                setState(() => _selectedBeds = newValue),
                        validator:
                            (value) =>
                                value == null
                                    ? 'Please select the number of beds'
                                    : null,
                      ),
                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        value: _selectedNationality,
                        decoration: _buildInputDecoration(
                          'Select Nationality Preference',
                        ),
                        dropdownColor: const Color(0xFF2c3e50),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white70,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        items:
                            _nationalityOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged:
                            (newValue) =>
                                setState(() => _selectedNationality = newValue),
                        validator:
                            (value) =>
                                value == null
                                    ? 'Please select a nationality preference'
                                    : null,
                      ),
                      const SizedBox(height: 40),

                      // Use the DashboardButton for submission
                      DashboardButton(
                        icon: Icons.search,
                        label: "Find Rooms",
                        onPressed: _submitPreferences,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
