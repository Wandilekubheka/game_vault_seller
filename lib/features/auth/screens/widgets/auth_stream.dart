import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_vault_seller/core/widgets/loading_widget.dart';
import 'package:game_vault_seller/features/auth/screens/auth_screen.dart';
import 'package:game_vault_seller/features/auth/screens/blocs/auth_cupit.dart';
import 'package:game_vault_seller/features/auth/screens/blocs/auth_state.dart';
import 'package:game_vault_seller/features/auth/screens/onboarding_page.dart';
import 'package:game_vault_seller/features/dashboard/screens/homescreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthStream extends StatefulWidget {
  const AuthStream({super.key});

  @override
  State<AuthStream> createState() => _AuthStreamState();
}

class _AuthStreamState extends State<AuthStream> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCupit, AuthState>(
      builder: (context, state) {
        log(' state is ${state.runtimeType.toString()}');
        if (state is AuthenticatedWithUserState) {
          return const Homescreen();
        } else if (state is UnauthenticatedState || state is ErrorAuthState) {
          return FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              } else {
                final prefs = snapshot.data;
                final userIsOnboardingComplete =
                    prefs?.getBool('onboarding_complete') ?? false;
                return userIsOnboardingComplete
                    ? const AuthScreen()
                    : const OnboardingPage();
              }
            },
          );
        } else if (state is NeedVerificationAuthState ||
            state is AuthenticatedState) {
          return const AuthScreen();
        } else {
          return const LoadingWidget();
        }
      },
    );
  }
}
