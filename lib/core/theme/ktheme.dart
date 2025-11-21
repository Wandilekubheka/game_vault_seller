import 'package:flutter/material.dart';
import 'package:game_vault_seller/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Ktheme {
  static final appTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Color(AppColors.background),

    primaryColor: Color(AppColors.primary),
    colorScheme: ColorScheme.light(
      primary: Color(AppColors.primary),
      secondary: Color(AppColors.info),
      surface: Color(AppColors.border),
      onPrimary: Color(AppColors.textPrimary),
      onSecondary: Color(AppColors.textPrimary),
      onSurface: Color(AppColors.textPrimary),
      error: Color(AppColors.error),
      onError: Color(AppColors.textPrimary),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Color(AppColors.background),
      iconTheme: IconThemeData(color: Color(AppColors.textPrimary)),
      titleTextStyle: GoogleFonts.openSans(
        color: Color(AppColors.textPrimary),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(AppColors.primary),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
      ),
    ),
    iconTheme: IconThemeData(color: Color(AppColors.border)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(AppColors.background),
      hintStyle: GoogleFonts.openSans(
        color: Color(AppColors.textSecondary),
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 16.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(64),
        borderSide: BorderSide(color: Color(AppColors.border), width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(64),
        borderSide: BorderSide(color: Color(AppColors.border), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(64),
        borderSide: BorderSide(color: Color(AppColors.primary), width: 2.0),
      ),
    ),
    // text styles
    textTheme: TextTheme(
      titleLarge: GoogleFonts.openSans(
        color: Color(AppColors.textPrimary),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.openSans(
        color: Color(AppColors.textPrimary),
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.openSans(
        color: Color(AppColors.textPrimary),
        fontSize: 14,
      ),
      bodySmall: GoogleFonts.openSans(
        color: Color(AppColors.primary),
        fontSize: 12,
      ),
      labelLarge: GoogleFonts.openSans(
        color: Color(AppColors.textPrimary),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: GoogleFonts.openSans(
        color: Color(AppColors.textSecondary),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: GoogleFonts.openSans(
        color: Color(AppColors.primary),
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: GoogleFonts.openSans(
        color: Color(AppColors.textPrimary),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Color(AppColors.primary),
        foregroundColor: Color(AppColors.textPrimary),
        textStyle: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(AppColors.error),
      contentTextStyle: GoogleFonts.openSans(color: Colors.white, fontSize: 14),
    ),
  );
}
