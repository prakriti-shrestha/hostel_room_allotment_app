import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;
  final int? studentRank;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.studentRank,
  });
}

class GetAllUsersRequested extends AuthEvent {
  final String token;

  const GetAllUsersRequested({required this.token});
}

class GetUserByIdRequested extends AuthEvent {
  final int userId;
  final String token;

  const GetUserByIdRequested({required this.userId, required this.token});
}
