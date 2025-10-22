import 'package:flutter/material.dart';

// --- MOCK DATA MODELS (Mô hình dữ liệu giả lập) ---

// Sử dụng lại mô hình Course cơ bản
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

// --- MÀN HÌNH CHÍNH (MAIN SCREEN) ---

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

  // --- WIDGET CHỨC NĂNG ---

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
          // Điều hướng đến Chi tiết khóa học
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chuyển đến Danh mục Khóa học để khám phá')),
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

  // --- BUILD METHOD CHÍNH ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khóa học của tôi'),
        backgroundColor: const Color(0xFF4f46e5),
        foregroundColor: Colors.white,
        elevation: 0,
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
          // Tab 1: Đang học
          _buildCourseList('enrolled'),

          // Tab 2: Đã hoàn thành
          _buildCourseList('completed'),

          // Tab 3: Muốn học (Wishlist)
          _buildCourseList('wishlist'),
        ],
      ),
    );
  }
}

// LƯU Ý: Để chạy màn hình này, bạn cần gọi nó trong hàm main() hoặc một route của ứng dụng Flutter:
// void main() {
//   runApp(const MaterialApp(
//     home: MyCoursesScreen(),
//   ));
// }
