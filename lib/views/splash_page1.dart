import 'package:flutter/material.dart';
import '../controllers/splash_controller.dart';
import '../widgets/background_decoration_painter.dart';

/// Halaman splash screen pertama
class SplashPage1 extends StatelessWidget {
  final SplashController controller;

  const SplashPage1({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Dekorasi background
          Positioned.fill(
            child: CustomPaint(painter: BackgroundDecorationPainter()),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo aplikasi - digeser ke kanan dengan Align
                        Align(
                          alignment: Alignment(
                            1.4,
                            0,
                          ), // Geser ke kanan (nilai positif)
                          child: Image.asset(
                            'assets/learnify_logo.png',
                            width:
                                screenSize.width * 0.7, // 70% dari lebar layar
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: screenSize.width * 0.7,
                                height: 100,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Text(
                                    'Logo tidak tersedia',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Quotes
                        Text(
                          '"The roots of education are bitter, but the fruit is sweet"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tagline aplikasi - dipindahkan tepat di atas tombol
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      const Text(
                        'Platform belajar online terbaik untuk meningkatkan keterampilan Anda',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ), // Jarak antara tagline dan tombol
                    ],
                  ),
                ),

                // Tombol mulai
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 30,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.nextPage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5667FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Lanjutkan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
