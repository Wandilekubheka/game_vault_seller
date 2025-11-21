import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_vault_seller/core/data/model/firebase_expection.dart';
import 'package:game_vault_seller/core/data/model/user_model.dart';
import 'package:game_vault_seller/features/auth/domain/reporitory.dart';

import 'dart:developer';

import 'package:game_vault_seller/features/auth/screens/blocs/auth_state.dart';

class AuthCupit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();
  AuthCupit(this.authRepository) : super(InitialAuthState()) {
    checkAuthState();
  }

  void checkAuthState() async {
    authStateChanges.listen((user) {
      log(
        'Auth state changed: ${user != null ? user.email : 'User signed out'}',
      );
      if (user == null) {
        emit(UnauthenticatedState());
      }
      // }
      else {
        authRepository
            .getCurrentUser()
            .then((appUser) async {
              emit(AuthenticatedWithUserState(appUser));
            })
            .catchError((e) {
              if (e is FirebaseExceptionHandler) {
                emit(ErrorAuthState(e.message));
              } else if (e is FormatException) {
                if (e.message.contains('not found')) {
                  emit(AuthenticatedState());
                }
              } else {
                emit(ErrorAuthState('An unknown error occurred'));
                log(e.toString());
              }
            });
      }
    });
    log(state.runtimeType.toString());
  }

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
    } on FirebaseExceptionHandler catch (e) {
      emit(ErrorAuthState(e.message));
    }
  }

  Future<void> deleteAccount() async {
    try {
      if (state is AuthenticatedWithUserState) {
        await authRepository.deleteUserData();
      } else {
        emit(ErrorAuthState('No authenticated user to delete'));
      }
    } on FirebaseExceptionHandler catch (e) {
      emit(ErrorAuthState(e.message));
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
    String? username,
  }) async {
    final currentState = state;
    emit(LoadingAuthState());
    if (currentState is AuthenticatedState && username != null) {
      try {
        await authRepository.createUserData(username);
        final user = await authRepository.getCurrentUser();
        emit(AuthenticatedWithUserState(user));
        return;
      } on FirebaseExceptionHandler catch (_) {
        await clearError();
        await signOut();
        return;
      }
    }
    try {
      await authRepository.signInWithEmail(email, password);
      if (state is LoadingAuthState) {
        final currentUser = await authRepository.getCurrentUser();
        emit(AuthenticatedWithUserState(currentUser));
      }
    } on FirebaseExceptionHandler catch (e) {
      emit(ErrorAuthState(e.message));
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await authRepository.sendEmailVerification();
    } on FirebaseExceptionHandler catch (e) {
      emit(ErrorAuthState(e.message));
    }
  }

  // New method to refresh user state when country changes
  void refreshUserState() async {
    try {
      final currentUser = await authRepository.getCurrentUser();
      emit(AuthenticatedWithUserState(currentUser));
    } on FirebaseExceptionHandler catch (e) {
      emit(ErrorAuthState(e.message));
    } on FormatException catch (e) {
      emit(ErrorAuthState(e.message));
    }
  }

  Future<void> clearError() async {
    try {
      final currentUser = await authRepository.getCurrentUser();
      log(currentUser.email);
      emit(AuthenticatedWithUserState(currentUser));
    } on FirebaseExceptionHandler catch (e) {
      log(e.message);
      emit(ErrorAuthState(e.message));
    } on FormatException catch (e) {
      log(e.message);
      emit(ErrorAuthState(e.message));
    }
  }

  Future<void> updateUserData(UserModel updatedUser) async {
    try {
      if (state is AuthenticatedWithUserState) {
        await authRepository.updateUserData(updatedUser);
        emit(AuthenticatedWithUserState(updatedUser));
      } else {
        emit(ErrorAuthState('No authenticated user to update'));
      }
    } on FirebaseExceptionHandler catch (e) {
      emit(ErrorAuthState(e.message));
    }
  }
}
