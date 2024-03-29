import 'package:flutter/material.dart';
import 'app_color.dart';

ThemeData appTheme() => ThemeData(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.themeColor,
        foregroundColor: AppColors.lightText1,
      ),
      useMaterial3: true,
      fontFamily: "NotoSansJP",
      snackBarTheme: const SnackBarThemeData(showCloseIcon: true),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: DividerThemeData(color: AppColors.themeColor.shade50),
      dividerColor: Colors.brown.shade100,
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 22,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          foregroundColor: Colors.black,
        ),
      ),
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.themeColor).copyWith(secondary: AppColors.accentColor),
    );
