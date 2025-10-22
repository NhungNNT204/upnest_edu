import 'package:flutter/material.dart';
// Import màn hình hồ sơ cá nhân
import 'profile_screen.dart';
// Import màn hình Quản lý Người dùng
import 'user_management_screen.dart';
// IMPORT MÀN HÌNH QUẢN LÝ KHÓA HỌC
import 'course_management_screen.dart';
// IMPORT MÀN HÌNH QUẢN LÝ TIN TỨC & SỰ KIỆN
import 'news_event_management.dart';
// IMPORT MÀN HÌNH QUẢN LÝ BÀI KIỂM TRA (MỚI THÊM)
import 'exam_management_screen.dart';

// IMPORT MÀN HÌNH QUẢN LÝ CHẤM ĐIỂM & ĐÁNH GIÁ
import 'grading_management_screen.dart';
// IMPORT MÀN HÌNH QUẢN LÝ TÀI NGUYÊN (THƯ VIỆN) (MỚI THÊM)
import 'resource_management_screen.dart';
// IMPORT MÀN HÌNH QUẢN LÝ THÔNG BÁO CHUNG (MỚI THÊM)
import 'announcement_management_screen.dart';

// --- WIDGET HỖ TRỢ CHO ADMIN DASHBOARD (ĐƯỢC TÍCH HỢP) ---

// Widget mô phỏng một biểu đồ đơn giản (Chart Placeholder)
class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biểu đồ Điểm Tổng Kết (Mô phỏng)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          // Giả lập các cột biểu đồ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(context, 'Kỳ 1', 0.8, Colors.blue),
              _buildBar(context, 'Kỳ 2', 0.65, Colors.green),
              _buildBar(context, 'Kỳ 3', 0.9, Colors.orange),
              _buildBar(context, 'Kỳ 4', 0.75, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context, String label, double heightRatio, Color color) {
    return Column(
      children: [
        Container(
          height: 150 * heightRatio, // Chiều cao tối đa 150
          width: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

// Widget hiển thị số liệu thống kê chính
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 30),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- CLASS ADMINHOMESCREEN CHÍNH ---

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  // Widget để tạo một nút chức năng đơn giản
  Widget _buildFeatureCard(
      BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      // Sử dụng InkWell để tạo hiệu ứng khi nhấn (ripple effect)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap, // Sử dụng hàm onTap được truyền vào
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hàm xử lý chung cho các card chưa có trang riêng
    void _defaultOnTap(String title) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bạn đã nhấn vào: $title'),
          duration: const Duration(milliseconds: 500),
        ),
      );
    }

    // Hàm xử lý chuyển trang Hồ sơ (Giữ nguyên)
    void _navigateToProfile() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
    
    // Hàm xử lý chuyển trang Quản lý Người dùng (Giữ nguyên)
    void _navigateToUserManagement() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserManagementScreen()), 
      );
    }

    // HÀM XỬ LÝ CHUYỂN TRANG QUẢN LÝ KHÓA HỌC (Giữ nguyên)
    void _navigateToCourseManagement() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CourseManagementScreen()),
      );
    }
    
    // HÀM XỬ LÝ CHUYỂN TRANG QUẢN LÝ TIN TỨC & SỰ KIỆN (Giữ nguyên)
    void _navigateToNewsEventManagement() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewsEventScreen(role: UserRole.admin)), 
      );
    }

    // HÀM XỬ LÝ CHUYỂN TRANG QUẢN LÝ BÀI KIỂM TRA (Sử dụng ExamManagementScreen)
    void _navigateToTestManagement() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExamManagementScreen()),
      );
    }
    
    // HÀM XỬ LÝ CHUYỂN TRANG QUẢN LÝ CHẤM ĐIỂM & ĐÁNH GIÁ
    void _navigateToGradingManagement() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GradingManagementScreen()),
      );
    }

    // HÀM XỬ LÝ CHUYỂN TRANG QUẢN LÝ TÀI NGUYÊN (MỚI THÊM)
    void _navigateToResourceManagement() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResourceManagementScreen()),
      );
    }

    // HÀM XỬ LÝ CHUYỂN TRANG QUẢN LÝ THÔNG BÁO CHUNG (MỚI THÊM)
    void _navigateToAnnouncementManagement() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AnnouncementManagementScreen()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang Chủ Quản Lý Sinh Viên'),
        automaticallyImplyLeading: false, // Ẩn nút back
        elevation: 1,
        shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // KHỐI CHÀO MỪNG (Banner)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.waving_hand,
                        size: 40,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Chào mừng bạn đến với hệ thống!',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onPrimaryContainer),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'UpNest Edu - Hệ thống quản lý giáo dục.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // KHỐI TÍNH NĂNG CHÍNH
              Text(
                'Các Tính Năng Chính',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15),

              // GridView chứa các Card tính năng
              GridView.count(
                shrinkWrap: true, // Quan trọng: GridView trong Column
                physics: const NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn GridView
                crossAxisCount: 2, // 2 cột
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5, // Tỷ lệ khung hình của mỗi item
                children: <Widget>[
                  // 1. Xem Điểm
                  _buildFeatureCard(
                    context,
                    'Xem Điểm',
                    Icons.score,
                    Colors.blue.shade600,
                    () => _defaultOnTap('Xem Điểm'),
                  ),
                  // 2. Quản lý Khóa học
                  _buildFeatureCard(
                    context,
                    'Quản lý Khóa học',
                    Icons.library_books,
                    Colors.indigo.shade600,
                    _navigateToCourseManagement,
                  ),
                  // 3. Quản lý Người dùng
                  _buildFeatureCard(
                    context,
                    'Quản lý Người dùng',
                    Icons.manage_accounts, // Icon phù hợp hơn
                    Colors.teal.shade600,
                    _navigateToUserManagement, // Hàm điều hướng cũ
                  ),
                  // 4. Tin tức & Sự kiện
                  _buildFeatureCard(
                    context,
                    'Tin tức & Sự kiện',
                    Icons.campaign, // Icon mới
                    Colors.deepOrange.shade600, // Đổi màu để khác biệt với Thông báo
                    _navigateToNewsEventManagement, // Hàm điều hướng cũ
                  ),
                  // 5. Quản lý Thông báo Chung (MỚI THÊM)
                  _buildFeatureCard(
                    context,
                    'Quản lý Thông báo Chung',
                    Icons.announcement,
                    Colors.pink.shade600,
                    _navigateToAnnouncementManagement, 
                  ),
                  // 6. Quản lý Bài kiểm tra
                  _buildFeatureCard(
                    context,
                    'Quản lý Bài kiểm tra',
                    Icons.quiz, // Icon phù hợp
                    Colors.brown.shade600, // Màu mới
                    _navigateToTestManagement, // Hàm điều hướng mới
                  ),
                  // 7. Quản lý Chấm điểm & Đánh giá (MỚI THÊM)
                  _buildFeatureCard(
                    context,
                    'Chấm điểm & Đánh giá',
                    Icons.grading, // Icon mới
                    Colors.amber.shade600, // Màu phù hợp
                    _navigateToGradingManagement, // Hàm điều hướng mới
                  ),
                  // 8. Quản lý Tài nguyên (Thư viện) (MỚI THÊM)
                  _buildFeatureCard(
                    context,
                    'Quản lý Tài nguyên',
                    Icons.local_library, // Icon phù hợp
                    Colors.blueGrey.shade600, // Màu mới
                    _navigateToResourceManagement, // Hàm điều hướng mới
                  ),
                  // 9. Hồ sơ cá nhân
                  _buildFeatureCard(
                    context,
                    'Hồ sơ cá nhân',
                    Icons.person,
                    Colors.red.shade600,
                    _navigateToProfile,
                  ),
                  // 10. Tính năng khác (Dự kiến)
                  _buildFeatureCard(
                    context,
                    'Tính năng Khác',
                    Icons.settings,
                    Colors.grey.shade600,
                    () => _defaultOnTap('Tính năng Khác'),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // --- BẮT ĐẦU PHẦN ADMIN DASHBOARD TÍCH HỢP ---
              Text(
                'TỔNG QUAN QUẢN TRỊ VIÊN (ADMIN DASHBOARD)',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              Text(
                'Thống Kê Chính',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Thống kê chính (Tổng số người dùng, Khóa học)
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const <Widget>[
                  StatCard(
                    title: 'Tổng số Người dùng',
                    value: '4,567',
                    icon: Icons.people_alt,
                    color: Colors.blue,
                  ),
                  StatCard(
                    title: 'Tổng số Khóa học',
                    value: '89',
                    icon: Icons.library_books,
                    color: Colors.green,
                  ),
                  StatCard(
                    title: 'Hoạt động Tuần này',
                    value: '128',
                    icon: Icons.local_activity,
                    color: Colors.orange,
                  ),
                  StatCard(
                    title: 'Tin nhắn Mới',
                    value: '14',
                    icon: Icons.message,
                    color: Colors.purple,
                  ),
                ],
              ),
              
              const SizedBox(height: 30),

              // Biểu đồ Điểm
              Text(
                'Phân Tích Dữ Liệu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              
              const SimpleBarChart(),
              
              const SizedBox(height: 30),

              // Hoạt động gần đây
              Text(
                'Hoạt Động Gần Đây',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: const ListTile(
                  leading: Icon(Icons.history, color: Colors.grey),
                  title: Text('10:30 - John Doe cập nhật hồ sơ'),
                  subtitle: Text('ID: 12345'),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: const ListTile(
                  leading: Icon(Icons.history, color: Colors.grey),
                  title: Text('09:15 - Jane Smith đăng ký khóa học mới'),
                  subtitle: Text('Khóa: Kỹ thuật lập trình'),
                ),
              ),
              // --- KẾT THÚC PHẦN ADMIN DASHBOARD TÍCH HỢP ---

              const SizedBox(height: 40),

              // Nút Đăng xuất
              OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Đăng xuất'),
                onPressed: () {
                  // Sử dụng pop để quay lại màn hình đăng nhập
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: BorderSide(color: Colors.red.shade300),
                  foregroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
