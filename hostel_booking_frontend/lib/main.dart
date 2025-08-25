import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/data/providers/auth_providers.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_bloc.dart';
import 'package:hostel_booking_frontend/data/repositories/auth_repository.dart';
import 'package:hostel_booking_frontend/presentation/auth/login_screen.dart';

void main() {
  final authProvider = AuthProvider();
  final authRepository = AuthRepository(authProvider);

  runApp(HostelAllotment(authRepository: authRepository));
}

class HostelAllotment extends StatelessWidget {
  final AuthRepository authRepository;

  const HostelAllotment({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthBloc(authRepository))],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hostel Allotment',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginScreen(),
      ),
    );
  }
}
