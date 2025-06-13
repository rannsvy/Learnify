import 'package:flutter/material.dart';

/// Widget ilustrasi untuk splash screen kedua
/// dibuat langsung dengan Flutter tanpa memerlukan asset gambar
class SplashIllustration extends StatelessWidget {
  final double width;
  final Color primaryColor;
  final Color secondaryColor;

  const SplashIllustration({
    Key? key,
    required this.width,
    this.primaryColor = const Color(0xFF5667FD),
    this.secondaryColor = const Color(0xFF8E9BFE),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 0.8,
      child: CustomPaint(
        painter: SplashIllustrationPainter(
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
      ),
    );
  }
}

/// Custom painter untuk menggambar ilustrasi splash screen
class SplashIllustrationPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  SplashIllustrationPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Gambar latar belakang
    final bgPaint = Paint()
      ..color = secondaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    final bgPath = Path();
    bgPath.addOval(Rect.fromCenter(
      center: Offset(center.dx, center.dy - size.height * 0.1),
      width: size.width * 0.8,
      height: size.height * 0.8,
    ));
    canvas.drawPath(bgPath, bgPaint);
    
    // Gambar karakter (orang)
    _drawPerson(canvas, size);
    
    // Gambar buku dan perangkat
    _drawDevices(canvas, size);
  }
  
  void _drawPerson(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Kepala
    final headPaint = Paint()
      ..color = const Color(0xFFFFC0CB)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx, center.dy - size.height * 0.15),
      size.width * 0.1,
      headPaint,
    );
    
    // Badan
    final bodyPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    
    final bodyPath = Path();
    bodyPath.moveTo(center.dx - size.width * 0.1, center.dy - size.height * 0.05);
    bodyPath.lineTo(center.dx + size.width * 0.1, center.dy - size.height * 0.05);
    bodyPath.lineTo(center.dx + size.width * 0.08, center.dy + size.height * 0.2);
    bodyPath.lineTo(center.dx - size.width * 0.08, center.dy + size.height * 0.2);
    bodyPath.close();
    canvas.drawPath(bodyPath, bodyPaint);
    
    // Tangan
    final armPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    
    // Tangan kiri
    final leftArmPath = Path();
    leftArmPath.moveTo(center.dx - size.width * 0.1, center.dy - size.height * 0.05);
    leftArmPath.lineTo(center.dx - size.width * 0.25, center.dy);
    leftArmPath.lineTo(center.dx - size.width * 0.23, center.dy + size.height * 0.05);
    leftArmPath.lineTo(center.dx - size.width * 0.08, center.dy);
    leftArmPath.close();
    canvas.drawPath(leftArmPath, armPaint);
    
    // Tangan kanan
    final rightArmPath = Path();
    rightArmPath.moveTo(center.dx + size.width * 0.1, center.dy - size.height * 0.05);
    rightArmPath.lineTo(center.dx + size.width * 0.25, center.dy);
    rightArmPath.lineTo(center.dx + size.width * 0.23, center.dy + size.height * 0.05);
    rightArmPath.lineTo(center.dx + size.width * 0.08, center.dy);
    rightArmPath.close();
    canvas.drawPath(rightArmPath, armPaint);
  }
  
  void _drawDevices(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Laptop
    final laptopPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.fill;
    
    final laptopPath = Path();
    laptopPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - size.width * 0.2, center.dy - size.height * 0.1),
        width: size.width * 0.2,
        height: size.width * 0.15,
      ),
      Radius.circular(size.width * 0.01),
    ));
    canvas.drawPath(laptopPath, laptopPaint);
    
    // Layar laptop
    final screenPaint = Paint()
      ..color = Colors.lightBlue.shade100
      ..style = PaintingStyle.fill;
    
    final screenPath = Path();
    screenPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - size.width * 0.2, center.dy - size.height * 0.1),
        width: size.width * 0.18,
        height: size.width * 0.13,
      ),
      Radius.circular(size.width * 0.005),
    ));
    canvas.drawPath(screenPath, screenPaint);
    
    // Buku
    final bookPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;
    
    final bookPath = Path();
    bookPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + size.width * 0.2, center.dy - size.height * 0.05),
        width: size.width * 0.15,
        height: size.width * 0.2,
      ),
      Radius.circular(size.width * 0.01),
    ));
    canvas.drawPath(bookPath, bookPaint);
    
    // Garis-garis buku
    final linesPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.005;
    
    for (int i = 1; i <= 4; i++) {
      final y = center.dy - size.height * 0.05 - size.width * 0.1 + (size.width * 0.2 / 5) * i;
      canvas.drawLine(
        Offset(center.dx + size.width * 0.2 - size.width * 0.07, y),
        Offset(center.dx + size.width * 0.2 + size.width * 0.07, y),
        linesPaint,
      );
    }
    
    // Smartphone
    final phonePaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.fill;
    
    final phonePath = Path();
    phonePath.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + size.height * 0.15),
        width: size.width * 0.1,
        height: size.width * 0.2,
      ),
      Radius.circular(size.width * 0.01),
    ));
    canvas.drawPath(phonePath, phonePaint);
    
    // Layar smartphone
    final phoneScreenPaint = Paint()
      ..color = Colors.lightBlue.shade100
      ..style = PaintingStyle.fill;
    
    final phoneScreenPath = Path();
    phoneScreenPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + size.height * 0.15),
        width: size.width * 0.09,
        height: size.width * 0.18,
      ),
      Radius.circular(size.width * 0.005),
    ));
    canvas.drawPath(phoneScreenPath, phoneScreenPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
