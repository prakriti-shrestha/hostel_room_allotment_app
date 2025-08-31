import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/data/models/room.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_bloc.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_event.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_state.dart';
import 'package:hostel_booking_frontend/presentation/constants/constants.dart';
import 'package:hostel_booking_frontend/presentation/customs/app_bar.dart';

class AddRoomScreen extends StatefulWidget {
  final String token;
  const AddRoomScreen({super.key, required this.token});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buildingIdController = TextEditingController();
  final _roomNumberController = TextEditingController();
  final _typeController = TextEditingController(); // e.g., AC, Non-AC
  final _bedsTotalController = TextEditingController();
  final _nationalityController = TextEditingController();
  bool _isApartment = false;

  @override
  void dispose() {
    _buildingIdController.dispose();
    _roomNumberController.dispose();
    _typeController.dispose();
    _bedsTotalController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  void _submitAddRoom() {
    if (_formKey.currentState!.validate()) {
      // Create a Room object from the form data
      final newRoom = Room(
        // ID is null because the database will assign it
        buildingId: int.parse(_buildingIdController.text),
        roomNumber: _roomNumberController.text,
        type: _typeController.text,
        bedsTotal: int.parse(_bedsTotalController.text),
        occupied: 0, // A new room starts with 0 occupied beds
        isApartment: _isApartment,
        nationalityRestriction: _nationalityController.text,
      );

      // Dispatch the event to the RoomBloc
      context.read<RoomBloc>().add(
        AddRoomRequested(
          room: newRoom,
          token: widget.token, // Use the token passed to this widget
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Add New Room"),
      body: Container(
        decoration: Constants.buildBackgroundDecoration(),
        // Use a BlocListener to react to state changes like success or failure
        child: BlocListener<RoomBloc, RoomState>(
          listener: (context, state) {
            if (state is RoomAddSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Room added successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
              // Go back to the previous screen with a success flag
              Navigator.pop(context, true);
            } else if (state is RoomFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: ${state.error}"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _buildingIdController,
                      labelText: "Building ID",
                      icon: Icons.business_rounded,
                      isNumber: true,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _roomNumberController,
                      labelText: "Room Number",
                      icon: Icons.meeting_room_outlined,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _typeController,
                      labelText: "Type (e.g., AC, Non-AC)",
                      icon: Icons.ac_unit_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _bedsTotalController,
                      labelText: "Total Beds",
                      icon: Icons.bed_rounded,
                      isNumber: true,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _nationalityController,
                      labelText: "Nationality Restriction",
                      icon: Icons.flag_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildApartmentSwitch(),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // A reusable text field widget, just like in your AddStudentScreen
  TextFormField _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.black87),
      decoration: _buildInputDecoration(labelText: labelText, prefixIcon: icon),
      validator: (value) {
        if (value == null || value.isEmpty) return 'This field is required';
        if (isNumber && int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  // A switch for the boolean 'isApartment' field
  Widget _buildApartmentSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.apartment_rounded, color: Colors.grey.shade600),
              const SizedBox(width: 12),
              const Text(
                "Is this an apartment?",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
          Switch(
            value: _isApartment,
            onChanged: (value) {
              setState(() {
                _isApartment = value;
              });
            },
            activeColor: const Color(0xFF6A82FB),
          ),
        ],
      ),
    );
  }

  // Reusable input decoration
  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600),
      labelStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6A82FB), width: 2),
      ),
    );
  }

  // The submit button, which shows a loading indicator based on the Bloc state
  Widget _buildSubmitButton() {
    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF6A82FB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: state is RoomLoading ? null : _submitAddRoom,
          child:
              state is RoomLoading
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFF6A82FB),
                    ),
                  )
                  : const Text(
                    "ADD ROOM",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
        );
      },
    );
  }
}
