import 'package:flutter/material.dart';
import 'package:siderapredict/ui/dashboard_relatorios.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToScanner();
  }

  Future<void> _navigateToScanner() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const DashboardRelatoriosPage()),
    );
  }

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
