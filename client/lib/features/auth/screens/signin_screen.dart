import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:homelyf_services/common/widgets/custom_button.dart';
import 'package:homelyf_services/common/widgets/custom_textfield.dart';
import 'package:homelyf_services/features/auth/screens/forgot_password_Screen.dart';
import 'package:homelyf_services/features/auth/screens/signup_screen.dart';
import 'package:homelyf_services/features/auth/services/auth_service.dart';

enum Auth { signin, signup }

class SignInScreen extends StatefulWidget {
  static const String routeName = '/signin-screen';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _passwordObscured = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          // Image.asset(
          //   'assets/images/hello.jpg', // Replace with your image path
          //   fit: BoxFit.cover,
          //   height: MediaQuery.of(context).size.height,
          // ),
          SafeArea(
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Form(
                            key: _signInFormKey,
                            child: Column(
                              children: [
                                const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 145, 203),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextField(
                                  controller: _emailController,
                                  labelText: 'Email Address',
                                  hintText: 'Enter Email Address',
                                  semanticsLabel: 'Buyers Email SignIn Input',
                                  customValidator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Email Address';
                                    }
                                    // String emailPattern =
                                    //     r'^[a-z0-9\.]+@([a-z0-9]+\.)+[a-z0-9]{2,320}$';
                                    // RegExp regExp = RegExp(emailPattern);

                                    // if (!regExp.hasMatch(value)) {
                                    //   return 'Please enter a valid email address, only contain letters(a-z), number(0-9), and periods(.) are allowed.';
                                    // }

                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomTextField(
                                  controller: _passwordController,
                                  labelText: 'Password',
                                  hintText: 'Enter Password',
                                  semanticsLabel:
                                      'Buyers Password SignIn Input',
                                  obscureText: _passwordObscured,
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: IconButton(
                                      icon: Icon(
                                        _passwordObscured
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color:
                                            const Color.fromARGB(136, 0, 0, 0),
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordObscured =
                                              !_passwordObscured;
                                        });
                                      },
                                    ),
                                  ),
                                  customValidator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Password';
                                    }
                                    // String errorMessages = validatePassword(
                                    //     _passwordController.text);
                                    // if (errorMessages.isNotEmpty) {
                                    //   return errorMessages;
                                    // }

                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 12),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const ForgotPasswordScreen();
                                      }));
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 8),
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomButton(
                                  text: 'Sign In',
                                  backgroundColor:
                                      const Color.fromARGB(255, 96, 173, 211),
                                  height: 60,
                                  elevation: 8,
                                  onTap: () {
                                    if (_signInFormKey.currentState!
                                        .validate()) {
                                      signInUser();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have An Account?",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 95, 94, 94),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const SignUpScreen();
                                        }));
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 4),
                                        ),
                                      ),
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 96, 173, 211),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              Color.fromARGB(255, 96, 173, 211),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // const Text(
                                //   "Or",
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.w600,
                                //     color: Color.fromARGB(255, 95, 94, 94),
                                //   ),
                                // ),
                                // const Text(
                                //   "Sign up with social account",
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.w600,
                                //     color: Color.fromARGB(255, 95, 94, 94),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String validatePassword(String password) {
    List<String> errors = [];

    // Check for minimum length
    if (password.length < 8) {
      errors.add("at least 8 characters");
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add("at least one uppercase letter");
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      errors.add("at least one lowercase letter");
    }

    // Check for at least one digit
    if (!RegExp(r'\d').hasMatch(password)) {
      errors.add("at least one digit");
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*()-_+=<>?/[\]{}|]').hasMatch(password)) {
      errors.add("at least one special character");
    }

    if (password.contains(' ')) {
      errors.add("no spaces");
    }

    if (password.length > 14) {
      errors.add("at most 14 characters");
    }

    // Concatenate error messages
    String errorMessages = errors.join(', ');

    // Return result
    if (errorMessages.isNotEmpty) {
      return "Password must contain $errorMessages.";
    }
    return '';
  }
}
