import 'package:flutter/material.dart';
import 'package:todo_app/config/colors.dart';
import 'package:todo_app/screens/AuthScreens/email_verification.dart';
import 'package:todo_app/screens/AuthScreens/login.dart';
import 'package:todo_app/screens/AuthScreens/password_reset.dart';
import 'package:todo_app/screens/AuthScreens/register.dart';

class AuthNavigation extends StatefulWidget {
  static const String path = "auth_nav";

  const AuthNavigation({super.key});

  @override
  State<AuthNavigation> createState() => _AuthNavigationState();
}

class _AuthNavigationState extends State<AuthNavigation>
    with TickerProviderStateMixin {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  appPurple,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
              ),
            ),
          ),
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              Login(
                pageController: pageController,
              ),
              Register(
                pageController: pageController,
              ),
              EmailVerification(
                pageController: pageController,
              ),
              PasswordReset(
                pageController: pageController,
              )
            ],
          )
        ],
      ),
    );
  }
}
