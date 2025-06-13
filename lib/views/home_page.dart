import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../models/course.dart';
import '../widgets/category_tag.dart';
import '../widgets/expandable_category.dart';
import '../controllers/course_progress_controller.dart';
import 'my_courses_page.dart';
import 'courses_page.dart';
import 'profile_page.dart';
import 'sign_in_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Course? _selectedCourseForDetail;
  Course? _selectedCourseForMyPage;
  List<Course> _registeredCourses = [];
  String? _selectedCategory;
  bool _isBlurred = false;

  // Controller untuk progress tracking
  final CourseProgressController _progressController = CourseProgressController();

  // Key untuk mengakses state HomeContent
  final GlobalKey<_HomeContentState> _homeContentKey = GlobalKey<_HomeContentState>();

  // Daftar halaman yang akan ditampilkan oleh bottom navigation bar
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadRegisteredCourses();
    _initPages();
  }

  void _loadRegisteredCourses() {
    final allCourses = Course.getSampleCourses();
    // Ini hanya contoh, idealnya data kursus terdaftar diambil dari state management atau database
    _registeredCourses = allCourses.where((c) => c.title.contains("Flutter") || c.title.contains("UI/UX")).toList();
    
    // Inisialisasi progress controller dengan daftar kursus
    _progressController.initialize(_registeredCourses);
  }

  void _initPages() {
    _pages = [
      HomeContent(
        key: _homeContentKey,
        onCourseSelected: _onCourseSelectedForDetail,
        onCategorySelected: _onCategorySelected,
        isBlurred: _isBlurred,
        selectedCategory: _selectedCategory,
        onCategoryClose: _onCategoryClose,
      ),
      CoursesPage(
        selectedCourse: _selectedCourseForDetail,
        onRegisterCourse: _onRegisterCourse,
        onBackToHome: _navigateToHome,
        registeredCourses: _registeredCourses,
      ),
      _buildMyCoursesPage(),
      ProfilePage(
        onSignOut: () {
          // Navigasi ke halaman sign in
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false,
          );
        },
      ),
    ];
  }

  // Navigasi ke halaman Home
  void _navigateToHome() {
    setState(() {
      _selectedIndex = 0;
      _initPages();
    });
  }

  // Navigasi kembali ke daftar kursus yang telah didaftarkan
  void _navigateToMyCoursesList() {
    setState(() {
      _selectedCourseForMyPage = null;
      _initPages();
    });
  }

  // Ketika kategori dipilih
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _isBlurred = true;
      _initPages();
    });
  }

  // Ketika kategori ditutup
  void _onCategoryClose() {
    setState(() {
      _selectedCategory = null;
      _isBlurred = false;
      _initPages();
    });
  }

  // Membangun halaman My Courses
  Widget _buildMyCoursesPage() {
    if (_registeredCourses.isEmpty) {
      // Tampilkan halaman kosong jika belum ada kursus yang didaftarkan
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildMyCoursesHeader(),
              
              // Konten kosong
              Expanded(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_selectedCourseForMyPage == null) {
      // Tampilkan daftar kursus jika belum ada kursus yang dipilih
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildMyCoursesHeader(),
              
              // Daftar kursus
              Expanded(
                child: Padding(
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
                      
                      // Daftar kursus
                      Expanded(
                        child: ListView.builder(
                          itemCount: _registeredCourses.length,
                          itemBuilder: (context, index) {
                            return _buildCourseItem(
                              _registeredCourses[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Tampilkan detail kursus jika ada kursus yang dipilih
      return MyCoursesPage(
        selectedCourse: _selectedCourseForMyPage!,
        onBackToMyCourses: _navigateToMyCoursesList,
        onModuleCompleted: (course, moduleIndex) {
          // Update progress menggunakan controller
          _progressController.completeModule(course, moduleIndex);
          setState(() {});
        },
        onCourseCompleted: (course) {
          // Tandai kursus sebagai selesai
          _progressController.completeCourse(course);
          setState(() {});
        },
      );
    }
  }

  // Header untuk halaman My Courses
  Widget _buildMyCoursesHeader() {
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
          // Judul halaman
          const Text(
            'My Courses',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Item kursus untuk daftar My Courses
  Widget _buildCourseItem(Course course) {
    // Ambil progress dari CourseProgressController
    final isCompleted = _progressController.isCourseCompleted(course.title);
    final progressStats = _progressController.getCourseProgressStats(course.title);
    
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
        onTap: () {
          setState(() {
            _selectedCourseForMyPage = course;
            _initPages();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Thumbnail kursus
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
              
              // Informasi kursus
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
                    
                    // Tag kategori
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
              
              // Ikon panah
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

  // Metode untuk mereset state pencarian
  void _resetSearchState() {
    if (_selectedIndex == 0 && _homeContentKey.currentState != null) {
      // Reset state pencarian di HomeContent
      _homeContentKey.currentState!.resetSearchState();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
      // Jika user mengklik home tab saat berada di tab lain, reset state pencarian
      if (index == 0) {
        _resetSearchState();
      }
      
      _initPages(); // Perbarui halaman saat tab berubah
    });
  }

  void _onCourseSelectedForDetail(Course course) {
    setState(() {
      _selectedCourseForDetail = course;
      _selectedIndex = 1; // Pindah ke tab Kursus
      
      // Reset kategori saat kursus dipilih
      _selectedCategory = null;
      _isBlurred = false;
      
      _initPages(); // Perbarui halaman dengan kursus yang dipilih
    });
  }

  void _onCourseSelectedForMyPage(Course course) {
    setState(() {
      _selectedCourseForMyPage = course;
      _initPages(); // Perbarui halaman dengan kursus yang dipilih
    });
  }

  void _onRegisterCourse(Course course) {
    setState(() {
      if (!_registeredCourses.any((c) => c.title == course.title)) {
        _registeredCourses.add(course);
        // Daftarkan kursus ke controller
        _progressController.registerCourse(course);
      }
      _selectedCourseForDetail = null; // Reset kursus yang dipilih di halaman Kursus
      _selectedIndex = 0; // Kembali ke halaman Home
      _initPages(); // Perbarui halaman
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menghapus AppBar
      body: Stack(
        children: [
          _pages[_selectedIndex],
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Kursus',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              activeIcon: Icon(Icons.bookmark),
              label: 'My Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF5667FD),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final Function(Course) onCourseSelected;
  final Function(String) onCategorySelected;
  final VoidCallback onCategoryClose;
  final bool isBlurred;
  final String? selectedCategory;

  const HomeContent({
    Key? key,
    required this.onCourseSelected,
    required this.onCategorySelected,
    required this.onCategoryClose,
    required this.isBlurred,
    this.selectedCategory,
  }) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  List<Course> _searchResults = [];
  bool _isSearchMode = false;
  bool _isSearching = false;
  FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // Mendapatkan kategori dan warna ikon
  Map<String, dynamic> _getCategoryInfo(String categoryName) {
    final List<Map<String, dynamic>> categories = [
      {
        'icon': Icons.code,
        'color': const Color(0xFF5667FD),
        'name': 'Pemrograman',
      },
      {
        'icon': Icons.language,
        'color': const Color(0xFFFFA500),
        'name': 'Bahasa',
      },
      {
        'icon': Icons.business,
        'color': const Color(0xFF4CAF50),
        'name': 'Bisnis',
      },
      {
        'icon': Icons.brush,
        'color': const Color(0xFFE91E63),
        'name': 'Desain',
      },
      {
        'icon': Icons.camera_alt,
        'color': const Color(0xFF9C27B0),
        'name': 'Fotografi',
      },
      {
        'icon': Icons.music_note,
        'color': const Color(0xFF2196F3),
        'name': 'Musik',
      },
      {
        'icon': Icons.fitness_center,
        'color': const Color(0xFFFF5722),
        'name': 'Kesehatan',
      },
      {
        'icon': Icons.more_horiz,
        'color': const Color(0xFF607D8B),
        'name': 'Lainnya',
      },
    ];

    final category = categories.firstWhere(
      (cat) => cat['name'] == categoryName,
      orElse: () => {
        'icon': Icons.category,
        'color': const Color(0xFF5667FD),
        'name': categoryName,
      },
    );

    return category;
  }

  // Mendapatkan kursus berdasarkan kategori
  List<Course> _getCoursesByCategory(String categoryName) {
    return Course.getSampleCourses().where(
      (course) => course.category == categoryName
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isSearchMode) {
      // Jika aplikasi di-resume dan dalam mode pencarian, fokus kembali ke search bar
      _searchFocusNode.requestFocus();
    }
  }

  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus && !_isSearchMode) {
      setState(() {
        _isSearchMode = true;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    final results = Course.getSampleCourses().where((course) {
      return course.title.toLowerCase().contains(query) ||
             course.instructor.toLowerCase().contains(query) ||
             course.category.toLowerCase().contains(query) ||
             course.description.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

  void _onSearchResultTap(Course course) {
    // Tutup keyboard
    FocusScope.of(context).unfocus();
    
    // Reset search
    setState(() {
      _searchController.clear();
      _searchResults = [];
      _isSearching = false;
      _isSearchMode = false;
    });
    
    // Navigasi ke detail kursus
    widget.onCourseSelected(course);
  }

  void _exitSearchMode() {
    // Tutup keyboard
    FocusScope.of(context).unfocus();
    
    // Reset search
    setState(() {
      _searchController.clear();
      _searchResults = [];
      _isSearching = false;
      _isSearchMode = false;
    });
  }

  // Metode untuk mereset state pencarian (dipanggil dari luar)
  void resetSearchState() {
    if (_isSearchMode) {
      _exitSearchMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tangani tombol back pada device
    return WillPopScope(
      onWillPop: () async {
        if (_isSearchMode) {
          _exitSearchMode();
          return false; // Jangan keluar dari aplikasi
        }
        if (widget.selectedCategory != null) {
          widget.onCategoryClose();
          return false; // Jangan keluar dari aplikasi
        }
        return true; // Keluar dari aplikasi
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Konten utama
            _isSearchMode ? _buildSearchModeLayout() : _buildNormalLayout(),
            
            // Blur overlay ketika kategori dipilih
            if (widget.isBlurred && !_isSearchMode)
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.onCategoryClose, // Tutup kategori saat background di-tap
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              
            // Tampilkan kategori yang dipilih
            if (widget.selectedCategory != null && !_isSearchMode)
              _buildExpandedCategory(),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan kategori yang dipilih
  Widget _buildExpandedCategory() {
    if (widget.selectedCategory == null) return const SizedBox.shrink();
    
    final categoryInfo = _getCategoryInfo(widget.selectedCategory!);
    final courses = _getCoursesByCategory(widget.selectedCategory!);
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ExpandableCategory(
        category: widget.selectedCategory!,
        icon: categoryInfo['icon'],
        color: categoryInfo['color'],
        courses: courses,
        onCourseSelected: widget.onCourseSelected,
        onClose: widget.onCategoryClose,
      ),
    );
  }

  // Layout saat mode pencarian aktif
  Widget _buildSearchModeLayout() {
    return Column(
      children: [
        // Header pencarian yang tetap di atas
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF5667FD),
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
              // Tombol kembali
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _exitSearchMode,
              ),
              // Search bar
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Cari kursus...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[400], size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _isSearching = false;
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Konten hasil pencarian
        Expanded(
          child: _isSearching && _searchResults.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _searchResults.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[200],
                ),
                itemBuilder: (context, index) {
                  final course = _searchResults[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: course.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          course.icon,
                          color: course.color,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Oleh ${course.instructor}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          CategoryTag(
                            category: course.category,
                            color: course.color,
                          ),
                        ],
                      ),
                      onTap: () => _onSearchResultTap(course),
                    ),
                  );
                },
              )
            : _isSearching && _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada hasil yang ditemukan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Coba kata kunci lain',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cari kursus yang ingin Anda pelajari',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  // Layout normal
  Widget _buildNormalLayout() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan logo dan profil (dengan bentuk membulat)
          _buildHeader(context),
          
          // Greeting dan search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Halo, Ranuh Firham!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Apa yang ingin kamu pelajari hari ini?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 30),
              ],
            ),
          ),
          
          // Kategori
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                _buildCategoryGrid(),
                const SizedBox(height: 30),
              ],
            ),
          ),
          
          // Kursus Populer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kursus Populer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigasi ke halaman semua kursus populer
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF5667FD),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPopularCoursesList(),
                const SizedBox(height: 30),
              ],
            ),
          ),
          
          // Kursus Terbaru
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kursus Terbaru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigasi ke halaman semua kursus terbaru
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF5667FD),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildNewCoursesList(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header dengan logo dan profil (dengan bentuk membulat)
  Widget _buildHeader(BuildContext context) { // context di sini adalah parameter method
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20, 
        right: 20, 
        top: MediaQuery.of(this.context).padding.top + 16, // Menggunakan this.context dari State
        bottom: 30, 
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/learnify_white_logo.png',
            height: 30,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 120,
                height: 30,
                color: Colors.white.withOpacity(0.2),
                child: const Center(
                  child: Text(
                    'Logo tidak tersedia',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {
                  // TODO: Navigasi ke halaman notifikasi
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 24,
              ),
              const SizedBox(width: 16),
              // Ini bagian yang diubah:
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    this.context, // Menggunakan this.context dari _HomeContentState
                    MaterialPageRoute(
                      builder: (BuildContext navContext) => ProfilePage(
                        onSignOut: () {
                          Navigator.of(this.context, rootNavigator: true).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (BuildContext dialogNavContext) => const SignInPage()),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/profile_photo.jpg'),
                  backgroundColor: Colors.white, 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Search bar
  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSearchMode = true;
        });
        _searchFocusNode.requestFocus();
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.search,
                color: Colors.grey[400],
              ),
            ),
            Text(
              'Cari kursus...',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  // Grid kategori
  Widget _buildCategoryGrid() {
    final List<Map<String, dynamic>> categories = [
      {
        'icon': Icons.code,
        'color': const Color(0xFF5667FD),
        'name': 'Pemrograman',
      },
      {
        'icon': Icons.language,
        'color': const Color(0xFFFFA500),
        'name': 'Bahasa',
      },
      {
        'icon': Icons.business,
        'color': const Color(0xFF4CAF50),
        'name': 'Bisnis',
      },
      {
        'icon': Icons.brush,
        'color': const Color(0xFFE91E63),
        'name': 'Desain',
      },
      {
        'icon': Icons.camera_alt,
        'color': const Color(0xFF9C27B0),
        'name': 'Fotografi',
      },
      {
        'icon': Icons.music_note,
        'color': const Color(0xFF2196F3),
        'name': 'Musik',
      },
      {
        'icon': Icons.fitness_center,
        'color': const Color(0xFFFF5722),
        'name': 'Kesehatan',
      },
      {
        'icon': Icons.more_horiz,
        'color': const Color(0xFF607D8B),
        'name': 'Lainnya',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryItem(
          icon: categories[index]['icon'],
          color: categories[index]['color'],
          name: categories[index]['name'],
        );
      },
    );
  }

  // Item kategori
  Widget _buildCategoryItem({
    required IconData icon,
    required Color color,
    required String name,
  }) {
    return GestureDetector(
      onTap: () => widget.onCategorySelected(name),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Daftar kursus populer
  Widget _buildPopularCoursesList() {
    final List<Course> courses = Course.getSampleCourses();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              widget.onCourseSelected(courses[index]);
            },
            borderRadius: BorderRadius.circular(12),
            child: _buildCourseCard(
              course: courses[index],
            ),
          ),
        );
      },
    );
  }

  // Daftar kursus terbaru
  Widget _buildNewCoursesList() {
    final List<Course> courses = Course.getSampleCourses().reversed.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              widget.onCourseSelected(courses[index]);
            },
            borderRadius: BorderRadius.circular(12),
            child: _buildCourseCard(
              course: courses[index],
            ),
          ),
        );
      },
    );
  }

  // Card kursus
  Widget _buildCourseCard({
    required Course course,
  }) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Thumbnail kursus
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
            
            // Informasi kursus
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
                  const SizedBox(height: 4),
                  Text(
                    'Oleh ${course.instructor}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Tag kategori
                  CategoryTag(
                    category: course.category,
                    color: course.color,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.rating.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      
                      // Jumlah siswa
                      Row(
                        children: [
                          const Icon(
                            Icons.people,
                            color: Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${course.students} siswa',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Harga
                  Text(
                    course.price,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: course.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
