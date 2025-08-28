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
        final (user, token) = await repository.login(
          event.email,
          event.password,
        );
        emit(AuthSuccess(user: user, token: token));
      } catch (e) {
        String errorMessage = e.toString();
        if (errorMessage.contains("401") ||
            errorMessage.toLowerCase().contains("invalid credentials") ||
            errorMessage.toLowerCase().contains("user not found")) {
          emit(AuthFailure("Email or password did not match."));
        } else {
          emit(AuthFailure("An unexpected error occurred. Please try again."));
        }
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.registerUser(
          name: event.name,
          email: event.email,
          password: event.password,
          role: event.role,
          studentRank: event.studentRank,
        );
        emit(RegistrationSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<GetAllUsersRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final users = await repository.getAllUsers();
        emit(UsersLoadSuccess(users: users));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<GetUserByIdRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.getUserById(event.userId);
        emit(UserLoadSuccess(user: user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
