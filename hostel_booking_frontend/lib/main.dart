import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/data/providers/auth_providers.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_bloc.dart';
import 'package:hostel_booking_frontend/data/repositories/auth_repository.dart';
import 'package:hostel_booking_frontend/data/providers/room_providers.dart';
import 'package:hostel_booking_frontend/logic/rooms_bloc/room_bloc.dart';
import 'package:hostel_booking_frontend/data/repositories/room_repository.dart';
import 'package:hostel_booking_frontend/presentation/auth/login_screen.dart';
import 'package:hostel_booking_frontend/logic/booking_bloc/booking_bloc.dart';
import 'package:hostel_booking_frontend/data/repositories/booking_repository.dart';
import 'package:hostel_booking_frontend/data/providers/booking_providers.dart';

void main() {
  runApp(HostelAllotment());
}

class HostelAllotment extends StatelessWidget {
  const HostelAllotment({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthRepository(AuthProvider()))),
        BlocProvider(create: (_) => RoomBloc(RoomRepository(RoomProvider()))),
        BlocProvider(
          create: (_) => BookingBloc(BookingRepository(BookingProviders())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hostel Allotment',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginScreen(),
      ),
    );
  }
}
