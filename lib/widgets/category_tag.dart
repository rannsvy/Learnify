import 'package:flutter/material.dart';

class CategoryTag extends StatelessWidget {
  final String category;
  final Color color;
  final bool isDetailed;

  const CategoryTag({
    Key? key,
    required this.category,
    required this.color,
    this.isDetailed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDetailed ? 12 : 8,
        vertical: isDetailed ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isDetailed ? 8 : 4),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: color,
          fontSize: isDetailed ? 14 : 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
