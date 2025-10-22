import 'package:flutter/material.dart';

// ---------------------------------------------
// 1. MÔ HÌNH DỮ LIỆU KHÓA HỌC
// ---------------------------------------------
class Course {
  final String name;
  final String lecturer;
  final String topic;
  final String level; // Mức độ: Cơ bản, Trung cấp, Nâng cao
  final double rating;
  final int enrollments;
  final String imageUrl;

  Course({
    required this.name,
    required this.lecturer,
    required this.topic,
    required this.level,
    required this.rating,
    required this.enrollments,
    required this.imageUrl,
  });
}

// ---------------------------------------------
// 2. DỮ LIỆU MOCK (Giả lập từ API)
// ---------------------------------------------
final List<Course> _mockCourses = [
  Course(name: "Phân tích Dữ liệu với Python", lecturer: "PGS. Tiến", topic: "Data Science", level: "Cơ bản", rating: 4.8, enrollments: 1200, imageUrl: 'https://placehold.co/600x400/2563EB/ffffff?text=Python'),
  Course(name: "Cấu trúc Dữ liệu và Giải thuật", lecturer: "TS. Hiếu", topic: "Programming", level: "Trung cấp", rating: 4.5, enrollments: 850, imageUrl: 'https://placehold.co/600x400/D97706/ffffff?text=DSA'),
  Course(name: "Lập trình Di động Flutter", lecturer: "Mr. Minh", topic: "Mobile", level: "Nâng cao", rating: 4.9, enrollments: 2100, imageUrl: 'https://placehold.co/600x400/10B981/ffffff?text=Flutter'),
  Course(name: "Thiết kế Giao diện UI/UX", lecturer: "Cô Thảo", topic: "Design", level: "Cơ bản", rating: 4.7, enrollments: 950, imageUrl: 'https://placehold.co/600x400/EF4444/ffffff?text=UI/UX'),
  Course(name: "Kinh tế học Vi mô", lecturer: "GS. Lan", topic: "Business", level: "Trung cấp", rating: 4.2, enrollments: 400, imageUrl: 'https://placehold.co/600x400/6366F1/ffffff?text=Economics'),
  Course(name: "Machine Learning Cơ bản", lecturer: "PGS. Tiến", topic: "Data Science", level: "Nâng cao", rating: 4.6, enrollments: 1500, imageUrl: 'https://placehold.co/600x400/9333EA/ffffff?text=ML'),
];

final List<String> _topics = ['Tất cả', 'Data Science', 'Programming', 'Mobile', 'Design', 'Business'];
final List<String> _levels = ['Tất cả', 'Cơ bản', 'Trung cấp', 'Nâng cao'];

// ---------------------------------------------
// 3. WIDGET CHÍNH: CATALOG SCREEN
// ---------------------------------------------
class CourseCatalogScreen extends StatefulWidget {
  const CourseCatalogScreen({super.key});

  @override
  State<CourseCatalogScreen> createState() => _CourseCatalogScreenState();
}

class _CourseCatalogScreenState extends State<CourseCatalogScreen> {
  // Biến trạng thái cho bộ lọc và tìm kiếm
  String _searchText = '';
  String _selectedTopic = 'Tất cả';
  String _selectedLevel = 'Tất cả';
  String _selectedLecturer = 'Tất cả';

  // Lấy danh sách giảng viên duy nhất từ dữ liệu mock
  late List<String> _lecturers;

  @override
  void initState() {
    super.initState();
    // Khởi tạo danh sách giảng viên cho bộ lọc
    _lecturers = ['Tất cả', ..._mockCourses.map((c) => c.lecturer).toSet()];
  }

  // Hàm Lọc và Tìm kiếm
  List<Course> get _filteredCourses {
    return _mockCourses.where((course) {
      // 1. Tìm kiếm theo tên
      if (_searchText.isNotEmpty && !course.name.toLowerCase().contains(_searchText.toLowerCase())) {
        return false;
      }
      // 2. Lọc theo Chủ đề
      if (_selectedTopic != 'Tất cả' && course.topic != _selectedTopic) {
        return false;
      }
      // 3. Lọc theo Mức độ
      if (_selectedLevel != 'Tất cả' && course.level != _selectedLevel) {
        return false;
      }
      // 4. Lọc theo Giảng viên
      if (_selectedLecturer != 'Tất cả' && course.lecturer != _selectedLecturer) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục Khóa học', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Thanh Tìm kiếm
          _buildSearchBar(),
          // Bộ lọc (Chips)
          _buildFilterChips(),
          
          // Thẻ Tổng quan Khóa học
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Tìm thấy ${_filteredCourses.length} khóa học',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),

          // Danh sách Khóa học Đã lọc
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredCourses.length,
              itemBuilder: (context, index) {
                return CourseCard(course: _filteredCourses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------- WIDGETS CON -------------------------

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tên khóa học...',
          prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
        onChanged: (value) {
          setState(() {
            _searchText = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Lọc theo Chủ đề
          _buildDropdownFilter(
            'Chủ đề', 
            _topics, 
            _selectedTopic, 
            (String? newValue) {
              setState(() {
                _selectedTopic = newValue!;
              });
            },
          ),
          const SizedBox(width: 8),
          
          // Lọc theo Giảng viên
          _buildDropdownFilter(
            'Giảng viên', 
            _lecturers, 
            _selectedLecturer, 
            (String? newValue) {
              setState(() {
                _selectedLecturer = newValue!;
              });
            },
          ),
          const SizedBox(width: 8),

          // Lọc theo Mức độ
          _buildDropdownFilter(
            'Mức độ', 
            _levels, 
            _selectedLevel, 
            (String? newValue) {
              setState(() {
                _selectedLevel = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(String label, List<String> items, String currentValue, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
          style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
          dropdownColor: Colors.white,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}


// ---------------------------------------------
// 4. WIDGET COURSE CARD
// ---------------------------------------------
class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mở chi tiết khóa học: ${course.name}')),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh khóa học
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  course.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80, height: 80, color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Thông tin khóa học
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.lecturer,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    
                    // Đánh giá và Số người tham gia
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRating(course.rating),
                        Text(
                          '${course.enrollments} người tham gia',
                          style: TextStyle(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
