import 'package:flutter/material.dart';

// --- MOCK DATA MODELS (Mô hình dữ liệu giả lập) ---

class Instructor {
  final String name;
  final String title;
  final String bio;
  final String imageUrl;

  Instructor({required this.name, required this.title, required this.bio, required this.imageUrl});
}

class Lesson {
  final int id;
  final String title;
  final String duration;
  final bool isCompleted;

  Lesson({required this.id, required this.title, required this.duration, this.isCompleted = false});
}

class Review {
  final String author;
  final String text;
  final int rating;

  Review({required this.author, required this.text, required this.rating});
}

// --- MÀN HÌNH CHÍNH (MAIN SCREEN) ---

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  // Biến trạng thái giả lập: true = đã đăng ký, false = chưa đăng ký
  bool isEnrolled = false; 

  // Dữ liệu giả lập
  final instructor = Instructor(
    name: 'Nguyễn Văn A',
    title: 'Chuyên gia Full-Stack, 10 năm kinh nghiệm',
    bio: 'Từng làm việc tại Google và Facebook, có kinh nghiệm đào tạo hơn 5,000 học viên.',
    imageUrl: 'https://placehold.co/80x80/0000FF/FFFFFF?text=GV',
  );

  final lessons = [
    Lesson(id: 1, title: 'Giới thiệu khóa học và môi trường', duration: '10:30', isCompleted: true),
    Lesson(id: 2, title: 'Cú pháp cơ bản của Dart/Flutter', duration: '25:15', isCompleted: false),
    Lesson(id: 3, title: 'Xây dựng Widget đầu tiên', duration: '40:00', isCompleted: false),
    Lesson(id: 4, title: 'Quản lý State trong Flutter', duration: '30:45', isCompleted: false),
  ];
  
  final featuredReviews = [
    Review(author: 'Lê Văn B', text: 'Giảng viên giảng dễ hiểu, đặc biệt là phần Dart. Bài tập thực hành rất sát với thực tế.', rating: 5),
    Review(author: 'Phạm Thị C', text: 'Tài liệu phong phú, diễn đàn Q&A được hỗ trợ nhanh chóng. Rất đáng tiền!', rating: 5),
  ];

  // Hàm chuyển đổi trạng thái (chỉ để minh họa)
  void toggleEnrollment() {
    setState(() {
      isEnrolled = !isEnrolled;
    });
  }

  // --- WIDGET CHỨC NĂNG ---

  // 1. Phần Thống kê Nhanh và Nút Hành động
  Widget _buildQuickStatsAndActions(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thống kê Nhanh',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10b981)),
            ),
            const Divider(height: 20),
            
            _statRow(Icons.library_books, 'Số bài học:', '50 bài'),
            _statRow(Icons.timer, 'Thời lượng Video:', '45 giờ'),
            
            const SizedBox(height: 15),
            const Text(
              'Yêu cầu Đầu vào:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const Text(
              'Kiến thức cơ bản về lập trình, có tư duy logic là một lợi thế.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 25),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _statRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF10b981), size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 15)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (isEnrolled) {
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
            label: const Text('Vào học Ngay'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              backgroundColor: const Color(0xFF10b981), // secondary
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: toggleEnrollment,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: Colors.red, width: 2),
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text('Hủy đăng ký'),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: toggleEnrollment,
            icon: const Icon(Icons.app_registration),
            label: const Text('Đăng ký Khóa học (999,000 VNĐ)'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              backgroundColor: const Color(0xFF4f46e5), // primary
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              elevation: 8,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Đăng ký ngay để nhận ưu đãi 20%',
            style: TextStyle(fontSize: 13, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }

  // 2. Phần Nội dung Khóa học chi tiết (Mô tả, Giảng viên, Đề cương)
  Widget _buildCourseContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mô tả Khóa học
          _contentSection(
            'Mô tả Khóa học',
            const Text(
              'Khóa học này được thiết kế để biến bạn từ người mới bắt đầu thành một nhà phát triển Flutter/Dart chuyên nghiệp. Chúng tôi bao gồm các công nghệ cốt lõi, từ giao diện đến database. Sau khi hoàn thành, bạn sẽ có khả năng tự xây dựng và triển khai các dự án thực tế.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ),

          // Giảng viên
          _buildInstructorInfo(),

          // Đề cương
          _buildSyllabus(),
        ],
      ),
    );
  }

  Widget _buildInstructorInfo() {
    return _contentSection(
      'Giảng viên',
      Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(instructor.imageUrl),
            backgroundColor: Colors.indigo.shade100,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  instructor.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  instructor.title,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF4f46e5)),
                ),
                const SizedBox(height: 5),
                Text(
                  instructor.bio,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyllabus() {
    final chapters = ['Nền tảng Dart/Flutter', 'Thiết kế UI Responsive', 'Quản lý State Nâng cao', 'Kết nối API và Database'];
    return _contentSection(
      'Đề cương Chi tiết & Cấu trúc Bài học',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...chapters.map((chapter) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFf3f4f6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.folder_open, color: Color(0xFF4f46e5), size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(chapter, style: const TextStyle(fontWeight: FontWeight.w500))),
                ],
              ),
            ),
          )).toList(),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: const Text('Tải Đề cương chi tiết (PDF)', style: TextStyle(color: Colors.indigo)),
          ),
        ],
      ),
    );
  }


  // 3. Phần Nội dung Học viên (Conditional Enrolled Content)
  Widget _buildEnrolledContent() {
    if (!isEnrolled) return const SizedBox.shrink(); // Ẩn nếu chưa đăng ký

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Danh sách Bài học
          _contentSection(
            'Danh sách Bài học (4/50 Hoàn thành)',
            Column(
              children: lessons.map((lesson) => _buildLessonItem(lesson)).toList(),
            ),
            isCard: true,
          ),

          // Tài liệu, Bài tập, Diễn đàn Q&A
          _buildExtraResources(),
        ],
      ),
    );
  }

  Widget _buildLessonItem(Lesson lesson) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      leading: Icon(
        lesson.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: lesson.isCompleted ? const Color(0xFF10b981) : Colors.indigo,
      ),
      title: Text(
        '${lesson.id}. ${lesson.title}',
        style: TextStyle(
          decoration: lesson.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          color: lesson.isCompleted ? Colors.grey : Colors.black,
        ),
      ),
      trailing: Text(lesson.duration),
      onTap: () {
        // Hành động khi nhấn vào bài học
      },
    );
  }

  Widget _buildExtraResources() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _resourceItem(Icons.folder_open, 'Tài liệu Đi kèm'),
            _resourceItem(Icons.edit_note, 'Bài tập & Thử thách'),
            _resourceItem(Icons.forum, 'Diễn đàn Q&A'),
          ],
        ),
      ),
    );
  }

  Widget _resourceItem(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF4f46e5), size: 30),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
  
  // 4. Phần Đánh giá
  Widget _buildReviews() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Đánh giá Nổi bật (4.8/5)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Xem tất cả đánh giá', style: TextStyle(color: Colors.indigo)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          Column(
            children: featuredReviews.map((review) => _buildReviewCard(review)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 5),
                Text(
                  review.author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              '"${review.text}"',
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget chung cho các section nội dung
  Widget _contentSection(String title, Widget content, {bool isCard = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: isCard 
          ? Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const Divider(),
                    content,
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const Divider(),
                content,
              ],
            ),
    );
  }

  // --- BUILD METHOD CHÍNH ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Khóa Học'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Tiêu đề Khóa học
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lập trình Mobile App Toàn diện với Flutter/Dart',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Học cách xây dựng ứng dụng di động đa nền tảng (iOS & Android) từ cơ bản đến nâng cao.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // 1. Thống kê Nhanh và Nút Hành động (Đầu tiên trên mobile)
            _buildQuickStatsAndActions(context),
            const SizedBox(height: 20),

            // 2. Nội dung Chi tiết Khóa học
            _buildCourseContent(),
            const SizedBox(height: 10),

            // 3. Nội dung dành cho Học viên đã đăng ký (Conditional)
            _buildEnrolledContent(),
            const SizedBox(height: 10),

            // 4. Đánh giá
            _buildReviews(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Đây là ví dụ về cách chạy ứng dụng (chỉ để kiểm tra)
// void main() {
//   runApp(const MaterialApp(
//     home: CourseDetailScreen(),
//   ));
// }
