import 'package:flutter/material.dart';
import '../models/course.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatefulWidget {
  final Course? selectedCourse;
  final Function(Course) onRegisterCourse;
  final VoidCallback onBackToHome;
  final List<Course> registeredCourses;

  const CoursesPage({
    Key? key,
    this.selectedCourse,
    required this.onRegisterCourse,
    required this.onBackToHome,
    required this.registeredCourses,
  }) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.selectedCourse == null) {
      return _buildEmptyState();
    } else {
      // Periksa apakah kursus sudah terdaftar
      bool isAlreadyRegistered = widget.registeredCourses.any(
        (course) => course.title == widget.selectedCourse!.title
      );
      
      return CourseDetailPage(
        selectedCourse: widget.selectedCourse!,
        onRegisterCourse: widget.onRegisterCourse,
        onBackToHome: widget.onBackToHome,
        isAlreadyRegistered: isAlreadyRegistered,
      );
    }
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_outlined,
                size: 100,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 24),
              Text(
                'Tidak ada course yang dipilih saat ini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Pilih course dari halaman Home untuk melihat detailnya',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
