import 'package:flutter/material.dart';

/// Widget untuk menampilkan logo Google yang terbaru
class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({
    super.key,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: GoogleLogoPainter(),
    );
  }
}

/// Custom painter untuk logo Google
class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    
    // Warna-warna logo Google
    final Paint bluePaint = Paint()..color = const Color(0xFF4285F4);
    final Paint redPaint = Paint()..color = const Color(0xFFEA4335);
    final Paint yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final Paint greenPaint = Paint()..color = const Color(0xFF34A853);
    
    // Menggambar bagian merah (kiri atas)
    final Path redPath = Path()
      ..moveTo(width * 0.25, height * 0.25)
      ..lineTo(width * 0.5, height * 0.5)
      ..lineTo(width * 0.25, height * 0.75)
      ..lineTo(0, height * 0.5)
      ..close();
    canvas.drawPath(redPath, redPaint);
    
    // Menggambar bagian hijau (kanan bawah)
    final Path greenPath = Path()
      ..moveTo(width * 0.5, height * 0.5)
      ..lineTo(width * 0.75, height * 0.25)
      ..lineTo(width, height * 0.5)
      ..lineTo(width * 0.75, height * 0.75)
      ..close();
    canvas.drawPath(greenPath, greenPaint);
    
    // Menggambar bagian kuning (kiri bawah)
    final Path yellowPath = Path()
      ..moveTo(width * 0.25, height * 0.75)
      ..lineTo(width * 0.5, height * 0.5)
      ..lineTo(width * 0.75, height * 0.75)
      ..lineTo(width * 0.5, height)
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);
    
    // Menggambar bagian biru (kanan atas)
    final Path bluePath = Path()
      ..moveTo(width * 0.25, height * 0.25)
      ..lineTo(width * 0.5, 0)
      ..lineTo(width * 0.75, height * 0.25)
      ..lineTo(width * 0.5, height * 0.5)
      ..close();
    canvas.drawPath(bluePath, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget untuk menampilkan logo X (Twitter)
class XLogo extends StatelessWidget {
  final double size;
  final Color color;

  const XLogo({
    super.key,
    this.size = 24.0,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: XLogoPainter(color: color),
    );
  }
}

/// Custom painter untuk logo X (Twitter)
class XLogoPainter extends CustomPainter {
  final Color color;

  XLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = width * 0.08
      ..strokeCap = StrokeCap.round;
    
    // Menggambar X
    // Garis diagonal dari kiri atas ke kanan bawah
    canvas.drawLine(
      Offset(width * 0.1, height * 0.1),
      Offset(width * 0.9, height * 0.9),
      paint,
    );
    
    // Garis diagonal dari kanan atas ke kiri bawah
    canvas.drawLine(
      Offset(width * 0.9, height * 0.1),
      Offset(width * 0.1, height * 0.9),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
