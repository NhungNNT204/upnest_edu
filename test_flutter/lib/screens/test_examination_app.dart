import 'package:flutter/material.dart';
import 'dart:async';

// Dữ liệu mô phỏng (Mock Data)
class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final String? imageUrl;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    this.imageUrl,
  });
}

class Quiz {
  final String id;
  final String title;
  final String type; // 'Course' or 'Daily'
  final Duration duration;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    required this.questions,
  });
}

// Giả lập dữ liệu bài kiểm tra
final List<Quiz> mockQuizzes = [
  Quiz(
    id: 'q1',
    title: 'Quiz Chương 1: Cơ sở lập trình',
    type: 'Course',
    duration: const Duration(minutes: 15),
    questions: [
      Question(
          id: '1',
          text: 'Ngôn ngữ lập trình Flutter sử dụng ngôn ngữ chính nào?',
          options: ['Java', 'Python', 'Dart', 'Swift'],
          correctOptionIndex: 2),
      Question(
          id: '2',
          text: 'Widget nào được dùng để tạo bố cục (layout) theo hàng ngang?',
          options: ['Column', 'Row', 'Stack', 'Container'],
          correctOptionIndex: 1),
      Question(
          id: '3',
          text: 'StatefulWidget khác StatelessWidget ở điểm nào?',
          options: [
            'Không thể có con',
            'Có thể thay đổi trạng thái',
            'Chỉ dùng cho animation',
            'Chỉ có 1 method build'
          ],
          correctOptionIndex: 1),
      Question(
          id: '4',
          text:
              'Khái niệm nào mô tả việc giữ lại dữ liệu khi ứng dụng bị đóng (ví dụ: SharedPreferences)?',
          options: ['Database', 'Persistence', 'API Call', 'State Management'],
          correctOptionIndex: 1),
    ],
  ),
  Quiz(
    id: 'q2',
    title: 'Thử thách Daily Quiz: Kiến thức tổng hợp',
    type: 'Daily',
    duration: const Duration(minutes: 5),
    questions: [
      Question(
          id: '5',
          text: 'Ai là người viết tiểu thuyết "Số Đỏ"?',
          options: ['Nam Cao', 'Vũ Trọng Phụng', 'Ngô Tất Tố', 'Tô Hoài'],
          correctOptionIndex: 1),
      Question(
          id: '6',
          text: 'Thành phố nào được gọi là "Thành phố ngàn hoa"?',
          options: ['Hà Nội', 'Đà Lạt', 'Hội An', 'Huế'],
          correctOptionIndex: 1),
    ],
  ),
];

// Lớp lưu trữ trạng thái bài làm của học viên (để mô phỏng tính năng tiếp tục bài)
class TestSession {
  final Quiz quiz;
  Map<String, int?> userAnswers; // Question ID -> selected option index
  Map<String, bool> markedQuestions; // Question ID -> is marked
  Duration timeRemaining;
  DateTime startTime;
  int currentQuestionIndex;

  TestSession({required this.quiz})
      : userAnswers = {},
        markedQuestions = {},
        timeRemaining = quiz.duration,
        startTime = DateTime.now(),
        currentQuestionIndex = 0;

  // Giả lập chức năng tải lại bài làm (resume)
  static TestSession? loadSession(String quizId) {
    if (quizId == 'q1') {
      // Giả sử có dữ liệu đang làm dở cho bài q1
      final quiz = mockQuizzes.firstWhere((q) => q.id == quizId);
      final session = TestSession(quiz: quiz);
      session.userAnswers = {'1': 2, '2': 0};
      session.markedQuestions = {'3': true};
      session.currentQuestionIndex = 2; // Bắt đầu từ câu 3
      session.timeRemaining = const Duration(minutes: 10, seconds: 30);
      return session;
    }
    return null;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thi & Kiểm tra',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        // cardTheme: CardTheme(
        //   elevation: 4,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        // ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      home: const TestListPage(),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. MÀN HÌNH DANH SÁCH BÀI KIỂM TRA (TestListPage)
// -----------------------------------------------------------------------------

class TestListPage extends StatelessWidget {
  const TestListPage({super.key});

  void _startQuiz(BuildContext context, Quiz quiz, {bool resume = false}) {
    TestSession? session;
    if (resume) {
      session = TestSession.loadSession(quiz.id);
    }
    session ??= TestSession(quiz: quiz);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestTakingPage(session: session!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thi & Kiểm tra'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mockQuizzes.length,
        itemBuilder: (context, index) {
          final quiz = mockQuizzes[index];
          final existingSession = TestSession.loadSession(quiz.id);
          final isResumable = existingSession != null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  quiz.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('Loại: ${quiz.type == 'Daily' ? 'Thử thách hàng ngày' : 'Khóa học'}'),
                    Text('Thời gian: ${quiz.duration.inMinutes} phút'),
                    if (isResumable)
                      const Text(
                        'Đang làm dở (Chạm để tiếp tục)',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (isResumable) {
                    _startQuiz(context, quiz, resume: true);
                  } else {
                    _startQuiz(context, quiz);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. MÀN HÌNH LÀM BÀI (TestTakingPage)
// -----------------------------------------------------------------------------

class TestTakingPage extends StatefulWidget {
  final TestSession session;

  const TestTakingPage({super.key, required this.session});

  @override
  State<TestTakingPage> createState() => _TestTakingPageState();
}

class _TestTakingPageState extends State<TestTakingPage> {
  late Timer _timer;
  late Duration _timeRemaining;
  late TestSession _session;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
    _timeRemaining = _session.timeRemaining;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeRemaining.inSeconds > 0) {
            _timeRemaining = _timeRemaining - const Duration(seconds: 1);
            _session.timeRemaining = _timeRemaining; // Cập nhật session
          } else {
            _timer.cancel();
            _submitTest(); // Tự động nộp bài khi hết giờ
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    // Giả lập lưu lại session khi thoát
    // TestSession.saveSession(_session); // (Trong thực tế cần lưu vào DB/SharedPreferences)
    super.dispose();
  }

  void _selectOption(int optionIndex) {
    setState(() {
      _session.userAnswers[_session.quiz.questions[_session.currentQuestionIndex].id] = optionIndex;
    });
  }

  void _toggleMarkForReview() {
    final questionId = _session.quiz.questions[_session.currentQuestionIndex].id;
    setState(() {
      final currentStatus = _session.markedQuestions[questionId] ?? false;
      _session.markedQuestions[questionId] = !currentStatus;
    });
  }

  void _goToQuestion(int index) {
    setState(() {
      _session.currentQuestionIndex = index;
    });
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận thoát'),
        content: const Text(
            'Bài làm của bạn sẽ được lưu lại để tiếp tục lần sau. Bạn có chắc muốn thoát?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ở lại'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
              Navigator.of(context).pop(); // Quay lại trang danh sách
            },
            child: const Text('Thoát & Lưu'),
          ),
        ],
      ),
    );
  }

  void _submitTest() {
    // 1. Dừng đếm giờ
    _timer.cancel();

    // 2. Tính toán kết quả
    int correctCount = 0;
    for (var q in _session.quiz.questions) {
      if (_session.userAnswers[q.id] == q.correctOptionIndex) {
        correctCount++;
      }
    }

    // 3. Tạo Result data
    final result = {
      'score': (correctCount / _session.quiz.questions.length * 10).toStringAsFixed(1),
      'correctCount': correctCount,
      'totalQuestions': _session.quiz.questions.length,
      'quizTitle': _session.quiz.title,
      'quizType': _session.quiz.type,
      'userAnswers': _session.userAnswers,
    };

    // 4. Chuyển đến trang kết quả
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(result: result, quiz: _session.quiz),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _buildQuestionContent(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Image.network(
              question.imageUrl!,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey[300],
                child: const Center(child: Text('Không tải được hình ảnh')),
              ),
            ),
          ),
        Text(
          'Câu ${_session.currentQuestionIndex + 1}: ${question.text}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ...question.options.asMap().entries.map((entry) {
          int idx = entry.key;
          String text = entry.value;
          final isSelected = _session.userAnswers[question.id] == idx;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: isSelected ? Colors.indigo.shade100 : Colors.white,
            child: ListTile(
              onTap: () => _selectOption(idx),
              leading: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? Colors.indigo : Colors.grey,
              ),
              title: Text(text),
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _session.quiz.questions[_session.currentQuestionIndex];
    final questionId = currentQuestion.id;
    final isMarked = _session.markedQuestions[questionId] ?? false;
    final totalQuestions = _session.quiz.questions.length;
    final currentIndex = _session.currentQuestionIndex;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          _showExitConfirmation();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_session.quiz.title),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: _showExitConfirmation,
              icon: const Icon(Icons.exit_to_app),
              tooltip: 'Thoát & Lưu bài',
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.indigo.shade700,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thời gian còn lại:',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.white, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(_timeRemaining),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: _buildQuestionContent(currentQuestion),
              ),
            ),
            // Thanh chuyển câu và đánh dấu
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Nút Đánh dấu
                  TextButton.icon(
                    onPressed: _toggleMarkForReview,
                    icon: Icon(
                      isMarked ? Icons.flag : Icons.outlined_flag,
                      color: isMarked ? Colors.red : Colors.grey,
                    ),
                    label: Text(
                      isMarked ? 'Đã đánh dấu để xem lại' : 'Đánh dấu để xem lại',
                      style: TextStyle(color: isMarked ? Colors.red : Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Nút chuyển câu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: currentIndex > 0 ? () => _goToQuestion(currentIndex - 1) : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Câu Trước'),
                      ),
                      Text(
                        '${currentIndex + 1} / $totalQuestions',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: currentIndex < totalQuestions - 1
                            ? () => _goToQuestion(currentIndex + 1)
                            : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Câu Sau'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Nút Nộp Bài (Chỉ hiển thị ở câu cuối)
                  if (currentIndex == totalQuestions - 1)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitTest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('NỘP BÀI KIỂM TRA', style: TextStyle(fontSize: 16)),
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

// -----------------------------------------------------------------------------
// 3. MÀN HÌNH KẾT QUẢ THI (ResultPage)
// -----------------------------------------------------------------------------

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> result;
  final Quiz quiz;

  const ResultPage({super.key, required this.result, required this.quiz});

  // Giả lập bảng xếp hạng (Chỉ cho Daily Quiz)
  static const List<Map<String, dynamic>> weeklyLeaderboard = [
    {'name': 'Nguyễn Văn A', 'score': 9.5, 'rank': 1},
    {'name': 'Trần Thị B', 'score': 9.0, 'rank': 2},
    {'name': 'Lê Văn C', 'score': 8.5, 'rank': 3},
    {'name': 'Bạn (You)', 'score': 7.5, 'rank': 5},
  ];

  Widget _buildLeaderboard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🥇 Bảng Thành Tích Tuần (Daily Quiz)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const Divider(),
            ...weeklyLeaderboard.map((entry) {
              final isCurrentUser = entry['name'] == 'Bạn (You)';
              return Container(
                decoration: isCurrentUser
                    ? BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      )
                    : null,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('#${entry['rank']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text(entry['name'] as String,
                            style: TextStyle(fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal)),
                      ],
                    ),
                    Text('${entry['score']} điểm',
                        style: TextStyle(
                            color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerDetail(Question question, int questionIndex, Map<String, int?> userAnswers) {
    final userAnswerIndex = userAnswers[question.id];
    final isCorrect = userAnswerIndex == question.correctOptionIndex;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Câu ${questionIndex + 1}: ${question.text}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...question.options.asMap().entries.map((entry) {
              final idx = entry.key;
              final text = entry.value;
              final isUserChoice = userAnswerIndex == idx;
              final isCorrectAnswer = question.correctOptionIndex == idx;
              Color color = Colors.black;
              IconData icon = Icons.circle_outlined;

              if (isCorrectAnswer) {
                color = Colors.green.shade700;
                icon = Icons.check_circle;
              } else if (isUserChoice) {
                color = Colors.red.shade700;
                icon = Icons.cancel;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: color, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: color,
                          fontWeight: isCorrectAnswer || isUserChoice ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final correctCount = result['correctCount'] as int;
    final totalQuestions = result['totalQuestions'] as int;
    final userAnswers = result['userAnswers'] as Map<String, int?>;
    final score = result['score'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết Quả Bài Thi'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.indigo.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.emoji_events, size: 40, color: Colors.amber),
                      const SizedBox(height: 8),
                      Text(result['quizTitle'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Text(
                        'ĐIỂM SỐ: $score / 10',
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.indigo.shade700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Số câu đúng: $correctCount / $totalQuestions',
                        style: const TextStyle(fontSize: 18, color: Colors.green),
                      ),
                      Text(
                        'Số câu sai/chưa làm: ${totalQuestions - correctCount} / $totalQuestions',
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (result['quizType'] == 'Daily') _buildLeaderboard(),
            const SizedBox(height: 16),
            const Text(
              'Chi tiết đáp án:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const Divider(),
            ...quiz.questions.asMap().entries.map((entry) {
              return _buildAnswerDetail(entry.value, entry.key, userAnswers);
            }).toList(),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Quay lại màn hình danh sách bài kiểm tra
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('QUAY LẠI DANH SÁCH BÀI KIỂM TRA', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
