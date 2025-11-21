import 'package:game_vault_seller/core/data/model/user_model.dart';

class AuthState {}

class AuthenticatedState extends AuthState {}

class InitialAuthState extends AuthState {}

class AuthenticatedWithUserState extends AuthenticatedState {
  final UserModel user;
  AuthenticatedWithUserState(this.user);
}

class UnauthenticatedState extends AuthState {}

class ErrorAuthState extends AuthState {
  final String message;
  ErrorAuthState(this.message);
}

class LoadingAuthState extends AuthState {}

class NeedVerificationAuthState extends AuthenticatedState {
  final String message;
  NeedVerificationAuthState(this.message);
}
