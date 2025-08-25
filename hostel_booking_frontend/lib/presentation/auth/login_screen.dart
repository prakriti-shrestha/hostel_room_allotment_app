import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/data/providers/auth_providers.dart';
import 'package:hostel_booking_frontend/data/repositories/auth_repository.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_bloc.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_event.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_state.dart';
import 'package:hostel_booking_frontend/presentation/admin/admin_home_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthRepository(AuthProvider())),
      child: Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              if (state.user.role == "admin") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminHomeScreen()),
                );
                // } else if (state.user.role == "student") {
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //       builder:
                //           (context) => StudentHomeScreen(name: state.user.name),
                //     ),
                //   );
              }
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                TextField(controller: emailController),
                TextField(controller: passwordController, obscureText: true),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      LoginRequested(
                        emailController.text,
                        passwordController.text,
                      ),
                    );
                  },
                  child: Text("Login"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
