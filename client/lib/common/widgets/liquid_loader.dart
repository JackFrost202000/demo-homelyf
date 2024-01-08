import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LiquidLoader extends StatelessWidget {
  const LiquidLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 213, 222, 239),
      body: Center(
        child: SpinKitSpinningLines(
          color: Color.fromARGB(255, 68, 0, 215),
          size: 100.0,
          lineWidth: 5,
          duration: Duration(seconds: 2),
        ),
      ),
    );
  }
}
