import 'package:equatable/equatable.dart';
import 'package:hostel_booking_frontend/data/models/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  final String token;
  const AuthSuccess({required this.user, required this.token});
}

class UsersLoadSuccess extends AuthState {
  final List<User> users;

  const UsersLoadSuccess({required this.users});
}

class UserLoadSuccess extends AuthState {
  final User user;

  const UserLoadSuccess({required this.user});
}

class RegistrationSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
}
