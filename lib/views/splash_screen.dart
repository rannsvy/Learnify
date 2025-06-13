import 'package:flutter/material.dart';
import '../controllers/splash_controller.dart';
import 'splash_page1.dart';
import 'splash_page2.dart';

/// Widget utama untuk menampilkan splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController _controller = SplashController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller saat widget dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initialize(context);
    });
  }

  @override
  void dispose() {
    // Bersihkan resources saat widget dihapus
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller.pageController,
        physics: const NeverScrollableScrollPhysics(), // Mencegah scroll manual
        children: [
          SplashPage1(controller: _controller),
          SplashPage2(controller: _controller),
        ],
      ),
    );
  }
}
