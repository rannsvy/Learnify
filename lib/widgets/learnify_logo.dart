import 'package:flutter/material.dart';

/// Widget logo Learnify yang dibuat langsung dengan Flutter
/// tanpa memerlukan asset gambar
class LearnifyLogo extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  const LearnifyLogo({
    Key? key,
    this.size = 150,
    this.primaryColor = const Color(0xFF5667FD),
    this.secondaryColor = const Color(0xFF8E9BFE),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: LearnifyLogoPainter(
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
      ),
    );
  }
}

/// Custom painter untuk menggambar logo Learnify
class LearnifyLogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  LearnifyLogoPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Gambar lingkaran luar
    final outerCirclePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, outerCirclePaint);
    
    // Gambar lingkaran dalam
    final innerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.8, innerCirclePaint);
    
    // Gambar ikon buku
    final bookPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    
    // Buku bagian kiri
    final bookLeftPath = Path();
    bookLeftPath.moveTo(center.dx - radius * 0.5, center.dy - radius * 0.3);
    bookLeftPath.lineTo(center.dx - radius * 0.1, center.dy - radius * 0.3);
    bookLeftPath.lineTo(center.dx - radius * 0.1, center.dy + radius * 0.3);
    bookLeftPath.lineTo(center.dx - radius * 0.5, center.dy + radius * 0.3);
    bookLeftPath.close();
    canvas.drawPath(bookLeftPath, bookPaint);
    
    // Buku bagian kanan
    final bookRightPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;
    final bookRightPath = Path();
    bookRightPath.moveTo(center.dx - radius * 0.1, center.dy - radius * 0.3);
    bookRightPath.lineTo(center.dx + radius * 0.3, center.dy - radius * 0.3);
    bookRightPath.lineTo(center.dx + radius * 0.3, center.dy + radius * 0.3);
    bookRightPath.lineTo(center.dx - radius * 0.1, center.dy + radius * 0.3);
    bookRightPath.close();
    canvas.drawPath(bookRightPath, bookRightPaint);
    
    // Gambar garis-garis buku
    final linesPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01;
    
    // Garis horizontal pada buku kiri
    for (int i = 1; i <= 3; i++) {
      final y = center.dy - radius * 0.3 + (radius * 0.6 / 4) * i;
      canvas.drawLine(
        Offset(center.dx - radius * 0.45, y),
        Offset(center.dx - radius * 0.15, y),
        linesPaint,
      );
    }
    
    // Gambar pensil
    final pencilPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    
    final pencilPath = Path();
    pencilPath.moveTo(center.dx + radius * 0.4, center.dy - radius * 0.4);
    pencilPath.lineTo(center.dx + radius * 0.5, center.dy - radius * 0.3);
    pencilPath.lineTo(center.dx + radius * 0.1, center.dy + radius * 0.4);
    pencilPath.lineTo(center.dx, center.dy + radius * 0.3);
    pencilPath.close();
    canvas.drawPath(pencilPath, pencilPaint);
    
    // Gambar ujung pensil
    final pencilTipPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    
    final pencilTipPath = Path();
    pencilTipPath.moveTo(center.dx, center.dy + radius * 0.3);
    pencilTipPath.lineTo(center.dx + radius * 0.1, center.dy + radius * 0.4);
    pencilTipPath.lineTo(center.dx - radius * 0.05, center.dy + radius * 0.45);
    pencilTipPath.close();
    canvas.drawPath(pencilTipPath, pencilTipPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
