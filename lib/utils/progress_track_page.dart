import '../models/course.dart';

class ProgressTracker {
  // Map untuk menyimpan progress setiap kursus berdasarkan ID atau title
  static Map<String, CourseProgress> _courseProgressMap = {};

  // Mendapatkan progress kursus
  static CourseProgress getCourseProgress(String courseId) {
    return _courseProgressMap[courseId] ?? CourseProgress(
      courseId: courseId,
      completedModules: [],
      totalModules: 0,
      progressPercentage: 0.0,
    );
  }

  // Menginisialisasi progress kursus baru
  static void initializeCourseProgress(Course course) {
    final courseId = course.title; // Menggunakan title sebagai ID unik
    if (!_courseProgressMap.containsKey(courseId)) {
      _courseProgressMap[courseId] = CourseProgress(
        courseId: courseId,
        completedModules: [],
        totalModules: course.modules.length,
        progressPercentage: 0.0,
      );
    }
  }

  // Menyelesaikan modul dan menghitung progress
  static CourseProgress completeModule(String courseId, int moduleIndex, int totalModules) {
    final progress = getCourseProgress(courseId);
    
    // Tambahkan modul ke daftar yang sudah diselesaikan jika belum ada
    if (!progress.completedModules.contains(moduleIndex)) {
      progress.completedModules.add(moduleIndex);
      progress.completedModules.sort(); // Urutkan untuk konsistensi
    }

    // Update total modules jika berbeda
    progress.totalModules = totalModules;

    // Hitung progress menggunakan rumus: (jumlah modul selesai / total modul) * 100%
    progress.progressPercentage = calculateProgressPercentage(
      progress.completedModules.length, 
      progress.totalModules
    );

    // Update map
    _courseProgressMap[courseId] = progress;

    return progress;
  }

  // Rumus perhitungan progress: (completed/total) * 100%
  static double calculateProgressPercentage(int completedModules, int totalModules) {
    if (totalModules == 0) return 0.0;
    return (completedModules / totalModules) * 100.0;
  }

  // Mengecek apakah modul sudah diselesaikan
  static bool isModuleCompleted(String courseId, int moduleIndex) {
    final progress = getCourseProgress(courseId);
    return progress.completedModules.contains(moduleIndex);
  }

  // Mendapatkan jumlah modul yang sudah diselesaikan
  static int getCompletedModulesCount(String courseId) {
    final progress = getCourseProgress(courseId);
    return progress.completedModules.length;
  }

  // Mendapatkan progress percentage
  static double getProgressPercentage(String courseId) {
    final progress = getCourseProgress(courseId);
    return progress.progressPercentage;
  }

  // Reset progress kursus (untuk testing atau reset)
  static void resetCourseProgress(String courseId) {
    _courseProgressMap[courseId] = CourseProgress(
      courseId: courseId,
      completedModules: [],
      totalModules: getCourseProgress(courseId).totalModules,
      progressPercentage: 0.0,
    );
  }

  // Mendapatkan semua progress kursus
  static Map<String, CourseProgress> getAllProgress() {
    return Map.from(_courseProgressMap);
  }

  // Menghitung progress untuk modul berikutnya
  static double calculateNextModuleProgress(String courseId, int totalModules) {
    final currentProgress = getCourseProgress(courseId);
    final nextCompletedCount = currentProgress.completedModules.length + 1;
    return calculateProgressPercentage(nextCompletedCount, totalModules);
  }

  // Mendapatkan modul berikutnya yang belum diselesaikan
  static int? getNextIncompleteModule(String courseId, int totalModules) {
    final progress = getCourseProgress(courseId);
    for (int i = 0; i < totalModules; i++) {
      if (!progress.completedModules.contains(i)) {
        return i;
      }
    }
    return null; // Semua modul sudah selesai
  }

  // Mengecek apakah kursus sudah selesai 100%
  static bool isCourseCompleted(String courseId) {
    final progress = getCourseProgress(courseId);
    return progress.progressPercentage >= 100.0;
  }

  // Mendapatkan statistik progress
  static ProgressStats getProgressStats(String courseId) {
    final progress = getCourseProgress(courseId);
    return ProgressStats(
      completedModules: progress.completedModules.length,
      totalModules: progress.totalModules,
      progressPercentage: progress.progressPercentage,
      remainingModules: progress.totalModules - progress.completedModules.length,
      isCompleted: progress.progressPercentage >= 100.0,
    );
  }
}

// Model untuk menyimpan progress kursus
class CourseProgress {
  final String courseId;
  List<int> completedModules; // Index modul yang sudah diselesaikan
  int totalModules;
  double progressPercentage;

  CourseProgress({
    required this.courseId,
    required this.completedModules,
    required this.totalModules,
    required this.progressPercentage,
  });

  // Convert to JSON untuk penyimpanan
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'completedModules': completedModules,
      'totalModules': totalModules,
      'progressPercentage': progressPercentage,
    };
  }

  // Create from JSON
  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      courseId: json['courseId'],
      completedModules: List<int>.from(json['completedModules']),
      totalModules: json['totalModules'],
      progressPercentage: json['progressPercentage'].toDouble(),
    );
  }
}

// Model untuk statistik progress
class ProgressStats {
  final int completedModules;
  final int totalModules;
  final double progressPercentage;
  final int remainingModules;
  final bool isCompleted;

  ProgressStats({
    required this.completedModules,
    required this.totalModules,
    required this.progressPercentage,
    required this.remainingModules,
    required this.isCompleted,
  });
}
