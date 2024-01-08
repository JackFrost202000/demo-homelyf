// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:homelyf_services/common/widgets/bottom_bar.dart';
import 'package:homelyf_services/constants/error_handling.dart';
import 'package:homelyf_services/constants/global_variables.dart';
import 'package:homelyf_services/constants/utils.dart';
import 'package:homelyf_services/features/admin/screens/admin_screen.dart';
import 'package:homelyf_services/features/auth/screens/signin_screen.dart';
import 'package:homelyf_services/models/user.dart';
import 'package:homelyf_services/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> sendOTP(
    BuildContext context,
    String email,
    String mobile,
  ) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/sendEmail-otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'email': email, 'mobile': mobile}),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data != null) {
        showSnackBar(context, 'OTP sent successfully!');
        return true;
      } else if (res.statusCode == 400 && data != null) {
        showSnackBar(context,
            'User with same email or mobile no. already exists!\nTry using different email or mobile no.');
        return false;
      } else {
        showSnackBar(context, 'Failed to send OTP.');
        return false;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> sendOTPForgotPassword(
    BuildContext context,
    String email,
    String mobile,
  ) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/sendEmail-forgotPassword-otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'email': email, 'mobile': mobile}),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data != null) {
        showSnackBar(context, 'OTP sent successfully!');
        return true;
      } else {
        showSnackBar(context, 'Failed to send OTP.');
        return false;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> verifyOTP(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/api/verify-otp'),
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // OTP verification successful
        return true;
      } else {
        // OTP verification failed
        return false;
      }
    } catch (error) {
      print(error);
      // Handle network or other errors
      return false;
    }
  }

  // sign up user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String mobile,
    required String otp,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        mobile: mobile,
        address: '',
        type: '',
        otp: otp,
        token: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          showSnackBar(
            context,
            "Welcome, ${user.name}! Your home, our priority. Let's get things done!",
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
            (route) => false,
          );
        },
      );
    } on SocketException catch (e) {
      // Handle SocketException (connection error)
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // No internet connection
        showSnackBar(context, 'No internet connection.');
      } else {
        // Connection error (other than no internet)
        showSnackBar(context, 'Connection error: ${e.message}');
      }
    } on http.ClientException catch (e) {
      // Handle DioError (Dio-specific exception)
      showSnackBar(context, 'HTTP request failed: ${e.message}');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // sign in user
  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          if (prefs.getString('x-auth-token') != null &&
              prefs.getString('x-auth-token')!.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Provider.of<UserProvider>(context, listen: false)
                                .user
                                .type ==
                            'user'
                        ? const BottomBar()
                        : const AdminScreen(),
              ),
            );
          }
        },
      );
    } on SocketException catch (e) {
      // Handle SocketException (connection error)
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // No internet connection
        showSnackBar(context, 'No internet connection.');
      } else {
        // Connection error (other than no internet)
        showSnackBar(context, 'Connection error: ${e.message}');
      }
    } on http.ClientException catch (e) {
      // Handle DioError (Dio-specific exception)
      showSnackBar(context, 'HTTP request failed: ${e.message}');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  Future<void> getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> forgotPassword({
    required BuildContext context,
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/forgotpassword'),
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
          'otp': otp,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          showSnackBar(context, 'Password Successfully Changed');
          Navigator.pushNamedAndRemoveUntil(
            context,
            SignInScreen.routeName,
            (route) => false,
          );
        },
      );
    } on SocketException catch (e) {
      // Handle SocketException (connection error)
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // No internet connection
        showSnackBar(context, 'No internet connection.');
      } else {
        // Connection error (other than no internet)
        showSnackBar(context, 'Connection error: ${e.message}');
      }
    } on http.ClientException catch (e) {
      // Handle DioError (Dio-specific exception)
      showSnackBar(context, 'HTTP request failed: ${e.message}');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
