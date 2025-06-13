import 'package:flutter/material.dart';

/// Custom painter untuk menggambar dekorasi background
class BackgroundDecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Warna dari logo Learnify
    final greenColor = Color(0xFF2ECC71).withOpacity(0.1);
    final blueColor = Color(0xFF3498DB).withOpacity(0.1);
    final darkBlueColor = Color(0xFF2C3E50).withOpacity(0.1);
    
    // Paint untuk elemen dekoratif
    final greenPaint = Paint()
      ..color = greenColor
      ..style = PaintingStyle.fill;
    
    final bluePaint = Paint()
      ..color = blueColor
      ..style = PaintingStyle.fill;
      
    final darkBluePaint = Paint()
      ..color = darkBlueColor
      ..style = PaintingStyle.fill;
    
    // Gambar lingkaran besar di pojok kiri atas
    canvas.drawCircle(
      Offset(0, 0),
      width * 0.3,
      greenPaint,
    );
    
    // Gambar lingkaran di pojok kanan bawah
    canvas.drawCircle(
      Offset(width, height),
      width * 0.4,
      bluePaint,
    );
    
    // Gambar lingkaran di tengah kanan
    canvas.drawCircle(
      Offset(width, height * 0.5),
      width * 0.2,
      greenPaint,
    );
    
    // Gambar lingkaran di tengah kiri
    canvas.drawCircle(
      Offset(0, height * 0.7),
      width * 0.15,
      bluePaint,
    );
    
    // Gambar ikon buku (bentuk persegi panjang)
    final bookRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(width * 0.15, height * 0.2),
        width: width * 0.1,
        height: width * 0.15,
      ),
      Radius.circular(width * 0.02),
    );
    canvas.drawRRect(bookRect, darkBluePaint);
    
    // Gambar ikon laptop (bentuk trapesium)
    final laptopPath = Path();
    laptopPath.moveTo(width * 0.8, height * 0.3);
    laptopPath.lineTo(width * 0.9, height * 0.3);
    laptopPath.lineTo(width * 0.95, height * 0.35);
    laptopPath.lineTo(width * 0.75, height * 0.35);
    laptopPath.close();
    canvas.drawPath(laptopPath, darkBluePaint);
    
    // Gambar ikon pensil
    final pencilPath = Path();
    pencilPath.moveTo(width * 0.7, height * 0.8);
    pencilPath.lineTo(width * 0.75, height * 0.75);
    pencilPath.lineTo(width * 0.8, height * 0.85);
    pencilPath.lineTo(width * 0.75, height * 0.9);
    pencilPath.close();
    canvas.drawPath(pencilPath, greenPaint);
    
    // Gambar ikon globe (lingkaran dengan garis)
    canvas.drawCircle(
      Offset(width * 0.2, height * 0.85),
      width * 0.08,
      bluePaint,
    );
    
    // Gambar ikon play (segitiga)
    final playPath = Path();
    playPath.moveTo(width * 0.85, height * 0.6);
    playPath.lineTo(width * 0.9, height * 0.65);
    playPath.lineTo(width * 0.85, height * 0.7);
    playPath.close();
    canvas.drawPath(playPath, greenPaint);
    
    // Gambar beberapa titik kecil tersebar
    for (int i = 0; i < 20; i++) {
      final x = width * (i % 5) * 0.2 + width * 0.1;
      final y = height * (i ~/ 5) * 0.2 + height * 0.1;
      
      canvas.drawCircle(
        Offset(x, y),
        width * 0.01,
        i % 2 == 0 ? greenPaint : bluePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
