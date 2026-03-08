import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDE1212),
              Color(0xFFFFFFFF),
            ],
            stops: [0.3, 0.8],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 4),
              Image.asset(
                'assets/soufer.png',
                width: 300,
                fit: BoxFit.contain,
              ),
              const Spacer(flex: 6),
            ],
          ),
        ),
      ),
    );
  }
}
