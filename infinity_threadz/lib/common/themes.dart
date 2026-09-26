import 'package:flutter/material.dart';
import 'package:infinity_threadz/common/color_helper.dart' as color_helper;

class AppThemes {
  static final primaryColor = color_helper.HexColor.fromHex('#0191DA');
  static const secondaryColor = Colors.black;
  static const lightTertiaryColor = Colors.white;
  static const darkTertiaryColor = Colors.black;
  static const lightScaffoldBackgroundColor = Colors.white;
  static const darkScaffoldBackgroundColor = Colors.black;

  // Text
  static const primaryText = 'Galada';
  static const secondaryText = 'Hind Guntur';

  static final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: secondaryText,
    scaffoldBackgroundColor: darkScaffoldBackgroundColor,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      onPrimary: lightTertiaryColor,
      secondary: secondaryColor,
      onSecondary: lightTertiaryColor,
    ),
    dividerColor: lightTertiaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: lightTertiaryColor,
      titleTextStyle: const TextStyle(
        fontFamily: primaryText,
        fontWeight: FontWeight.bold,
      ),
      toolbarTextStyle: const TextStyle(color: lightTertiaryColor),
      iconTheme: const IconThemeData(color: lightTertiaryColor),
      actionsIconTheme: const IconThemeData(color: lightTertiaryColor),
    ),
    iconTheme: const IconThemeData(color: lightTertiaryColor),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      filled: true,
      fillColor: darkScaffoldBackgroundColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        surfaceTintColor: WidgetStateProperty.all<Color>(Colors.transparent),
        backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
        foregroundColor: WidgetStateProperty.all<Color>(lightTertiaryColor),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: const CircleBorder(),
      backgroundColor: primaryColor,
    ),
    cardTheme: CardThemeData(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: color_helper.darken(Colors.grey, 85),
      surfaceTintColor: Colors.transparent,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: darkScaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme:
        const SnackBarThemeData(backgroundColor: lightScaffoldBackgroundColor),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: secondaryText,
    scaffoldBackgroundColor: lightScaffoldBackgroundColor,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      onPrimary: lightTertiaryColor,
      secondary: secondaryColor,
      onSecondary: lightTertiaryColor,
    ),
    dividerColor: darkTertiaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: lightTertiaryColor,
      titleTextStyle: const TextStyle(
        fontFamily: primaryText,
        fontWeight: FontWeight.bold,
        color: lightTertiaryColor,
      ),
      toolbarTextStyle: const TextStyle(color: lightTertiaryColor),
      iconTheme: const IconThemeData(color: lightTertiaryColor),
      actionsIconTheme: const IconThemeData(color: lightTertiaryColor),
    ),
    iconTheme: const IconThemeData(color: secondaryColor),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      filled: true,
      fillColor: lightScaffoldBackgroundColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        surfaceTintColor: WidgetStateProperty.all<Color>(Colors.transparent),
        backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
        foregroundColor: WidgetStateProperty.all<Color>(lightTertiaryColor),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: const CircleBorder(),
      backgroundColor: primaryColor,
    ),
    cardTheme: CardThemeData(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: lightScaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: lightScaffoldBackgroundColor,
    ),
    snackBarTheme:
        const SnackBarThemeData(backgroundColor: darkScaffoldBackgroundColor),
  );
}
