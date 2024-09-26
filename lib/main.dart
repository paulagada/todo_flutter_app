import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/config/app_theme.dart';
import 'package:todo_app/config/theme_provider.dart';
import 'package:todo_app/screens/AuthScreens/auth_navigation.dart';
import 'package:todo_app/screens/navigation_page.dart';
import 'package:todo_app/services/auth_service.dart';

void main() {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          ThemeProvider themeProvider = context.watch<ThemeProvider>();
          bool loggedIn = context.read<AuthProvider>().authenticated;
          return MaterialApp(
            title: 'Flutter Demo',
            theme: appTheme,
            darkTheme: appDarkTheme,
            themeMode: themeProvider.themeMode,
            routes: {
              '/': (context) => loggedIn
                  ? const NavigationPage()
                  : const AuthNavigation(),
              AuthNavigation.path: (context) => const AuthNavigation(),
              NavigationPage.path: (context) => const NavigationPage(),
            },
          );
        }
      ),
    );
  }
}
