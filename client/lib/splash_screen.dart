import 'package:flutter/material.dart';
import 'package:homelyf_services/common/widgets/bottom_bar.dart';
import 'package:homelyf_services/features/admin/screens/admin_screen.dart';
import 'package:homelyf_services/features/auth/screens/signin_screen.dart';
import 'package:homelyf_services/features/auth/services/auth_service.dart';
import 'package:homelyf_services/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    // Simulate some initialization or loading process
    Future.delayed(const Duration(seconds: 2), () {
      // Check user authentication status or any other initialization logic
      bool isUserAuthenticated =
          Provider.of<UserProvider>(context, listen: false)
              .user
              .token
              .isNotEmpty;

      if (isUserAuthenticated) {
        // If user is authenticated, redirect based on user type
        String userType =
            Provider.of<UserProvider>(context, listen: false).user.type;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                userType == 'user' ? const BottomBar() : const AdminScreen(),
          ),
        );
      } else {
        // If user is not authenticated, go to sign in screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
        );
      }
    });

    // Splash screen UI
    return const Scaffold(
      body: Center(
        child: FlutterLogo(
          size: 200,
        ),
      ),
    );
  }
}
