// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:homelyf_services/common/widgets/bottom_bar.dart';
import 'package:homelyf_services/common/widgets/liquid_loader.dart';
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
    _naviagtetohome();
  }

  _naviagtetohome() async {
    await Future.delayed(const Duration(milliseconds: 4000), () {});
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return FutureBuilder(
          // Use FutureBuilder to handle asynchronous operations
          future: authService.getUserData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, check for token availability
              if (Provider.of<UserProvider>(context).user.token.isNotEmpty) {
                // If token is available, show the homepage
                return Provider.of<UserProvider>(context).user.type == 'user'
                    ? const BottomBar()
                    : const AdminScreen();
              } else {
                // If token is not available, show the sign-in screen
                return const SignInScreen();
              }
            } else {
              // While the Future is still running, show a loader
              return const LiquidLoader();
            }
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            'assets/images/top_roller.png', // Replace with your image path
            fit: BoxFit.fill,
            height: 70,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topLeft,
          ),
          const Spacer(),
          Center(
            child: Image.asset(
              'assets/images/logo.png', // Replace with your image path
              fit: BoxFit.cover,
              height: 150,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'HomeLyf',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 99, 142, 203),
            ),
          ),
          const Text(
            'Services',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 99, 142, 203),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: const Color.fromARGB(255, 99, 142, 203),
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 100),
          ),
          const SizedBox(
            height: 18,
          ),
          const Text(
            'Where Comfort',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 99, 142, 203),
            ),
          ),
          const Text(
            'Meets Convenience!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 99, 142, 203),
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/images/bottom.png', // Replace with your image path
            fit: BoxFit.cover,
            height: 180,
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}
