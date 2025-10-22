import 'package:flutter/material.dart';

// --- Dữ liệu mô phỏng ---

/// Mô hình dữ liệu cho một bài học
class Lesson {
  final int id;
  final String title;
  final String videoUrl; // URL video nhúng (mô phỏng)
  final String content;

  Lesson({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.content,
  });
}

// Danh sách bài học mô phỏng
final List<Lesson> lessons = [
  Lesson(
    id: 1,
    title: "Giới thiệu về Lập trình Web",
    videoUrl: "https://youtube.com/dQw4w9WgXcQ",
    content: "Đây là phần giới thiệu về HTML, CSS và JavaScript. Tập trung vào vai trò của từng ngôn ngữ trong việc xây dựng một trang web.\n\n**Mục tiêu:** Hiểu được kiến trúc cơ bản của một ứng dụng web (Front-end vs Back-end).",
  ),
  Lesson(
    id: 2,
    title: "CSS Nâng Cao và Flutter Layout",
    videoUrl: "https://youtube.com/O-L2iXyPzK0",
    content: "Khám phá các kỹ thuật Flutter layout hiện đại như Row, Column, Stack và cách sử dụng các widget responsive. Khắc phục lỗi Overflow.",
  ),
  Lesson(
    id: 3,
    title: "Dart: Bất đồng bộ và Futures",
    videoUrl: "https://youtube.com/gp_D8r-2LGM",
    content: "Học cách thao tác với các tác vụ bất đồng bộ trong Dart bằng Future, async/await để tránh chặn luồng UI.\n\n**Bài tập:** Xây dựng một thanh đếm đơn giản.",
  ),
  Lesson(
    id: 4,
    title: "Kết nối với API và Dữ liệu",
    videoUrl: "https://youtube.com/Y0Yv8yT17a4",
    content: "Tìm hiểu về Fetch API (sử dụng thư viện dio/http), cách xử lý JSON và gửi/nhận dữ liệu từ các dịch vụ bên ngoài (mock API).",
  )
];

// --- Bộ lưu trữ trạng thái mô phỏng (Trong thực tế dùng shared_preferences) ---
Map<int, bool> _completionStatus = {};
Map<int, String> _notes = {};

class LessonViewerScreen extends StatefulWidget {
  const LessonViewerScreen({super.key});

  @override
  State<LessonViewerScreen> createState() => _LessonViewerScreenState();
}

class _LessonViewerScreenState extends State<LessonViewerScreen> {
  int _currentLessonId = 1;

  @override
  void initState() {
    super.initState();
    // Khởi tạo trạng thái lần đầu
    _loadLessonData();
  }

  // Phương thức tải dữ liệu (Mô phỏng)
  void _loadLessonData() {
    // Trong thực tế, bạn sẽ tải dữ liệu từ shared_preferences/Firestore ở đây
    setState(() {
      _currentLessonId = 1;
    });
  }

  // Phương thức hiển thị thông báo thay cho SnackBar
  void _showMessage(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.indigo.shade600 : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- Logic Bài học ---

  Lesson get _currentLesson =>
      lessons.firstWhere((l) => l.id == _currentLessonId,
          orElse: () => lessons.first);

  bool get _isCompleted => _completionStatus[_currentLessonId] ?? false;

  void _toggleComplete() {
    setState(() {
      final newStatus = !_isCompleted;
      _completionStatus[_currentLessonId] = newStatus;
      _showMessage(
        newStatus ? 'Đã đánh dấu bài học hoàn thành!' : 'Đã bỏ đánh dấu hoàn thành.',
        isSuccess: true,
      );
    });
    // Ghi lại trạng thái hoàn thành vào bộ nhớ vĩnh viễn (shared_preferences)
  }

  void _saveNotes(String text) {
    // Ghi lại ghi chú vào bộ nhớ vĩnh viễn (shared_preferences) mỗi khi có thay đổi
    _notes[_currentLessonId] = text;
  }

  void _nextLesson() {
    final nextId = _currentLessonId + 1;
    if (nextId <= lessons.length) {
      setState(() {
        _currentLessonId = nextId;
      });
      _showMessage('Chuyển đến bài học tiếp theo: ${_currentLesson.title}');
    } else {
      _showMessage('Bạn đã hoàn thành tất cả các bài học!', isSuccess: false);
    }
  }

  void _handleOfflineDownload() {
    // Logic thực tế sẽ gọi API tải video và tài liệu xuống file hệ thống
    _showMessage('Đang tải xuống tài liệu offline...', isSuccess: true);
    // Mô phỏng quá trình tải
    Future.delayed(const Duration(seconds: 1), () {
      _showMessage('Tải xuống Offline thành công!', isSuccess: true);
    });
  }

  // --- Xây dựng UI ---

  Widget _buildLessonListDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Text(
              'Nội Dung Khóa Học',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...lessons.map((lesson) {
            final isActive = lesson.id == _currentLessonId;
            final isCompleted = _completionStatus[lesson.id] ?? false;
            return ListTile(
              title: Text('${lesson.id}. ${lesson.title}',
                  style: TextStyle(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
              leading: isCompleted
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.circle_outlined, color: Colors.grey),
              selected: isActive,
              selectedTileColor: Colors.indigo.shade50,
              onTap: () {
                setState(() {
                  _currentLessonId = lesson.id;
                });
                Navigator.pop(context); // Đóng drawer
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(BuildContext context) {
    // Placeholder cho video nhúng. Trong thực tế, dùng thư viện như `Youtubeer_flutter`
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.ondemand_video, color: Colors.white, size: 60),
              const SizedBox(height: 10),
              Text(
                'Video Placeholder: ${_currentLesson.title}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                'URL: ${_currentLesson.videoUrl}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    final bool hasNext = _currentLessonId < lessons.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          // Nút Đánh dấu hoàn thành
          ElevatedButton.icon(
            onPressed: _toggleComplete,
            icon: Icon(_isCompleted ? Icons.check_circle : Icons.radio_button_unchecked),
            label: Text(_isCompleted ? 'Đã Hoàn Thành' : 'Đánh Dấu Đã Hoàn Thành'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCompleted ? Colors.green.shade600 : Colors.indigo.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 10),

          // Nút Tải xuống và Tiếp theo
          Row(
            children: [
              // Tải xuống Offline
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _handleOfflineDownload,
                  icon: const Icon(Icons.download),
                  label: const Text('Tải Xuống Offline'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.purple.shade600,
                    side: BorderSide(color: Colors.purple.shade600),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Bài Tiếp Theo
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: hasNext ? _nextLesson : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(hasNext ? 'Bài Tiếp Theo' : 'Hoàn Thành Khóa Học'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tài liệu Bài học (Slides)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20, thickness: 1),
            // Hiển thị nội dung bài học
            Text(_currentLesson.content.replaceAll('\n\n', '\n'), style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            Text(
              'Tài liệu bổ sung cho bài học này.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.indigo.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ghi Chú Cá Nhân',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20, thickness: 1),
            TextFormField(
              initialValue: _notes[_currentLessonId] ?? '',
              onChanged: _saveNotes,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Nhập ghi chú của bạn về bài học này...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.indigo.shade600, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ghi chú của bạn sẽ được tự động lưu lại (mô phỏng).',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Viewer'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        // Dùng Builder để lấy context của Scaffold và hiển thị Drawer
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: _buildLessonListDrawer(), // Thanh bên danh sách bài học
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Tiêu đề Bài học
            Text(
              _currentLesson.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 20),

            // Video Player Placeholder
            _buildVideoPlayer(context),
            const SizedBox(height: 20),

            // Điều khiển Bài học (Hoàn thành, Tải, Tiếp theo)
            _buildControlButtons(),
            const SizedBox(height: 30),

            // Nội dung Văn bản/Slides
            _buildContentSection(),
            const SizedBox(height: 30),

            // Ghi chú cá nhân
            _buildNotesSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
