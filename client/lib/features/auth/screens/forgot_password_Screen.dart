import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:homelyf_services/common/widgets/custom_button.dart';
import 'package:homelyf_services/common/widgets/custom_textfield.dart';
import 'package:homelyf_services/constants/utils.dart';
import 'package:homelyf_services/features/auth/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _signUpFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _passwordObscured = true;
  bool _isOtpSent = false;
  bool _isEmailVerified = false;
  bool _isEmailValid = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
  }

  void forgotPassword() {
    authService.forgotPassword(
      context: context,
      email: _emailController.text,
      newPassword: _passwordController.text,
      otp: _otpController.text,
    );
  }

  void sendOtp() {
    authService.sendOTP(context, _emailController.text);
    setState(() {
      _isOtpSent = true; // Set the flag to indicate OTP has been sent
    });
  }

  void verifyEmail() {
    authService
        .verifyOTP(_emailController.text, _otpController.text)
        .then((result) {
      if (result) {
        // Email verification successful
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email Verified Successfully"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
        ));
        setState(() {
          _isEmailVerified = true;
          _isOtpSent = false;
        });
      } else {
        // Email verification failed
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email Verification Failed"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
        ));
      }
    });
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
                    // const Text(
                    //   'Welcome to HomeLyf',
                    //   style: TextStyle(
                    //     fontSize: 50,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
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
                            key: _signUpFormKey,
                            child: Column(
                              children: [
                                const Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    fontSize: 28,
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
                                  enabled: !_isEmailVerified,
                                  semanticsLabel: 'Buyers Email SignUp Input',
                                  customValidator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Email Address';
                                    }
                                    String emailPattern =
                                        r'^[a-z0-9\.]+@([a-z0-9]+\.)+[a-z0-9]{2,320}$';
                                    RegExp regExp = RegExp(emailPattern);

                                    if (!regExp.hasMatch(value)) {
                                      _isEmailValid = true;
                                      return 'Please enter a valid email address, only contain letters(a-z), number(0-9), and periods(.) are allowed.';
                                    }

                                    return null;
                                  },
                                  onChanged: (value) {
                                    String emailPattern =
                                        r'^[a-z0-9\.]+@([a-z0-9]+\.)+[a-z0-9]{2,320}$';
                                    RegExp regExp = RegExp(emailPattern);

                                    if (regExp.hasMatch(value)) {
                                      _isEmailValid = true;
                                      setState(() {
                                        _isOtpSent = false;
                                      });
                                    }
                                  },
                                ),
                                Visibility(
                                  visible: _isEmailValid,
                                  child: _isEmailVerified
                                      ? const Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Icon(
                                            Icons.verified_rounded,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: TextButton(
                                            child: Text(
                                              'Send OTP',
                                              style: TextStyle(
                                                color: _isOtpSent
                                                    ? Colors.grey
                                                    : Theme.of(context)
                                                        .primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            onPressed: () {
                                              if (_isEmailValid) {
                                                sendOtp();
                                              }
                                            },
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomTextField(
                                  controller: _otpController,
                                  labelText: 'OTP',
                                  hintText: 'Enter OTP',
                                  semanticsLabel: 'Buyers OTP SignUp Input',
                                  visible:
                                      _isOtpSent, // Only show OTP field if OTP has been sent
                                ),
                                Visibility(
                                  visible: _isOtpSent,
                                  child: TextButton(
                                    onPressed: _isOtpSent ? verifyEmail : null,
                                    child: Text(
                                      'Verify OTP',
                                      style: TextStyle(
                                        color: _isEmailVerified
                                            ? Colors
                                                .grey // Change the color if OTP has been sent
                                            : Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomTextField(
                                  visible: _isEmailVerified,
                                  controller: _passwordController,
                                  labelText: 'New Password',
                                  hintText: 'Enter New Password',
                                  semanticsLabel:
                                      'Buyers New Password SignUp Input',
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
                                      return 'Please Enter New Password';
                                    }
                                    String errorMessages = validatePassword(
                                        _passwordController.text);
                                    if (errorMessages.isNotEmpty) {
                                      return errorMessages;
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                CustomTextField(
                                  visible: _isEmailVerified,
                                  controller: _confirmPasswordController,
                                  labelText: 'Confirm Password',
                                  hintText: 'Enter Password',
                                  semanticsLabel:
                                      'Buyers Password SignUp Input',
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
                                    String errorMessages = validatePassword(
                                        _passwordController.text);
                                    if (errorMessages.isNotEmpty) {
                                      return errorMessages;
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomButton(
                                  visible: _isEmailVerified,
                                  text: 'Change Password',
                                  backgroundColor:
                                      const Color.fromARGB(255, 96, 173, 211),
                                  height: 60,
                                  elevation: 8,
                                  onTap: () {
                                    if (!_isEmailVerified) {
                                      return showSnackBar(context,
                                          'Please verify Email Address');
                                    } else if (_signUpFormKey.currentState!
                                        .validate()) {
                                      // Check if passwords match
                                      if (_passwordController.text !=
                                          _confirmPasswordController.text) {
                                        showSnackBar(context,
                                            'Passwords do not match. Please make sure both passwords are identical.');
                                      } else {
                                        // Passwords match, call forgotPassword function
                                        forgotPassword();
                                      }
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
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
