import 'package:flutter/material.dart';
import 'package:todo_app/config/colors.dart';

ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: appPurple,
    primaryContainer: lightPurple,
    secondaryContainer: lighterPurple,
  ),
  primarySwatch: appPurple,
  primaryColor: appPurple,
  brightness: Brightness.light,
  listTileTheme: ListTileThemeData(
    titleTextStyle: const TextStyle(
      color: appPurple,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    subtitleTextStyle: const TextStyle(
      color: Colors.black38,
    ),
    minTileHeight: 80,
    contentPadding: const EdgeInsets.only(
      left: 10,
      top: 6,
      bottom: 6,
    ),
    iconColor: appPurple,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    tileColor: lighterPurple,
  ),
  switchTheme: const SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(appPurple),
    thumbIcon: WidgetStatePropertyAll(
      Icon(
        Icons.light_mode_rounded,
      ),
    ),
    trackColor: WidgetStatePropertyAll(lightPurple),
    trackOutlineColor: WidgetStatePropertyAll(lightPurple),
  ),
  scaffoldBackgroundColor: lightPurple,
  appBarTheme: const AppBarTheme(
    toolbarHeight: 90,
    backgroundColor: appPurple,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 27,
    ),
    titleMedium: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    labelSmall: TextStyle(
      color: appPurple,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appPurple,
    foregroundColor: Colors.white,
  ),
  tabBarTheme: const TabBarTheme(
    dividerColor: Colors.transparent,
    indicatorColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    labelColor: appPurple,
    unselectedLabelColor: darkGray,
    labelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  iconTheme: const IconThemeData(
    color: darkGray,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(
      color: Colors.grey,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: appPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      minimumSize: Size(130, 55),
    ),
  ),
  cardTheme: const CardTheme(
    color: lighterPurple,
  ),
);

ThemeData appDarkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    primaryContainer: darkGray,
    secondaryContainer: Colors.black,
  ),
  primarySwatch: appPurple,
  primaryColor: darkGray,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkGray,
  switchTheme: const SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(appPurple),
    thumbIcon: WidgetStatePropertyAll(
      Icon(
        Icons.dark_mode_rounded,
      ),
    ),
    trackColor: WidgetStatePropertyAll(darkGray),
    trackOutlineColor: WidgetStatePropertyAll(darkGray),
  ),
  listTileTheme: ListTileThemeData(
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    subtitleTextStyle: const TextStyle(
      color: Colors.grey,
    ),
    minTileHeight: 80,
    contentPadding: const EdgeInsets.only(
      left: 10,
      top: 6,
      bottom: 6,
    ),
    iconColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    tileColor: const Color(0xFF121212),
  ),
  appBarTheme: const AppBarTheme(
    toolbarHeight: 90,
    backgroundColor: Color(0xFF121212),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: appPurple,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 27,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    labelSmall: TextStyle(
      color: appPurple,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appPurple,
    foregroundColor: darkGray,
  ),
  tabBarTheme: const TabBarTheme(
    dividerColor: Colors.transparent,
    indicatorColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    labelColor: Colors.white,
    unselectedLabelColor: lightGray,
    labelStyle: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      color: Colors.grey,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: appPurple,
      foregroundColor: darkGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      minimumSize: Size(130, 55),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(
      color: lightGray,
    ),
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF121212),
  ),
);
