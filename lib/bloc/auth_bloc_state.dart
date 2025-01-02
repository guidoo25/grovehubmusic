part of 'auth_bloc_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
