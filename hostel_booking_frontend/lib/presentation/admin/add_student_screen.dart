import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_bloc.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_event.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_state.dart';
import 'package:hostel_booking_frontend/presentation/constants/constants.dart';
import 'package:hostel_booking_frontend/presentation/customs/app_bar.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rankController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rankController.dispose();
    super.dispose();
  }

  void _registerStudent() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterRequested(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: 'student', // Role is fixed
          studentRank: int.tryParse(_rankController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Add New Student"),
      body: Container(
        decoration: Constants.buildBackgroundDecoration(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Student registered successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is AuthFailure) {
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
                      controller: _nameController,
                      labelText: "Full Name",
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      labelText: "Email",
                      icon: Icons.email_rounded,
                      isEmail: true,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      labelText: "Password",
                      icon: Icons.lock_rounded,
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _rankController,
                      labelText: "Student Rank",
                      icon: Icons.format_list_numbered_rounded,
                      isNumber: true,
                    ),
                    const SizedBox(height: 40),
                    _buildRegisterButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool isPassword = false,
    bool isEmail = false,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType:
          isEmail
              ? TextInputType.emailAddress
              : (isNumber ? TextInputType.number : TextInputType.text),
      style: const TextStyle(color: Colors.black87),
      decoration: _buildInputDecoration(labelText: labelText, prefixIcon: icon),
      validator: (value) {
        if (value == null || value.isEmpty) return 'This field is required';
        if (isEmail && !value.contains('@'))
          return 'Please enter a valid email';
        if (isNumber && int.tryParse(value) == null)
          return 'Please enter a valid number';
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return BlocBuilder<AuthBloc, AuthState>(
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
          onPressed: state is AuthLoading ? null : _registerStudent,
          child:
              state is AuthLoading
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFF6A82FB),
                    ),
                  )
                  : const Text(
                    "REGISTER STUDENT",
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
}
