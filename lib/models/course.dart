import 'package:flutter/material.dart';

class Course {
  final String title;
  final String instructor;
  final double rating;
  final int students;
  final String price;
  final IconData icon;
  final Color color;
  final String description;
  final int progress; // Properti progress kursus (0-100)
  final int completedModules; // Jumlah modul yang telah diselesaikan
  final List<CourseModule> modules;
  final String category; // Properti kategori untuk mengelompokkan kursus

  Course({
    required this.title,
    required this.instructor,
    required this.rating,
    required this.students,
    required this.price,
    required this.icon,
    required this.color,
    required this.description,
    required this.progress,
    required this.completedModules,
    required this.modules,
    required this.category, // Parameter kategori
  });

  // Daftar kursus yang tersedia dengan kategori
  static List<Course> getSampleCourses() {
    return [
      Course(
        title: 'Flutter Mobile Development',
        instructor: 'John Doe',
        rating: 4.8,
        students: 1234,
        price: 'Rp 299.000',
        icon: Icons.phone_android,
        color: const Color(0xFF5667FD),
        description: 'Kursus ini akan mengajarkan Anda cara membuat aplikasi mobile cross-platform menggunakan Flutter. Anda akan belajar tentang widget, state management, navigasi, dan integrasi dengan API. Di akhir kursus, Anda akan mampu membuat aplikasi mobile yang menarik dan fungsional untuk Android dan iOS.',
        progress: 0, // Diubah ke 0
        completedModules: 0, // Diubah ke 0
        category: 'Pemrograman', // Kategori untuk Flutter
        modules: [
          CourseModule(
            title: 'Pengenalan Flutter',
            duration: 45,
            description: 'Modul ini memperkenalkan Anda pada Flutter, keunggulannya dibandingkan framework lain, dan cara menyiapkan lingkungan pengembangan Flutter di komputer Anda.',
          ),
          CourseModule(
            title: 'Dasar-dasar Dart',
            duration: 60,
            description: 'Pelajari bahasa pemrograman Dart yang digunakan dalam Flutter. Modul ini mencakup variabel, tipe data, fungsi, class, dan fitur-fitur modern Dart.',
          ),
          CourseModule(
            title: 'Widget dan Layout',
            duration: 90,
            description: 'Pelajari berbagai widget Flutter dan cara menyusunnya untuk membuat layout yang responsif. Modul ini mencakup Row, Column, Stack, Container, dan banyak lagi.',
          ),
          CourseModule(
            title: 'State Management',
            duration: 120,
            description: 'Pelajari cara mengelola state dalam aplikasi Flutter. Modul ini mencakup StatefulWidget, Provider, Bloc, dan Redux.',
          ),
          CourseModule(
            title: 'Navigasi dan Routing',
            duration: 75,
            description: 'Pelajari cara mengimplementasikan navigasi dan routing dalam aplikasi Flutter. Modul ini mencakup Navigator, named routes, dan deep linking.',
          ),
          CourseModule(
            title: 'Integrasi API',
            duration: 105,
            description: 'Pelajari cara mengintegrasikan API dengan aplikasi Flutter. Modul ini mencakup HTTP requests, JSON parsing, dan autentikasi.',
          ),
          CourseModule(
            title: 'Proyek Akhir',
            duration: 180,
            description: 'Terapkan semua yang telah Anda pelajari dalam proyek akhir. Anda akan membuat aplikasi e-commerce lengkap dengan fitur autentikasi, katalog produk, keranjang belanja, dan pembayaran.',
          ),
        ],
      ),
      Course(
        title: 'UI/UX Design Masterclass',
        instructor: 'Jane Smith',
        rating: 4.7,
        students: 987,
        price: 'Rp 349.000',
        icon: Icons.design_services,
        color: const Color(0xFFE91E63),
        description: 'Kursus ini akan mengajarkan Anda prinsip-prinsip desain UI/UX dan cara menerapkannya dalam proyek nyata. Anda akan belajar tentang user research, wireframing, prototyping, dan design systems. Di akhir kursus, Anda akan memiliki portofolio desain UI/UX yang menarik.',
        progress: 0, // Diubah ke 0
        completedModules: 0, // Diubah ke 0
        category: 'Desain', // Kategori untuk UI/UX
        modules: [
          CourseModule(
            title: 'Pengenalan UI/UX Design',
            duration: 50,
            description: 'Modul ini memperkenalkan Anda pada prinsip-prinsip dasar UI/UX design, perbedaan antara UI dan UX, dan peran desainer dalam proses pengembangan produk.',
          ),
          CourseModule(
            title: 'User Research',
            duration: 70,
            description: 'Pelajari cara melakukan user research untuk memahami kebutuhan dan perilaku pengguna. Modul ini mencakup user interviews, surveys, dan usability testing.',
          ),
          CourseModule(
            title: 'Wireframing dan Prototyping',
            duration: 85,
            description: 'Pelajari cara membuat wireframe dan prototype untuk menguji ide desain Anda. Modul ini mencakup penggunaan tools seperti Figma, Sketch, dan Adobe XD.',
          ),
          CourseModule(
            title: 'Visual Design',
            duration: 100,
            description: 'Pelajari prinsip-prinsip visual design seperti warna, tipografi, layout, dan iconography. Modul ini akan membantu Anda membuat desain yang menarik secara visual.',
          ),
          CourseModule(
            title: 'Interaction Design',
            duration: 90,
            description: 'Pelajari cara merancang interaksi yang intuitif dan menyenangkan. Modul ini mencakup microinteractions, animasi, dan feedback visual.',
          ),
          CourseModule(
            title: 'Design Systems',
            duration: 80,
            description: 'Pelajari cara membuat dan mengelola design system untuk menjaga konsistensi desain. Modul ini mencakup komponen, pattern, dan dokumentasi.',
          ),
          CourseModule(
            title: 'Proyek Akhir',
            duration: 150,
            description: 'Terapkan semua yang telah Anda pelajari dalam proyek akhir. Anda akan merancang aplikasi mobile dari awal hingga akhir, termasuk user research, wireframing, prototyping, dan visual design.',
          ),
        ],
      ),
      Course(
        title: 'Machine Learning Fundamentals',
        instructor: 'Alex Wilson',
        rating: 4.6,
        students: 756,
        price: 'Rp 499.000',
        icon: Icons.psychology,
        color: const Color(0xFF9C27B0),
        description: 'Kursus ini akan mengajarkan Anda dasar-dasar machine learning dan cara menerapkannya dalam proyek nyata. Anda akan belajar tentang algoritma machine learning, data preprocessing, dan evaluasi model. Di akhir kursus, Anda akan mampu membangun model machine learning untuk berbagai kasus penggunaan.',
        progress: 0, // Diubah ke 0
        completedModules: 0, // Diubah ke 0
        category: 'Pemrograman', // Kategori untuk Machine Learning
        modules: [
          CourseModule(
            title: 'Pengenalan Machine Learning',
            duration: 60,
            description: 'Modul ini memperkenalkan Anda pada konsep dasar machine learning, jenis-jenis machine learning, dan aplikasinya dalam dunia nyata.',
          ),
          CourseModule(
            title: 'Data Preprocessing',
            duration: 75,
            description: 'Pelajari cara mempersiapkan data untuk model machine learning. Modul ini mencakup cleaning, normalization, feature extraction, dan feature selection.',
          ),
          CourseModule(
            title: 'Supervised Learning',
            duration: 90,
            description: 'Pelajari algoritma supervised learning seperti linear regression, logistic regression, decision trees, dan support vector machines.',
          ),
          CourseModule(
            title: 'Unsupervised Learning',
            duration: 85,
            description: 'Pelajari algoritma unsupervised learning seperti clustering, dimensionality reduction, dan anomaly detection.',
          ),
          CourseModule(
            title: 'Deep Learning',
            duration: 120,
            description: 'Pelajari dasar-dasar deep learning dan neural networks. Modul ini mencakup feedforward networks, convolutional networks, dan recurrent networks.',
          ),
          CourseModule(
            title: 'Model Evaluation',
            duration: 70,
            description: 'Pelajari cara mengevaluasi dan meningkatkan performa model machine learning. Modul ini mencakup metrics, cross-validation, dan hyperparameter tuning.',
          ),
          CourseModule(
            title: 'Proyek Akhir',
            duration: 150,
            description: 'Terapkan semua yang telah Anda pelajari dalam proyek akhir. Anda akan membangun model machine learning end-to-end untuk menyelesaikan masalah dunia nyata.',
          ),
        ],
      ),
      // Menambahkan kursus baru untuk kategori lain
      Course(
        title: 'Bahasa Inggris untuk Bisnis',
        instructor: 'Emily Johnson',
        rating: 4.5,
        students: 623,
        price: 'Rp 249.000',
        icon: Icons.language,
        color: const Color(0xFFFFA500),
        description: 'Kursus ini akan mengajarkan Anda bahasa Inggris yang digunakan dalam konteks bisnis. Anda akan belajar tentang kosakata bisnis, presentasi, negosiasi, dan korespondensi bisnis. Di akhir kursus, Anda akan mampu berkomunikasi dengan percaya diri dalam situasi bisnis internasional.',
        progress: 0, // Diubah ke 0
        completedModules: 0, // Diubah ke 0
        category: 'Bahasa', // Kategori untuk Bahasa Inggris
        modules: [
          CourseModule(
            title: 'Pengenalan Bahasa Inggris Bisnis',
            duration: 45,
            description: 'Modul ini memperkenalkan Anda pada pentingnya bahasa Inggris dalam dunia bisnis global dan perbedaan antara bahasa Inggris umum dan bahasa Inggris bisnis.',
          ),
          CourseModule(
            title: 'Kosakata Bisnis',
            duration: 60,
            description: 'Pelajari kosakata yang umum digunakan dalam konteks bisnis, termasuk istilah keuangan, pemasaran, dan manajemen.',
          ),
          CourseModule(
            title: 'Presentasi Bisnis',
            duration: 75,
            description: 'Pelajari cara menyampaikan presentasi bisnis yang efektif dalam bahasa Inggris, termasuk struktur presentasi, bahasa tubuh, dan cara menjawab pertanyaan.',
          ),
          CourseModule(
            title: 'Negosiasi',
            duration: 90,
            description: 'Pelajari teknik dan bahasa yang digunakan dalam negosiasi bisnis, termasuk cara menyampaikan penawaran, menanggapi keberatan, dan mencapai kesepakatan.',
          ),
          CourseModule(
            title: 'Korespondensi Bisnis',
            duration: 60,
            description: 'Pelajari cara menulis email, surat, dan dokumen bisnis lainnya dalam bahasa Inggris yang profesional dan efektif.',
          ),
          CourseModule(
            title: 'Percakapan Telepon',
            duration: 45,
            description: 'Pelajari cara melakukan percakapan telepon bisnis dalam bahasa Inggris, termasuk cara menjawab telepon, meninggalkan pesan, dan mengatur janji.',
          ),
          CourseModule(
            title: 'Proyek Akhir',
            duration: 120,
            description: 'Terapkan semua yang telah Anda pelajari dalam proyek akhir. Anda akan melakukan simulasi situasi bisnis seperti rapat, presentasi, dan negosiasi.',
          ),
        ],
      ),
      Course(
        title: 'Digital Marketing Essentials',
        instructor: 'Michael Brown',
        rating: 4.7,
        students: 845,
        price: 'Rp 329.000',
        icon: Icons.business,
        color: const Color(0xFF4CAF50),
        description: 'Kursus ini akan mengajarkan Anda dasar-dasar pemasaran digital dan cara menerapkannya untuk mengembangkan bisnis. Anda akan belajar tentang SEO, media sosial, email marketing, dan analitik. Di akhir kursus, Anda akan mampu membuat strategi pemasaran digital yang efektif.',
        progress: 0, // Diubah ke 0
        completedModules: 0, // Diubah ke 0
        category: 'Bisnis', // Kategori untuk Digital Marketing
        modules: [
          CourseModule(
            title: 'Pengenalan Digital Marketing',
            duration: 50,
            description: 'Modul ini memperkenalkan Anda pada konsep dasar pemasaran digital, perbedaannya dengan pemasaran tradisional, dan berbagai saluran pemasaran digital.',
          ),
          CourseModule(
            title: 'Search Engine Optimization (SEO)',
            duration: 80,
            description: 'Pelajari cara mengoptimalkan website Anda untuk mesin pencari, termasuk riset kata kunci, optimasi on-page, dan strategi backlink.',
          ),
          CourseModule(
            title: 'Media Sosial Marketing',
            duration: 70,
            description: 'Pelajari cara menggunakan platform media sosial untuk pemasaran, termasuk strategi konten, jadwal posting, dan iklan media sosial.',
          ),
          CourseModule(
            title: 'Email Marketing',
            duration: 60,
            description: 'Pelajari cara membuat kampanye email yang efektif, termasuk segmentasi, personalisasi, dan otomatisasi email.',
          ),
          CourseModule(
            title: 'Content Marketing',
            duration: 75,
            description: 'Pelajari cara membuat dan mendistribusikan konten yang berharga untuk menarik dan mempertahankan audiens yang ditargetkan.',
          ),
          CourseModule(
            title: 'Analitik dan Pengukuran',
            duration: 65,
            description: 'Pelajari cara menggunakan alat analitik untuk mengukur keberhasilan kampanye pemasaran digital Anda dan membuat keputusan berdasarkan data.',
          ),
          CourseModule(
            title: 'Proyek Akhir',
            duration: 130,
            description: 'Terapkan semua yang telah Anda pelajari dalam proyek akhir. Anda akan membuat strategi pemasaran digital komprehensif untuk bisnis nyata atau fiktif.',
          ),
        ],
      ),
      Course(
        title: 'Fotografi Dasar',
        instructor: 'Sarah Lee',
        rating: 4.8,
        students: 712,
        price: 'Rp 279.000',
        icon: Icons.camera_alt,
        color: const Color(0xFF9C27B0), // Warna disesuaikan dengan kategori Desain/Fotografi
        description: 'Kursus ini akan mengajarkan Anda dasar-dasar fotografi dan cara mengambil foto yang menarik. Anda akan belajar tentang komposisi, pencahayaan, pengaturan kamera, dan editing foto. Di akhir kursus, Anda akan mampu mengambil foto yang profesional dengan peralatan apa pun.',
        progress: 0, // Diubah ke 0
        completedModules: 0, // Diubah ke 0
        category: 'Fotografi', // Kategori untuk Fotografi
        modules: [
          CourseModule(
            title: 'Pengenalan Fotografi',
            duration: 40,
            description: 'Modul ini memperkenalkan Anda pada dasar-dasar fotografi, jenis-jenis kamera, dan peralatan fotografi.',
          ),
          CourseModule(
            title: 'Pengaturan Kamera',
            duration: 70,
            description: 'Pelajari cara menggunakan pengaturan kamera seperti aperture, shutter speed, dan ISO untuk mengontrol eksposur dan efek kreatif.',
          ),
          CourseModule(
            title: 'Komposisi',
            duration: 60,
            description: 'Pelajari prinsip-prinsip komposisi fotografi seperti rule of thirds, leading lines, dan framing untuk membuat foto yang menarik secara visual.',
          ),
          CourseModule(
            title: 'Pencahayaan',
            duration: 80,
            description: 'Pelajari cara menggunakan cahaya alami dan buatan untuk menciptakan mood dan efek yang berbeda dalam foto Anda.',
          ),
          CourseModule(
            title: 'Genre Fotografi',
            duration: 90,
            description: 'Pelajari berbagai genre fotografi seperti potret, lanskap, street photography, dan makro, serta teknik khusus untuk masing-masing genre.',
          ),
          CourseModule(
            title: 'Editing Foto',
            duration: 75,
            description: 'Pelajari cara mengedit foto menggunakan software seperti Adobe Lightroom dan Photoshop untuk meningkatkan kualitas dan kreativitas foto Anda.',
          ),
          CourseModule(
            title: 'Proyek Akhir',
            duration: 100,
            description: 'Terapkan semua yang telah Anda pelajari dalam proyek akhir. Anda akan membuat portofolio fotografi yang mencakup berbagai genre dan teknik.',
          ),
        ],
      ),
      Course(
        title: 'Produksi Musik Digital',
        instructor: 'David Kim',
        rating: 4.6,
        students: 589,
        price: 'Rp 399.000',
        icon: Icons.music_note,
        color: const Color(0xFF2196F3),
        description: 'Kursus ini akan mengajarkan Anda cara memproduksi musik menggunakan software digital. Anda akan belajar tentang recording, mixing, mastering, dan distribusi musik. Di akhir kursus, Anda akan mampu memproduksi lagu berkualitas profesional dari rumah Anda.',
        progress: 0, // Diubah ke 0
        completedModules: 0, // Diubah ke 0
        category: 'Musik', // Kategori untuk Musik
        modules: [
          CourseModule(
            title: 'Pengenalan Produksi Musik Digital',
            duration: 45,
            description: 'Modul ini memperkenalkan Anda pada konsep dasar produksi musik digital, perangkat keras dan perangkat lunak yang diperlukan, dan workflow produksi musik.',
          ),
          CourseModule(
            title: 'Digital Audio Workstation (DAW)',
            duration: 80,
            description: 'Pelajari cara menggunakan DAW seperti Ableton Live, FL Studio, atau Logic Pro untuk merekam, mengedit, dan memproduksi musik.',
          ),
          CourseModule(
            title: 'Teori Musik untuk Produser',
            duration: 70,
            description: 'Pelajari dasar-dasar teori musik yang penting untuk produksi musik, termasuk skala, chord, dan struktur lagu.',
          ),
          CourseModule(
            title: 'Sound Design',
            duration: 90,
            description: 'Pelajari cara membuat dan memanipulasi suara menggunakan synthesizer, sampler, dan efek untuk menciptakan suara unik untuk musik Anda.',
          ),
          CourseModule(
            title: 'Mixing',
            duration: 100,
            description: 'Pelajari cara mencampur berbagai elemen musik seperti vokal, instrumen, dan efek untuk menciptakan keseimbangan dan kejelasan dalam lagu Anda.',
          ),
          CourseModule(
            title: 'Mastering',
            duration: 85,
            description: 'Pelajari cara melakukan mastering pada lagu Anda untuk mempersiapkannya untuk distribusi, termasuk EQ, kompresi, dan limiting.',
          ),
          CourseModule(
            title: 'Proyek Akhir',
            duration: 150,
            description: 'Terapkan semua yang telah Anda pelajari dalam proyek akhir. Anda akan memproduksi lagu lengkap dari awal hingga akhir, termasuk komposisi, recording, mixing, dan mastering.',
          ),
        ],
      ),
      Course(
        title: 'Yoga untuk Pemula',
        instructor: 'Lisa Chen',
        rating: 4.9,
        students: 934,
        price: 'Rp 199.000',
        icon: Icons.fitness_center,
        color: const Color(0xFFFF5722),
        description: 'Kursus ini akan mengajarkan Anda dasar-dasar yoga dan cara mempraktikkannya dengan aman. Anda akan belajar tentang berbagai pose yoga, teknik pernapasan, dan meditasi. Di akhir kursus, Anda akan memiliki praktik yoga yang solid untuk meningkatkan kesehatan fisik dan mental Anda.',
        progress: 0, // Diubah ke 0
        completedModules: 0, // Diubah ke 0
        category: 'Kesehatan', // Kategori untuk Yoga
        modules: [
          CourseModule(
            title: 'Pengenalan Yoga',
            duration: 30,
            description: 'Modul ini memperkenalkan Anda pada filosofi dan manfaat yoga, serta berbagai jenis yoga yang dapat Anda praktikkan.',
          ),
          CourseModule(
            title: 'Pose Dasar',
            duration: 60,
            description: 'Pelajari pose yoga dasar seperti mountain pose, downward dog, dan warrior poses, serta cara melakukannya dengan benar dan aman.',
          ),
          CourseModule(
            title: 'Teknik Pernapasan',
            duration: 45,
            description: 'Pelajari berbagai teknik pernapasan yoga (pranayama) yang dapat membantu Anda mengurangi stres, meningkatkan energi, dan memperdalam praktik yoga Anda.',
          ),
          CourseModule(
            title: 'Sequence untuk Pemula',
            duration: 75,
            description: 'Pelajari cara menggabungkan pose yoga menjadi sequence yang mengalir dan seimbang untuk praktik harian Anda.',
          ),
          CourseModule(
            title: 'Meditasi',
            duration: 40,
            description: 'Pelajari dasar-dasar meditasi dan cara mengintegrasikannya ke dalam praktik yoga Anda untuk meningkatkan kesadaran dan ketenangan mental.',
          ),
          CourseModule(
            title: 'Yoga untuk Kondisi Khusus',
            duration: 55,
            description: 'Pelajari modifikasi pose yoga untuk kondisi khusus seperti sakit punggung, kehamilan, dan mobilitas terbatas.',
          ),
          CourseModule(
            title: 'Proyek Akhir',
            duration: 90,
            description: 'Terapkan semua yang telah Anda pelajari dalam proyek akhir. Anda akan membuat praktik yoga personal yang sesuai dengan kebutuhan dan tujuan Anda.',
          ),
        ],
      ),
    ];
  }
}

class CourseModule {
  final String title;
  final int duration; // dalam menit
  final String description;

  CourseModule({
    required this.title,
    required this.duration,
    required this.description,
  });
}
