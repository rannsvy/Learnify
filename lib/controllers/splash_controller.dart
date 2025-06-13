import 'package:flutter/material.dart';

/// Controller untuk mengelola logika splash screen
class SplashController {
  /// PageController untuk mengontrol transisi antar halaman splash
  final PageController pageController = PageController(initialPage: 0);
  
  /// Inisialisasi controller
  void initialize(BuildContext context) {
    // Tidak ada timer otomatis, menunggu interaksi user
  }
  
  /// Navigasi ke halaman berikutnya
  void nextPage() {
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  /// Navigasi ke halaman sign in
  void navigateToSignIn(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/sign-in');
  }
  
  /// Membersihkan resources saat controller tidak digunakan lagi
  void dispose() {
    pageController.dispose();
  }
}
