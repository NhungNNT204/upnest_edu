import 'package:flutter/material.dart';

// --- 1. MÔ HÌNH DỮ LIỆU ---

class Course {
  final String id;
  final String name;
  final String description;
  final String lecturer;
  final String semester;
  final String schedule; // Ví dụ: Mon (9:00-11:00)

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.lecturer,
    required this.semester,
    required this.schedule,
  });
}

// --- 2. DỮ LIỆU MÔ PHỎNG VÀ LỰA CHỌN FILTER ---

final List<Course> _allCourses = [
  Course(id: 'CS101', name: 'Lập Trình Cơ Bản', description: 'Giới thiệu về Dart và Flutter', lecturer: 'TS. Nguyễn Văn A', semester: 'HK1 (2024-2025)', schedule: 'Thứ 2 (9h-11h)'),
  Course(id: 'MATH205', name: 'Đại Số Tuyến Tính', description: 'Các khái niệm cơ bản về ma trận, không gian vector', lecturer: 'GS. Trần Thị B', semester: 'HK1 (2024-2025)', schedule: 'Thứ 4 (14h-16h)'),
  Course(id: 'ENG301', name: 'Kỹ Năng Viết Học Thuật', description: 'Phát triển kỹ năng viết luận văn và báo cáo', lecturer: 'ThS. Lê Văn C', semester: 'HK2 (2024-2025)', schedule: 'Thứ 5 (8h-10h)'),
  Course(id: 'CS450', name: 'Phân Tích Dữ Liệu Lớn', description: 'Giới thiệu về Big Data và các công cụ', lecturer: 'TS. Nguyễn Văn A', semester: 'HK2 (2024-2025)', schedule: 'Thứ 3 (15h-17h)'),
  Course(id: 'DS500', name: 'Học Sâu và Mạng Nơ-ron', description: 'Các mô hình Deep Learning', lecturer: 'TS. Nguyễn Văn A', semester: 'HK Hè 2025', schedule: 'Thứ 6 (18h-20h)'),
];

final List<String> _semesters = ['Tất cả', 'HK1 (2024-2025)', 'HK2 (2024-2025)', 'HK Hè 2025'];
final List<String> _lecturers = ['Tất cả', 'TS. Nguyễn Văn A', 'GS. Trần Thị B', 'ThS. Lê Văn C'];


// --- APP ENTRY POINT ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý Khóa học',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const CourseManagementScreen(),
    );
  }
}

// --- 3. MÀN HÌNH CHÍNH QUẢN LÝ KHÓA HỌC ---

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  String _searchQuery = '';
  String _selectedSemester = 'Tất cả';
  String _selectedLecturer = 'Tất cả';
  // Sử dụng List.from để tạo bản sao, tránh lỗi tham chiếu trực tiếp.
  List<Course> _filteredCourses = List.from(_allCourses); 

  @override
  void initState() {
    super.initState();
    _filterCourses();
  }

  // Hàm lọc và tìm kiếm khóa học
  void _filterCourses() {
    setState(() {
      _filteredCourses = _allCourses.where((course) {
        final matchesSearch = course.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            course.id.toLowerCase().contains(_searchQuery.toLowerCase());
        
        final matchesSemester = _selectedSemester == 'Tất cả' || course.semester == _selectedSemester;
        
        final matchesLecturer = _selectedLecturer == 'Tất cả' || course.lecturer == _selectedLecturer;
        
        return matchesSearch && matchesSemester && matchesLecturer;
      }).toList();
    });
  }

  // Hàm hiển thị Form Thêm/Sửa Khóa học
  void _showCourseForm({Course? course}) {
    final bool isEditing = course != null;
    final TextEditingController nameController = TextEditingController(text: course?.name);
    final TextEditingController descController = TextEditingController(text: course?.description);
    final TextEditingController lecturerController = TextEditingController(text: course?.lecturer);
    final TextEditingController scheduleController = TextEditingController(text: course?.schedule);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Sửa Khóa học: ${course!.id}' : 'Thêm Khóa học Mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Tên Khóa học')),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Mô tả ngắn')),
                TextField(controller: lecturerController, decoration: const InputDecoration(labelText: 'Giảng viên')),
                TextField(controller: scheduleController, decoration: const InputDecoration(labelText: 'Lịch học (VD: T2 9h-11h)')),
                // Có thể thêm Dropdown cho Học kỳ ở đây
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logic lưu (Thêm mới hoặc Cập nhật)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEditing ? 'Đã Cập nhật ${nameController.text}' : 'Đã Thêm khóa học mới')),
                );
                Navigator.pop(context);
                // Sau khi lưu, cần gọi _filterCourses() để cập nhật danh sách
                // (Trong demo này, chúng ta không thay đổi _allCourses, nên chỉ thông báo)
              },
              child: Text(isEditing ? 'Lưu' : 'Thêm'),
            ),
          ],
        );
      },
    );
  }

  // Hàm hiển thị Form Quản lý Học kỳ
  void _showSemesterManagement() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quản Lý Học Kỳ & Năm Học'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Đây là nơi Quản trị viên thêm/sửa các Học kỳ và Năm học.', style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 10),
              // Mô phỏng danh sách học kỳ hiện có
              ..._semesters.skip(1).map((semester) => ListTile(
                title: Text(semester),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sửa học kỳ: $semester')),
                    );
                  },
                ),
              )).toList(),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chức năng Thêm Học kỳ mới')),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Thêm Học Kỳ'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Khóa học'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          // Vùng Tìm kiếm và Bộ lọc
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Tìm kiếm
                    TextField(
                      onChanged: (value) {
                        _searchQuery = value;
                        _filterCourses();
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tìm kiếm theo ID hoặc Tên Khóa học',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 2. Bộ lọc
                    Row(
                      children: [
                        Expanded(child: _buildFilterDropdown('Học kỳ', _selectedSemester, _semesters, (newValue) {
                          setState(() {
                            _selectedSemester = newValue!;
                            _filterCourses();
                          });
                        })),
                        const SizedBox(width: 10),
                        Expanded(child: _buildFilterDropdown('Giảng viên', _selectedLecturer, _lecturers, (newValue) {
                          setState(() {
                            _selectedLecturer = newValue!;
                            _filterCourses();
                          });
                        })),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // 3. Quản lý Học kỳ (Nút riêng)
                    OutlinedButton.icon(
                      onPressed: _showSemesterManagement,
                      icon: const Icon(Icons.school, size: 20),
                      label: const Text('Quản lý Học kỳ & Năm học'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.indigo.shade700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Danh sách Khóa học
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Danh sách Khóa học (${_filteredCourses.length} Khóa)',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          Expanded(
            child: _filteredCourses.isEmpty
                ? const Center(child: Text('Không tìm thấy khóa học nào.'))
                : ListView.builder(
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return CourseListItem(
                        course: course,
                        onEdit: () => _showCourseForm(course: course),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCourseForm(), // Thêm Khóa học mới
        label: const Text('Thêm Khóa học'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Widget hỗ trợ tạo Dropdown Filter
  Widget _buildFilterDropdown(
      String label, String currentValue, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      // FIX LỖI OVERFLOW: isExpanded = true giúp Dropdown thích ứng với chiều rộng hẹp
      // được cấp bởi Expanded trong Row, đảm bảo nội dung không bị tràn.
      isExpanded: true, 
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      ),
      value: currentValue,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          // Sử dụng Expanded/Flexible bên trong DropdownMenuItem để ép Text phải 
          // sử dụng dấu ba chấm (...) nếu quá dài.
          child: Text(
            value, 
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

// Widget hiển thị từng mục Khóa học
class CourseListItem extends StatelessWidget {
  final Course course;
  final VoidCallback onEdit;

  const CourseListItem({
    super.key,
    required this.course,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.withOpacity(0.1),
          child: const Icon(Icons.book, color: Colors.indigo),
        ),
        title: Text(course.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${course.id} | ${course.semester}'),
            Text('GV: ${course.lecturer}'),
            Text('Lịch: ${course.schedule}', style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Sử dụng AlertDialog để xác nhận xóa
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Xác nhận Xóa'),
                    content: Text('Bạn có chắc chắn muốn xóa khóa học "${course.name}" (${course.id}) không?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
                      TextButton(
                        onPressed: () {
                          // Logic xóa (Trong demo này, chỉ thông báo)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã thực hiện yêu cầu Xóa Khóa học ${course.id}')),
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chi tiết Khóa học: ${course.name}')),
          );
        },
      ),
    );
  }
}
