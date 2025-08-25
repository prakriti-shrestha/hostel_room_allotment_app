import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/data/repositories/auth_repository.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_event.dart';
import 'package:hostel_booking_frontend/logic/auth_bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.login(event.email, event.password);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
