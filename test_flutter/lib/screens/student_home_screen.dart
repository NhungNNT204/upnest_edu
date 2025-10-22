import 'package:flutter/material.dart';

// -------------------------------------------------------------------
// --- WIDGET MỚI: MÀN HÌNH XEM BÀI HỌC/BÀI TẬP (Lesson View) ---
// -------------------------------------------------------------------
class LessonViewScreen extends StatelessWidget {
  final String lessonTitle;
  const LessonViewScreen({super.key, required this.lessonTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết Bài học', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.class_, size: 80, color: Colors.teal),
              const SizedBox(height: 16),
              const Text(
                'Nội dung Chi tiết Bài học',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Bạn đang xem nội dung cho:',
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 109, 109, 109)),
              ),
              const SizedBox(height: 4),
              Text(
                lessonTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.teal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text('Quay lại Dashboard', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGET PLACEHOLDER CHO MÀN HÌNH MỚI (Danh mục Khóa học) ---
// -------------------------------------------------------------------
class CourseCatalogScreen extends StatelessWidget {
  const CourseCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục Khóa học', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 80, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text(
              'Danh mục Khóa học',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tìm kiếm, khám phá và đăng ký các khóa học mới.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại Dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- MÀN HÌNH KHÓA HỌC CỦA TÔI (My Courses Screen) ---
// -------------------------------------------------------------------

// MOCK DATA MODELS (Mô hình dữ liệu giả lập)
class Course {
  final String id;
  final String title;
  final String instructor;
  final int progressPercent;
  final String status; // 'enrolled', 'completed', 'wishlist'

  Course({
    required this.id,
    required this.title,
    required this.instructor,
    this.progressPercent = 0,
    required this.status,
  });
}

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dữ liệu giả lập
  final List<Course> _allCourses = [
    // Đang học
    Course(id: 'FLT001', title: 'Flutter Toàn diện từ A-Z', instructor: 'Nguyễn Văn A', progressPercent: 65, status: 'enrolled'),
    Course(id: 'WEB005', title: 'Phát triển Web với ReactJS', instructor: 'Lê Thị H', progressPercent: 12, status: 'enrolled'),

    // Đã hoàn thành
    Course(id: 'PYT003', title: 'Python cho Người mới bắt đầu', instructor: 'Trần Minh B', progressPercent: 100, status: 'completed'),

    // Muốn học
    Course(id: 'DS010', title: 'Khoa học Dữ liệu Cơ bản', instructor: 'Phạm Văn C', status: 'wishlist'),
    Course(id: 'UIX012', title: 'Thiết kế UX/UI Chuyên sâu', instructor: 'Hoàng Ngọc D', status: 'wishlist'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 1. Course Card Component
  Widget _buildCourseCard(Course course) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: course.status == 'enrolled' ? Colors.indigo.shade100 : Colors.teal.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCourseIcon(course.status),
            color: course.status == 'enrolled' ? Colors.indigo.shade700 : Colors.teal.shade700,
            size: 30,
          ),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Giảng viên: ${course.instructor}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            if (course.status == 'enrolled') ...[
              const SizedBox(height: 8),
              _buildProgressIndicator(course.progressPercent),
            ] else if (course.status == 'completed') ...[
              const SizedBox(height: 4),
              const Chip(
                label: Text('Đã nhận Chứng chỉ', style: TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: Color(0xFF10b981),
                visualDensity: VisualDensity.compact,
              )
            ],
          ],
        ),
        trailing: course.status == 'wishlist'
            ? const Icon(Icons.favorite, color: Colors.pink)
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Xem chi tiết khóa học: ${course.title}')),
          );
        },
      ),
    );
  }

  IconData _getCourseIcon(String status) {
    switch (status) {
      case 'enrolled':
        return Icons.rocket_launch;
      case 'completed':
        return Icons.verified;
      case 'wishlist':
        return Icons.bookmark;
      default:
        return Icons.school;
    }
  }

  Widget _buildProgressIndicator(int progress) {
    Color progressColor = progress < 50 ? Colors.orange : const Color(0xFF10b981);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiến độ: $progress%', style: TextStyle(fontSize: 12, color: progressColor, fontWeight: FontWeight.w600)),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  // 2. Empty State Component
  Widget _buildEmptyState(String title, String suggestion) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              suggestion,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Điều hướng đến Danh mục Khóa học
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CourseCatalogScreen()),
                );
              },
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text('Khám phá Khóa học', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4f46e5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Tab Content List Builder
  Widget _buildCourseList(String status) {
    final filteredCourses = _allCourses.where((course) => course.status == status).toList();

    if (filteredCourses.isEmpty) {
      String title;
      String suggestion;
      if (status == 'enrolled') {
        title = 'Bạn chưa tham gia khóa học nào';
        suggestion = 'Hãy khám phá các khóa học mới và bắt đầu hành trình học tập của bạn!';
      } else if (status == 'completed') {
        title = 'Chưa có khóa học hoàn thành';
        suggestion = 'Tiếp tục học tập để nhận chứng chỉ đầu tiên của bạn.';
      } else { // wishlist
        title = 'Danh sách muốn học đang trống';
        suggestion = 'Lưu các khóa học bạn quan tâm để xem lại sau này.';
      }
      return _buildEmptyState(title, suggestion);
    }

    return ListView.builder(
      itemCount: filteredCourses.length,
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 20),
      itemBuilder: (context, index) {
        return _buildCourseCard(filteredCourses[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khóa học của tôi', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4f46e5),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Đang học'),
            Tab(text: 'Hoàn thành'),
            Tab(text: 'Muốn học'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCourseList('enrolled'),
          _buildCourseList('completed'),
          _buildCourseList('wishlist'),
        ],
      ),
    );
  }
}


// -------------------------------------------------------------------
// --- MÀN HÌNH DASHBOARD HỌC VIÊN (StudentHomeScreen) ---
// -------------------------------------------------------------------

// Màn hình Dashboard dành cho Học viên
class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  // --- DỮ LIỆU GIẢ ĐỊNH MỚI ---
  final String studentName = "Trần Thị Kim Tiến";
  final String studentID = "SV24080004";
  final String currentGPA = "3.75 / 4.0";

  final int learningStreak = 15;
  final int currentXP = 4500;
  final String currentLevel = "Novice Coder (Level 4)";
  final String nextClass = "Lập trình Di động (14:00 - 16:30)";

  final List<Map<String, dynamic>> enrolledCourses = const [
    {'name': 'Lập trình Di động', 'progress': 75},
    {'name': 'Cấu trúc Dữ liệu', 'progress': 40},
    {'name': 'Thiết kế UX/UI', 'progress': 90},
  ];

  final List<Map<String, dynamic>> todayTasks = const [
    {'title': 'Quiz: Biến và Kiểu dữ liệu', 'due': 'Hôm nay, 17:00', 'color': Colors.red},
    {'title': 'Đọc chương 5: Flutter State', 'due': 'Hôm nay, 23:59', 'color': Colors.blue},
  ];

  final List<String> suggestedCourses = const [
    'Khoa học Dữ liệu',
    'Trí tuệ Nhân tạo',
    'Phát triển Game',
    'An toàn Thông tin',
  ];
  
  // DỮ LIỆU CẬP NHẬT: Thêm nút "Khóa học của tôi" và đổi tên "Khóa học" thành "Danh mục KH"
  final List<Map<String, dynamic>> quickActions = const [
    {'label': 'Danh mục KH', 'icon': Icons.search, 'color': Colors.indigo, 'screen': CourseCatalogScreen()},
    {'label': 'Khóa học của tôi', 'icon': Icons.my_library_books, 'color': Colors.deepPurple, 'screen': MyCoursesScreen()}, // Nút MỚI
    {'label': 'Thời khóa biểu', 'icon': Icons.calendar_today, 'color': Colors.orange},
    {'label': 'Xem Điểm', 'icon': Icons.bar_chart, 'color': Colors.green},
    {'label': 'Học Phí', 'icon': Icons.payment, 'color': Colors.redAccent},
    {'label': 'Tài liệu', 'icon': Icons.library_books, 'color': Colors.blueGrey},
    {'label': 'Hỗ trợ', 'icon': Icons.help_outline, 'color': Colors.purple},
    // {'label': 'Cài đặt', 'icon': Icons.settings, 'color': Colors.teal}, // Giảm bớt 1 nút để lưới gọn hơn
  ];
  // --- KẾT THÚC DỮ LIỆU GIẢ ĐỊNH ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Học viên', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Thẻ chào mừng và thông tin chung
            _buildWelcomeCard(context),
            const SizedBox(height: 20),

            // 2. Gamification: Streak và XP/Level
            _buildGamificationCard(context),
            const SizedBox(height: 20),

            // 3. Việc cần làm Hôm nay (ĐÃ CẬP NHẬT ĐIỀU HƯỚNG)
            _buildTodayTasks(context),
            const SizedBox(height: 20),
            
            // 4. Lưới chức năng nhanh (Existing)
            const Text(
              'Các Chức năng Nhanh',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildQuickActionsGrid(context),
            const SizedBox(height: 20),

            // 5. Tổng quan Khóa học & Tiến độ
            _buildPersonalOverview(context),
            const SizedBox(height: 20),

            // 6. Lớp học sắp tới (Existing)
            const Text(
              'Lớp học Sắp tới',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildNextClassCard(context), // Cần truyền context
            const SizedBox(height: 20),

            // 7. Gợi ý Khóa học
            _buildCourseSuggestions(context),
          ],
        ),
      ),
    );
  }

  // Widget 1: Thẻ chào mừng và GPA/Mã SV
  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chào mừng trở lại!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            studentName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Divider(color: Colors.white54, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn('Mã SV', studentID),
              _buildInfoColumn('GPA Hiện tại', currentGPA),
            ],
          ),
        ],
      ),
    );
  }

  // Widget phụ: Cột thông tin nhỏ
  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  // Widget 2: Gamification Card
  Widget _buildGamificationCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Chuỗi ngày học liên tục (Streak)
            Column(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 30),
                const SizedBox(height: 4),
                Text('$learningStreak ngày', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text('Streak', style: TextStyle(color: Colors.grey)),
              ],
            ),
            // Tách giữa
            Container(
              height: 60,
              width: 1,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            // XP và Cấp độ
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cấp độ: $currentLevel', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('$currentXP XP', style: const TextStyle(color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(
                    value: (currentXP % 1000) / 1000, // Giả sử 1000 XP là 1 cấp độ
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget 3: Việc cần làm Hôm nay (ĐÃ CẬP NHẬT)
  Widget _buildTodayTasks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Việc cần làm Hôm nay',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...todayTasks.map((task) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Icon(Icons.assignment, color: task['color'] as Color, size: 30),
                title: Text(task['title'] as String),
                subtitle: Text('Hạn: ${task['due']}', style: TextStyle(color: task['color'] as Color)),
                trailing: const Icon(Icons.chevron_right),
                // --- CẬP NHẬT: Điều hướng đến LessonViewScreen ---
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonViewScreen(lessonTitle: task['title'] as String),
                    ),
                  );
                },
                // ------------------------------------------------
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
  
  // Widget 4: Lưới các hành động nhanh (CẬP NHẬT)
  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: quickActions.map((action) {
        // Sử dụng giá trị mặc định là null nếu 'screen' không tồn tại
        Widget? destinationScreen = action.containsKey('screen') ? action['screen'] as Widget? : null;

        return _buildActionButton(
          context, 
          action['icon'] as IconData, 
          action['label'] as String, 
          action['color'] as Color, 
          destinationScreen, 
        );
      }).toList(),
    );
  }

  // Widget phụ: Nút hành động nhanh (CẬP NHẬT để xử lý điều hướng)
  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, [Widget? destinationScreen]) {
    return InkWell(
      onTap: () {
        if (destinationScreen != null) {
          // Xử lý điều hướng đến màn hình đích
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          );
        } else {
          // Xử lý cho các chức năng đang phát triển
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chức năng "$label" đang được xây dựng.')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // Widget 5: Tổng quan Khóa học & Tiến độ
  Widget _buildPersonalOverview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tiến độ Khóa học Đang học',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...enrolledCourses.map((course) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      course['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text('${course['progress']}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: (course['progress'] as int) / 100,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.green,
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // Widget 6: Lớp học sắp tới (Existing)
  // FIX: Thêm BuildContext context vào tham số
  Widget _buildNextClassCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: const Icon(Icons.access_time_filled, color: Colors.indigo, size: 40),
        title: const Text(
          'Tiết học tiếp theo',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          nextClass,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
            // FIX LỖI: Thay null bằng context
           Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => LessonViewScreen(lessonTitle: nextClass),
              ),
            );
        },
      ),
    );
  }
  
  // Widget 7: Gợi ý Khóa học
  Widget _buildCourseSuggestions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gợi ý Khóa học Mới',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150, // Chiều cao cố định cho list view ngang
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: suggestedCourses.length,
            itemBuilder: (context, index) {
              final course = suggestedCourses[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.laptop_chromebook, color: Colors.blueAccent),
                    Text(
                      course,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ElevatedButton(
                      onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('Đăng ký khóa học: $course')),
                          );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Đăng ký', style: TextStyle(fontSize: 12, color: Colors.white)),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// // Hàm main để chạy ứng dụng (chỉ để minh họa)
// void main() {
//   runApp(const MaterialApp(
//     title: 'Student App',
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//       useMaterial3: true,
//       colorScheme: ColorScheme.light(primary: Colors.blueAccent),
//     ),
//     // FIX LỖI: Thêm const vào StudentHomeScreen()
//     home: const StudentHomeScreen(), 
//   ));
// }
