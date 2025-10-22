import 'package:flutter/material.dart';

// --- 1. MÔ HÌNH DỮ LIỆU ---

// Định nghĩa một bước trong lộ trình học tập (một khóa học, một chứng chỉ, v.v.)
class PathStep {
  final String id;
  final String title;
  final String description;
  bool isCompleted; // Trạng thái hoàn thành

  PathStep({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

// Định nghĩa toàn bộ lộ trình
class LearningPath {
  String goal; // Mục tiêu dài hạn của học viên (VD: "Đạt TOEIC 800")
  List<PathStep> steps; // Chuỗi các bước/khóa học cần hoàn thành

  LearningPath({required this.goal, required this.steps});

  // Tính toán phần trăm tiến độ
  double get progressPercentage {
    if (steps.isEmpty) return 0.0;
    int completedCount = steps.where((step) => step.isCompleted).length;
    return completedCount / steps.length;
  }
}

// --- 2. WIDGET CHÍNH: LEARNING PATH SCREEN ---

class LearningPathScreen extends StatefulWidget {
  const LearningPathScreen({super.key});

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  final TextEditingController _goalController = TextEditingController();
  LearningPath? _currentPath;

  @override
  void initState() {
    super.initState();
    // Khởi tạo lộ trình mặc định hoặc trống
    _currentPath = _generateDefaultPath();
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  // Logic GIẢ LẬP: Tạo lộ trình dựa trên mục tiêu
  LearningPath _generatePath(String goal) {
    // Logic giả lập: Nếu mục tiêu liên quan đến TOEIC
    if (goal.toLowerCase().contains('toeic')) {
      return LearningPath(
        goal: goal,
        steps: [
          PathStep(
              id: '1',
              title: 'Khóa học Tiếng Anh Cơ bản A1-A2',
              description: 'Nắm vững ngữ pháp và từ vựng nền tảng.'),
          PathStep(
              id: '2',
              title: 'Khóa luyện nghe & đọc B1 (TOEIC 500+)',
              description: 'Chiến lược làm bài thi Nghe và Đọc Part 1-4.'),
          PathStep(
              id: '3',
              title: 'Khóa luyện đề chuyên sâu B2 (TOEIC 700+)',
              description: 'Làm quen với áp lực thời gian và các dạng đề khó.'),
          PathStep(
              id: '4',
              title: 'Thi thử & Tổng ôn (TOEIC 800+)',
              description: 'Đánh giá cuối kỳ và khắc phục điểm yếu.'),
        ],
      );
    } else if (goal.toLowerCase().contains('lập trình')) {
      return LearningPath(
        goal: goal,
        steps: [
          PathStep(
              id: '1',
              title: 'Lập trình căn bản (Python/Java)',
              description: 'Học cú pháp, biến, điều kiện và vòng lặp.'),
          PathStep(
              id: '2',
              title: 'Cấu trúc dữ liệu và giải thuật',
              description: 'Nắm vững Stack, Queue, Hash Table và thuật toán sắp xếp.'),
          PathStep(
              id: '3',
              title: 'Phát triển ứng dụng Web/Mobile',
              description: 'Xây dựng dự án thực tế với framework.'),
        ],
      );
    } else {
      return _generateDefaultPath();
    }
  }

  // Lộ trình mặc định khi chưa có mục tiêu
  LearningPath _generateDefaultPath() {
    return LearningPath(
      goal: 'Nhập mục tiêu dài hạn của bạn (VD: Đạt TOEIC 800)',
      steps: const [],
    );
  }

  // Cập nhật trạng thái hoàn thành của một bước
  void _toggleStepCompletion(int index, bool isCompleted) {
    if (_currentPath != null && index < _currentPath!.steps.length) {
      setState(() {
        _currentPath!.steps[index].isCompleted = isCompleted;
      });
      // In ra thông báo (thay cho việc cập nhật Firestore thực tế)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Đã ${isCompleted ? 'hoàn thành' : 'bỏ chọn'} bước: ${_currentPath!.steps[index].title}'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lộ Trình Học Tập Cá Nhân',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3. WIDGET NHẬP MỤC TIÊU
            _buildGoalInput(),
            const SizedBox(height: 25),

            // 4. WIDGET TIẾN ĐỘ CHUNG
            if (_currentPath != null && _currentPath!.steps.isNotEmpty)
              _buildProgressIndicator(_currentPath!),
            const SizedBox(height: 30),

            // 5. WIDGET TIMELINE LỘ TRÌNH
            if (_currentPath != null && _currentPath!.steps.isNotEmpty)
              _buildTimeline(_currentPath!),
          ],
        ),
      ),
    );
  }

  // Widget Nhập Mục tiêu
  Widget _buildGoalInput() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. Xác Định Mục Tiêu Dài Hạn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _goalController,
              decoration: InputDecoration(
                labelText: _currentPath?.goal ?? 'VD: Đạt TOEIC 800, Trở thành Lập trình viên Backend...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.indigo),
                  onPressed: () {
                    if (_goalController.text.isNotEmpty) {
                      setState(() {
                        _currentPath = _generatePath(_goalController.text);
                        // Reset text field sau khi tạo lộ trình
                        _goalController.text = '';
                      });
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _currentPath = _generatePath(value);
                    _goalController.text = '';
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Mục tiêu hiện tại: ${_currentPath?.goal ?? 'Chưa xác định'}',
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Thanh tiến độ chung
  Widget _buildProgressIndicator(LearningPath path) {
    final progress = path.progressPercentage;
    final displayProgress = (progress * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Tiến Độ Hoàn Thành Lộ Trình',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.indigo.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo.shade400),
                    minHeight: 15,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  '$displayProgress%',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget Timeline Lộ trình
  Widget _buildTimeline(LearningPath path) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Các Bước Cần Thực Hiện',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        const SizedBox(height: 15),
        // Sử dụng ListView.separated để tạo khoảng cách giữa các bước
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: path.steps.length,
          separatorBuilder: (context, index) {
            return _buildTimelineConnector(path.steps[index].isCompleted);
          },
          itemBuilder: (context, index) {
            return _buildTimelineStep(path.steps[index], index);
          },
        ),
      ],
    );
  }

  // Widget tạo đường nối Timeline
  Widget _buildTimelineConnector(bool isPrevStepCompleted) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 40,
      padding: const EdgeInsets.only(left: 12),
      child: Container(
        width: 4,
        height: 40,
        color: isPrevStepCompleted ? Colors.indigo.shade400 : Colors.grey.shade300,
      ),
    );
  }

  // Widget tạo từng Bước Timeline
  Widget _buildTimelineStep(PathStep step, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon trạng thái
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: step.isCompleted ? Colors.indigo.shade400 : Colors.grey.shade300,
            border: Border.all(
              color: Colors.indigo.shade700,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: step.isCompleted ? Colors.white : Colors.indigo.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        // Nội dung bước
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Toggle trạng thái khi nhấn vào thẻ
              _toggleStepCompletion(index, !step.isCompleted);
            },
            child: Card(
              elevation: step.isCompleted ? 6 : 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: step.isCompleted ? Colors.indigo.shade50 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: step.isCompleted ? Colors.indigo.shade700 : Colors.black87,
                        decoration: step.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(step.description, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    // Checkbox đánh dấu hoàn thành
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          step.isCompleted ? 'Đã Hoàn Thành' : 'Đánh Dấu Hoàn Thành',
                          style: TextStyle(
                            fontSize: 12,
                            color: step.isCompleted ? Colors.green.shade700 : Colors.indigo,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Checkbox(
                          value: step.isCompleted,
                          onChanged: (bool? newValue) {
                            if (newValue != null) {
                              _toggleStepCompletion(index, newValue);
                            }
                          },
                          activeColor: Colors.indigo.shade400,
                          checkColor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
