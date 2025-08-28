import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_bloc.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_event.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_state.dart';
import 'package:hostel_booking_frontend/presentation/admin/admin_home_screen.dart';
import 'package:hostel_booking_frontend/presentation/student/student_home_screen.dart';
import 'package:hostel_booking_frontend/presentation/constants/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers are managed inside a StatefulWidget
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Dispose controllers to free up resources
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Constants.buildBackgroundDecoration(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              // Use a variable for the user to avoid repetition
              final user = state.user;
              if (user.role == "admin") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminHomeScreen(name: user.name),
                  ),
                );
              } else if (user.role == "student") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentHomeScreen(name: user.name),
                  ),
                );
              }
            } else if (state is AuthFailure) {
              // Show a more visually distinct error snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildEmailField(),
                      const SizedBox(height: 20),
                      _buildPasswordField(),
                      const SizedBox(height: 40),
                      _buildLoginButton(context, state),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Icon(Icons.lock_open_rounded, color: Colors.white, size: 80),
        SizedBox(height: 16),
        Text(
          "Welcome Back",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Sign in to continue",
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      ],
    );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.black87),
      decoration: _buildInputDecoration(
        labelText: "Email",
        hintText: "you@example.com",
        prefixIcon: Icons.email_rounded,
      ),
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(color: Colors.black87),
      decoration: _buildInputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        prefixIcon: Icons.lock_rounded,
      ).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey.shade600,
          ),
          onPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthState state) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF6A82FB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      // Disable button while loading
      onPressed:
          state is AuthLoading
              ? null
              : () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                    LoginRequested(
                      emailController.text,
                      passwordController.text,
                    ),
                  );
                }
              },
      child:
          state is AuthLoading
              // Show a spinner inside the button when loading
              ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFF6A82FB),
                ),
              )
              : const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
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
