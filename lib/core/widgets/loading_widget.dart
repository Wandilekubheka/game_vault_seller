import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_vault_seller/core/theme/app_colors.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    double scale = 1.0;

    Timer.periodic(const Duration(seconds: 600), (timer) {
      scale = scale == 1.0 ? 2 : 1.0;
    });
    return Scaffold(
      backgroundColor: Color(AppColors.primary),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSize(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
