import 'package:flutter/material.dart';
import 'constants.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.verdeOscuro,
    primary: AppColors.verdeOscuro,
    secondary: AppColors.cafeClaro,
    surface: AppColors.plomoClaro,
  ),
  scaffoldBackgroundColor: AppColors.plomoClaro,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.verdeOscuro,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 2,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.cafeClaro,
    foregroundColor: Colors.white,
  ),
  // 👇 Cambio clave: usamos CardThemeData en lugar de CardTheme
  cardTheme: const CardThemeData(
    color: AppColors.verdeClaro,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
    titleLarge: TextStyle(
      color: AppColors.verdeOscuro,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
);
