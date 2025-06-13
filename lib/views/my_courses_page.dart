import 'package:flutter/material.dart';
import '../models/course.dart'; 
import '../widgets/category_tag.dart'; 
import '../utils/progress_track_page.dart';

class MyCoursesPage extends StatefulWidget {
  final Course? selectedCourse; 
  final VoidCallback onBackToMyCourses;
  final bool showEmptyStateWhenListIsEmpty; // Parameter baru
  final Function(Course, int)? onModuleCompleted; // Callback untuk module completion
  final Function(Course)? onCourseCompleted; // Callback baru untuk course completion

  const MyCoursesPage({
    Key? key,
    this.selectedCourse, 
    required this.onBackToMyCourses,
    this.showEmptyStateWhenListIsEmpty = true, // Default true
    this.onModuleCompleted, // Callback opsional
    this.onCourseCompleted, // Callback opsional untuk course completion
  }) : super(key: key);

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> with SingleTickerProviderStateMixin {
  List<Course> _registeredCourses = [];
  late AnimationController _animationController;
  late Animation<double> _animation;
  Map<String, bool> _courseCompletionStatus = {}; // Menyimpan status penyelesaian kursus

  @override
  void initState() {
    super.initState();
    _loadRegisteredCourses();
    _initializeProgressTracking();
    
    // Inisialisasi controller animasi untuk popup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // Animasi dari 0.0 ke 1.0
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadRegisteredCourses() {
    final allCourses = Course.getSampleCourses();
    // Ini hanya contoh, idealnya data kursus terdaftar diambil dari state management atau database
    _registeredCourses = allCourses.where((c) => c.title.contains("Flutter") || c.title.contains("UI/UX")).toList();
    if (_registeredCourses.isEmpty && allCourses.isNotEmpty && widget.showEmptyStateWhenListIsEmpty) {
      // Jika ingin tetap ada contoh saat empty state boleh tampil
      // _registeredCourses = allCourses.take(2).toList(); 
    } else if (_registeredCourses.isEmpty && !widget.showEmptyStateWhenListIsEmpty) {
      // Jika tidak boleh tampil empty state dan memang kosong, biarkan kosong.
       _registeredCourses = [];
    } else if (_registeredCourses.isEmpty && allCourses.isNotEmpty) {
        // Fallback jika kondisi di atas tidak terpenuhi dan masih kosong
        // _registeredCourses = allCourses.take(1).toList(); // Atau biarkan kosong
    }
  }

  void _initializeProgressTracking() {
    // Inisialisasi progress tracking untuk semua kursus yang terdaftar
    for (Course course in _registeredCourses) {
      ProgressTracker.initializeCourseProgress(course);
      
      // Cek apakah kursus sudah selesai
      final progressStats = ProgressTracker.getProgressStats(course.title);
      _courseCompletionStatus[course.title] = progressStats.isCompleted;
    }
  }

  void _completeModule(Course course, int moduleIndex) {
    // Update progress menggunakan ProgressTracker
    final updatedProgress = ProgressTracker.completeModule(
      course.title, 
      moduleIndex, 
      course.modules.length
    );

    // Panggil callback jika ada
    if (widget.onModuleCompleted != null) {
      widget.onModuleCompleted!(course, moduleIndex);
    }

    // Update UI
    setState(() {
      // Cek apakah kursus sudah selesai setelah modul ini
      final progressStats = ProgressTracker.getProgressStats(course.title);
      _courseCompletionStatus[course.title] = progressStats.isCompleted;
    });

    // Tampilkan snackbar konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modul "${course.modules[moduleIndex].title}" telah diselesaikan!'),
        backgroundColor: course.color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Menampilkan dialog sukses penyelesaian kursus
  void _showCourseCompletionDialog(Course course) {
    // Reset dan mulai animasi
    _animationController.reset();
    _animationController.forward();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animasi centang
              ScaleTransition(
                scale: _animation,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Judul dan pesan
              const Text(
                'Course Berhasil Terselesaikan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Selamat! Anda telah menyelesaikan kursus "${course.title}"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              
              // Tombol kembali
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                    
                    // Tandai kursus sebagai selesai
                    setState(() {
                      _courseCompletionStatus[course.title] = true;
                    });
                    
                    // Panggil callback jika ada
                    if (widget.onCourseCompleted != null) {
                      widget.onCourseCompleted!(course);
                    }
                    
                    // Kembali ke daftar kursus
                    widget.onBackToMyCourses();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5667FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Callback untuk memperbarui progress ketika kembali dari detail
  void _onProgressUpdated() {
    setState(() {
      // Refresh UI untuk memperbarui progress bar
      for (Course course in _registeredCourses) {
        final progressStats = ProgressTracker.getProgressStats(course.title);
        _courseCompletionStatus[course.title] = progressStats.isCompleted;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedCourse != null) {
      return _buildCourseDetail(widget.selectedCourse!);
    } else {
      // Logika untuk menampilkan daftar kursus atau empty state yang dikontrol
      return _buildCoursesListContainer();
    }
  }

  // Widget baru untuk membungkus logika daftar atau empty state terkondisi
  Widget _buildCoursesListContainer() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, "My Courses", widget.onBackToMyCourses, showBackButton: true),
            Expanded(
              child: (_registeredCourses.isEmpty && !widget.showEmptyStateWhenListIsEmpty)
                  ? Container() // Tidak menampilkan apa-apa di body jika kosong & tidak boleh show empty state
                  : _registeredCourses.isEmpty // Otomatis showEmptyStateWhenListIsEmpty adalah true di sini
                      ? _buildEmptyState() // Tampilkan empty state standar
                      : _buildCoursesContent(), // Tampilkan daftar kursus
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, String title, VoidCallback onBack, {bool showBackButton = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 20, 
        right: 20, 
        top: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5667FD),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack, // Ini akan memanggil Navigator.pop(context) dari ProfilePage
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (showBackButton) const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    // Ini adalah empty state standar yang akan tampil jika showEmptyStateWhenListIsEmpty = true
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
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
              'Belum ada kursus yang dipilih',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Daftar kursus dari halaman Kursus untuk mulai belajar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Aksi ini mungkin perlu disesuaikan tergantung dari mana MyCoursesPage dipanggil
                // Jika dari ProfilePage, mungkin kembali ke ProfilePage atau HomePage
                if (Navigator.canPop(context)) {
                  Navigator.pop(context); 
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5667FD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Jelajahi Kursus',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesContent() {
    // Widget ini tidak lagi punya Scaffold sendiri, karena sudah dibungkus _buildCoursesListContainer
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kursus Saya',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lanjutkan belajar kursus yang telah Anda daftar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _registeredCourses.length,
              itemBuilder: (context, index) {
                return _buildCourseItem(_registeredCourses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(Course course) {
    // Ambil progress dari ProgressTracker secara real-time
    final progressStats = ProgressTracker.getProgressStats(course.title);
    final isCompleted = _courseCompletionStatus[course.title] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          // Navigasi ke detail dan tunggu hasil
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyCoursesPage(
                selectedCourse: course, 
                onBackToMyCourses: () {
                  Navigator.pop(context); 
                },
                // Saat masuk ke detail dari daftar, empty state tidak relevan
                showEmptyStateWhenListIsEmpty: widget.showEmptyStateWhenListIsEmpty,
                onModuleCompleted: (completedCourse, moduleIndex) {
                  // Callback ketika modul diselesaikan di detail
                  _completeModule(completedCourse, moduleIndex);
                },
                onCourseCompleted: (completedCourse) {
                  // Callback ketika kursus diselesaikan
                  setState(() {
                    _courseCompletionStatus[completedCourse.title] = true;
                  });
                },
              ),
            ),
          );
          
          // Setelah kembali dari detail, refresh UI
          _onProgressUpdated();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: course.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  course.icon,
                  color: course.color,
                  size: 40,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    CategoryTag(
                      category: course.category,
                      color: course.color,
                    ),
                    const SizedBox(height: 8),
                    
                    // Tampilan progress yang berbeda berdasarkan status penyelesaian
                    if (isCompleted) ...[
                      // Tampilan untuk kursus yang sudah selesai
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Diselesaikan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Tampilan progress bar untuk kursus yang belum selesai
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progress',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${progressStats.progressPercentage.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: course.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progressStats.progressPercentage / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(course.color),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${progressStats.completedModules}/${progressStats.totalModules} modul selesai',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseDetail(Course course) {
    // Ambil progress dari ProgressTracker
    final progressStats = ProgressTracker.getProgressStats(course.title);
    final isAllModulesCompleted = progressStats.progressPercentage >= 100;
    final isCourseCompleted = _courseCompletionStatus[course.title] ?? false;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, "Detail Kursus", widget.onBackToMyCourses, showBackButton: true),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CategoryTag(
                      category: course.category,
                      color: course.color,
                      isDetailed: true,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: course.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Progress Keseluruhan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              Text(
                                '${progressStats.progressPercentage.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: course.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progressStats.progressPercentage / 100,
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(course.color),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${progressStats.completedModules} dari ${progressStats.totalModules} modul selesai',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Modul Kursus',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: course.modules.length,
                      itemBuilder: (context, index) {
                        final module = course.modules[index];
                        final isCompleted = ProgressTracker.isModuleCompleted(course.title, index);
                        return _buildModuleItem(
                          module: module,
                          index: index,
                          isCompleted: isCompleted,
                          course: course,
                        );
                      },
                    ),
                    
                    // Tombol "Selesaikan Course"
                    const SizedBox(height: 24),
                    if (!isCourseCompleted) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isAllModulesCompleted 
                              ? () => _showCourseCompletionDialog(course) 
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: course.color,
                            disabledBackgroundColor: Colors.grey[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Selesaikan Course',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (!isAllModulesCompleted) ...[
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Selesaikan semua modul untuk menyelesaikan kursus',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ] else ...[
                      // Tampilan untuk kursus yang sudah selesai
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'Course Telah Diselesaikan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleItem({
    required CourseModule module,
    required int index,
    required bool isCompleted,
    required Course course,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? course.color.withOpacity(0.3) : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          colorScheme: ColorScheme.light(
            primary: course.color,
          ),
        ),
        child: ExpansionTile(
          title: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted ? course.color : course.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: course.color,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: isCompleted ? const Color(0xFF1F2937) : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${module.duration} menit',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        if (isCompleted) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Selesai',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    module.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
                  ),
                  if (!isCompleted) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _completeModule(course, index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: course.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Mulai Modul',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Modul Selesai',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
