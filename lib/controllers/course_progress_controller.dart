import 'package:flutter/material.dart';
import '../models/course.dart';
import '../utils/progress_track_page.dart';

/// Controller untuk memantau dan mengontrol progress tracking dari course
class CourseProgressController with ChangeNotifier {
  // Singleton pattern untuk memastikan hanya ada satu instance dari controller ini
  static final CourseProgressController _instance = CourseProgressController._internal();
  
  factory CourseProgressController() {
    return _instance;
  }
  
  CourseProgressController._internal();
  
  // Map untuk menyimpan status penyelesaian kursus (courseId -> isCompleted)
  final Map<String, bool> _courseCompletionStatus = {};
  
  // Map untuk menyimpan progress kursus (courseId -> progress percentage)
  final Map<String, double> _courseProgressPercentage = {};
  
  // Map untuk menyimpan jumlah modul yang telah diselesaikan (courseId -> completedModules)
  final Map<String, int> _completedModulesCount = {};
  
  // Daftar kursus yang telah didaftarkan
  final List<Course> _registeredCourses = [];
  
  // Getter untuk mendapatkan daftar kursus yang telah didaftarkan
  List<Course> get registeredCourses => List.unmodifiable(_registeredCourses);
  
  // Getter untuk mendapatkan status penyelesaian kursus
  Map<String, bool> get courseCompletionStatus => Map.unmodifiable(_courseCompletionStatus);
  
  /// Inisialisasi controller dengan daftar kursus yang telah didaftarkan
  void initialize(List<Course> courses) {
    _registeredCourses.clear();
    _registeredCourses.addAll(courses);
    
    // Inisialisasi progress tracking untuk semua kursus
    for (final course in courses) {
      _initializeCourseProgress(course);
    }
    
    notifyListeners();
  }
  
  /// Inisialisasi progress tracking untuk kursus tertentu
  void _initializeCourseProgress(Course course) {
    final courseId = course.title; // Menggunakan title sebagai ID unik
    
    // Inisialisasi di ProgressTracker
    ProgressTracker.initializeCourseProgress(course);
    
    // Ambil data progress dari ProgressTracker
    final progressStats = ProgressTracker.getProgressStats(courseId);
    
    // Update status di controller
    _courseCompletionStatus[courseId] = progressStats.isCompleted;
    _courseProgressPercentage[courseId] = progressStats.progressPercentage;
    _completedModulesCount[courseId] = progressStats.completedModules;
  }
  
  /// Mendaftarkan kursus baru
  void registerCourse(Course course) {
    if (!_registeredCourses.any((c) => c.title == course.title)) {
      _registeredCourses.add(course);
      _initializeCourseProgress(course);
      notifyListeners();
    }
  }
  
  /// Menyelesaikan modul dari kursus
  void completeModule(Course course, int moduleIndex) {
    final courseId = course.title;
    
    // Update progress di ProgressTracker
    final updatedProgress = ProgressTracker.completeModule(
      courseId, 
      moduleIndex, 
      course.modules.length
    );
    
    // Update status di controller
    final progressStats = ProgressTracker.getProgressStats(courseId);
    _courseCompletionStatus[courseId] = progressStats.isCompleted;
    _courseProgressPercentage[courseId] = progressStats.progressPercentage;
    _completedModulesCount[courseId] = progressStats.completedModules;
    
    notifyListeners();
  }
  
  /// Menyelesaikan kursus secara manual (melalui tombol "Selesaikan Course")
  void completeCourse(Course course) {
    final courseId = course.title;
    
    // Tandai semua modul sebagai selesai
    for (int i = 0; i < course.modules.length; i++) {
      if (!ProgressTracker.isModuleCompleted(courseId, i)) {
        ProgressTracker.completeModule(courseId, i, course.modules.length);
      }
    }
    
    // Update status di controller
    _courseCompletionStatus[courseId] = true;
    _courseProgressPercentage[courseId] = 100.0;
    _completedModulesCount[courseId] = course.modules.length;
    
    notifyListeners();
  }
  
  /// Mengecek apakah kursus sudah selesai
  bool isCourseCompleted(String courseId) {
    return _courseCompletionStatus[courseId] ?? false;
  }
  
  /// Mengecek apakah modul sudah diselesaikan
  bool isModuleCompleted(String courseId, int moduleIndex) {
    return ProgressTracker.isModuleCompleted(courseId, moduleIndex);
  }
  
  /// Mendapatkan persentase progress kursus
  double getCourseProgressPercentage(String courseId) {
    return _courseProgressPercentage[courseId] ?? 0.0;
  }
  
  /// Mendapatkan jumlah modul yang telah diselesaikan
  int getCompletedModulesCount(String courseId) {
    return _completedModulesCount[courseId] ?? 0;
  }
  
  /// Mendapatkan statistik progress kursus
  ProgressStats getCourseProgressStats(String courseId) {
    return ProgressTracker.getProgressStats(courseId);
  }
  
  /// Mendapatkan kursus berdasarkan ID
  Course? getCourseById(String courseId) {
    try {
      return _registeredCourses.firstWhere((course) => course.title == courseId);
    } catch (e) {
      return null;
    }
  }
  
  /// Memperbarui UI dengan progress terbaru
  void refreshProgress() {
    for (final course in _registeredCourses) {
      final courseId = course.title;
      final progressStats = ProgressTracker.getProgressStats(courseId);
      
      _courseCompletionStatus[courseId] = progressStats.isCompleted;
      _courseProgressPercentage[courseId] = progressStats.progressPercentage;
      _completedModulesCount[courseId] = progressStats.completedModules;
    }
    
    notifyListeners();
  }
  
  /// Reset progress kursus (untuk testing)
  void resetCourseProgress(String courseId) {
    ProgressTracker.resetCourseProgress(courseId);
    
    _courseCompletionStatus[courseId] = false;
    _courseProgressPercentage[courseId] = 0.0;
    _completedModulesCount[courseId] = 0;
    
    notifyListeners();
  }
  
  /// Reset progress semua kursus (untuk testing)
  void resetAllProgress() {
    for (final course in _registeredCourses) {
      resetCourseProgress(course.title);
    }
  }
}

/// Extension untuk Course untuk memudahkan akses ke CourseProgressController
extension CourseProgressExtension on Course {
  /// Mendapatkan status penyelesaian kursus
  bool get isCompleted {
    return CourseProgressController().isCourseCompleted(title);
  }
  
  /// Mendapatkan persentase progress kursus
  double get progressPercentage {
    return CourseProgressController().getCourseProgressPercentage(title);
  }
  
  /// Mendapatkan jumlah modul yang telah diselesaikan
  int get completedModulesCount {
    return CourseProgressController().getCompletedModulesCount(title);
  }
  
  /// Mendapatkan statistik progress kursus
  ProgressStats get progressStats {
    return CourseProgressController().getCourseProgressStats(title);
  }
}
