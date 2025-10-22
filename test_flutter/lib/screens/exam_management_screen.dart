import 'package:flutter/material.dart';

// --- 1. MÔ HÌNH DỮ LIỆU ---

// A. Mô hình Câu hỏi (Question Model)
class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex; // Vị trí đáp án đúng (0, 1, 2, 3)
  final String topic; // Chủ đề (Ví dụ: "Đại số", "Giải tích")
  final String difficulty; // Độ khó (Dễ, Trung bình, Khó)

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.topic,
    required this.difficulty,
  });

  // Tạo một ID giả lập mới
  String get newId => DateTime.now().millisecondsSinceEpoch.toString();
}

// B. Mô hình Đề thi (Exam Model)
class Exam {
  final String id;
  final String title;
  final String subject;
  final int durationMinutes;
  final String targetAudience; // Đối tượng (Ví dụ: "K65 CNTT")
  final List<Question> questions; // Danh sách câu hỏi trong đề thi

  Exam({
    required this.id,
    required this.title,
    required this.subject,
    required this.durationMinutes,
    required this.targetAudience,
    required this.questions,
  });

  // Tạo một ID giả lập mới
  String get newId => DateTime.now().millisecondsSinceEpoch.toString();
}

// --- 2. DỮ LIỆU GIẢ LẬP VÀ LOGIC QUẢN LÝ ---

// Ngân hàng Câu hỏi Mock (Dùng chung cho Admin/Giảng viên)
List<Question> mockQuestionBank = [
  Question(
    id: 'Q1',
    text: 'Ngôn ngữ lập trình Flutter sử dụng ngôn ngữ nào?',
    options: ['Java', 'Swift', 'Dart', 'Kotlin'],
    correctAnswerIndex: 2,
    topic: 'Di động',
    difficulty: 'Dễ',
  ),
  Question(
    id: 'Q2',
    text: 'Cấu trúc dữ liệu nào dùng cho việc duyệt theo chiều rộng?',
    options: ['Stack', 'Queue', 'LinkedList', 'Heap'],
    correctAnswerIndex: 1,
    topic: 'Cấu trúc dữ liệu',
    difficulty: 'Trung bình',
  ),
];

// Danh sách Đề thi Mock
List<Exam> mockExams = [
  Exam(
    id: 'E1',
    title: 'Đề kiểm tra giữa kỳ Lập trình Di động',
    subject: 'Lập trình Di động',
    durationMinutes: 60,
    targetAudience: 'K65 CNTT',
    questions: mockQuestionBank,
  ),
  Exam(
    id: 'E2',
    title: 'Quiz 1: Cấu trúc dữ liệu cơ bản',
    subject: 'Cấu trúc Dữ liệu',
    durationMinutes: 30,
    targetAudience: 'K66 Kỹ thuật',
    questions: [],
  ),
];

// --- 3. MÀN HÌNH CHÍNH QUẢN LÝ KIỂM TRA ---

class ExamManagementScreen extends StatefulWidget {
  const ExamManagementScreen({super.key});

  @override
  State<ExamManagementScreen> createState() => _ExamManagementScreenState();
}

class _ExamManagementScreenState extends State<ExamManagementScreen> {
  List<Exam> _exams = mockExams;
  List<Question> _questionBank = mockQuestionBank;

  // Cập nhật Danh sách Đề thi
  void _updateExamList(Exam newExam, {bool isNew = false}) {
    setState(() {
      if (isNew) {
        _exams.add(newExam);
      } else {
        final index = _exams.indexWhere((e) => e.id == newExam.id);
        if (index != -1) {
          _exams[index] = newExam;
        }
      }
    });
  }

  // Cập nhật Ngân hàng Câu hỏi
  void _updateQuestionBank(Question newQuestion, {bool isNew = false}) {
    setState(() {
      if (isNew) {
        _questionBank.add(newQuestion);
      } else {
        final index = _questionBank.indexWhere((q) => q.id == newQuestion.id);
        if (index != -1) {
          _questionBank[index] = newQuestion;
        }
      }
    });
  }

  // Xóa Đề thi
  void _deleteExam(String id) {
    setState(() {
      _exams.removeWhere((e) => e.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa đề thi.')),
    );
  }

  // Xóa Câu hỏi (khỏi Ngân hàng)
  void _deleteQuestion(String id) {
    setState(() {
      _questionBank.removeWhere((q) => q.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa câu hỏi khỏi Ngân hàng.')),
    );
  }

  // Mở màn hình/form tạo đề thi
  void _showExamForm({Exam? exam}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExamFormScreen(
          exam: exam,
          allQuestions: _questionBank,
          onSubmit: (newExam) => _updateExamList(newExam, isNew: exam == null),
        ),
      ),
    );
  }

  // Mở màn hình ngân hàng câu hỏi
  void _navigateToQuestionBank() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionBankScreen(
          questions: _questionBank,
          onQuestionUpdated: _updateQuestionBank,
          onQuestionDeleted: _deleteQuestion,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Kiểm Tra'),
        elevation: 1,
        actions: [
          // Nút đi đến Ngân hàng Câu hỏi
          TextButton.icon(
            onPressed: _navigateToQuestionBank,
            icon: const Icon(Icons.quiz),
            label: const Text('Ngân hàng Câu hỏi'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Danh sách Đề thi',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),

            // Danh sách đề thi
            if (_exams.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text('Chưa có đề thi nào được tạo.', style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ..._exams.map((exam) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const Icon(Icons.assignment, color: Colors.blue),
                    title: Text(exam.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${exam.subject} | ${exam.durationMinutes} phút | ${exam.questions.length} câu'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.indigo),
                          onPressed: () => _showExamForm(exam: exam),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteExam(exam.id),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExamForm(),
        label: const Text('Tạo Đề Thi Mới'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }
}

// --- 4. FORM TẠO/SỬA ĐỀ THI (ExamFormScreen) ---

class ExamFormScreen extends StatefulWidget {
  final Exam? exam;
  final List<Question> allQuestions;
  final Function(Exam) onSubmit;

  const ExamFormScreen({
    super.key,
    this.exam,
    required this.allQuestions,
    required this.onSubmit,
  });

  @override
  State<ExamFormScreen> createState() => _ExamFormScreenState();
}

class _ExamFormScreenState extends State<ExamFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _subject;
  late String _targetAudience;
  late int _durationMinutes;
  late List<Question> _selectedQuestions;

  @override
  void initState() {
    super.initState();
    _title = widget.exam?.title ?? '';
    _subject = widget.exam?.subject ?? '';
    _targetAudience = widget.exam?.targetAudience ?? 'Tất cả';
    _durationMinutes = widget.exam?.durationMinutes ?? 60;
    _selectedQuestions = List.from(widget.exam?.questions ?? []);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedQuestions.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng thêm ít nhất một câu hỏi.')),
        );
        return;
      }

      final newExam = Exam(
        id: widget.exam?.id ?? Exam(
            id: '',
            title: 'temp',
            subject: 'temp',
            durationMinutes: 1,
            targetAudience: 'temp',
            questions: []
        ).newId,
        title: _title,
        subject: _subject,
        durationMinutes: _durationMinutes,
        targetAudience: _targetAudience,
        questions: _selectedQuestions,
      );

      widget.onSubmit(newExam);
      Navigator.pop(context);
    }
  }

  // Hiển thị dialog chọn câu hỏi từ ngân hàng
  void _showQuestionSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // Sử dụng StateBuilder để quản lý trạng thái tạm thời của dialog
        return StatefulBuilder(
          builder: (context, setStateSB) {
            // Danh sách ID của các câu hỏi đã chọn (dùng cho Checkbox)
            final selectedIds = _selectedQuestions.map((q) => q.id).toSet();

            return AlertDialog(
              title: const Text('Chọn Câu hỏi từ Ngân hàng'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: widget.allQuestions.map((q) {
                    final isChecked = selectedIds.contains(q.id);
                    return CheckboxListTile(
                      title: Text(q.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text('Độ khó: ${q.difficulty} | Chủ đề: ${q.topic}', style: const TextStyle(fontSize: 12)),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setStateSB(() {
                          if (value == true) {
                            selectedIds.add(q.id);
                          } else {
                            selectedIds.remove(q.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Cập nhật _selectedQuestions trong state chính của form
                    setState(() {
                      _selectedQuestions = widget.allQuestions
                          .where((q) => selectedIds.contains(q.id))
                          .toList();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Hoàn tất chọn'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam == null ? 'Tạo Đề Thi Mới' : 'Sửa Đề Thi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Tiêu đề
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Tiêu đề Đề thi', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tiêu đề.' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 15),

              // Môn học
              TextFormField(
                initialValue: _subject,
                decoration: const InputDecoration(labelText: 'Môn học', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập môn học.' : null,
                onSaved: (value) => _subject = value!,
              ),
              const SizedBox(height: 15),

              // Thời gian (Phút)
              TextFormField(
                initialValue: _durationMinutes.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Thời lượng (phút)', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Vui lòng nhập thời lượng hợp lệ.';
                  }
                  return null;
                },
                onSaved: (value) => _durationMinutes = int.parse(value!),
              ),
              const SizedBox(height: 15),

              // Đối tượng
              TextFormField(
                initialValue: _targetAudience,
                decoration: const InputDecoration(labelText: 'Đối tượng/Lớp áp dụng', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập đối tượng.' : null,
                onSaved: (value) => _targetAudience = value!,
              ),
              const SizedBox(height: 30),

              // Quản lý Câu hỏi trong Đề thi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Câu hỏi trong Đề thi (${_selectedQuestions.length} câu)', style: Theme.of(context).textTheme.titleMedium),
                  ElevatedButton.icon(
                    onPressed: _showQuestionSelectionDialog,
                    icon: const Icon(Icons.add_box),
                    label: const Text('Chọn Câu hỏi'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Danh sách các câu hỏi đã chọn
              if (_selectedQuestions.isEmpty)
                const Text('Đề thi này chưa có câu hỏi nào.', style: TextStyle(color: Colors.grey))
              else
                ..._selectedQuestions.map((q) => ListTile(
                  title: Text(q.text, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('Chủ đề: ${q.topic} | Đáp án: ${q.options[q.correctAnswerIndex]}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _selectedQuestions.remove(q);
                      });
                    },
                  ),
                )).toList(),
              const SizedBox(height: 30),

              // Nút Submit
              ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(widget.exam == null ? Icons.add_to_photos : Icons.save),
                label: Text(widget.exam == null ? 'Tạo Đề Thi' : 'Lưu Đề Thi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 5. MÀN HÌNH NGÂN HÀNG CÂU HỎI (QuestionBankScreen) ---

class QuestionBankScreen extends StatefulWidget {
  final List<Question> questions;
  final Function(Question, {bool isNew}) onQuestionUpdated;
  final Function(String) onQuestionDeleted;

  const QuestionBankScreen({
    super.key,
    required this.questions,
    required this.onQuestionUpdated,
    required this.onQuestionDeleted,
  });

  @override
  State<QuestionBankScreen> createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends State<QuestionBankScreen> {
  // Mở modal thêm/sửa câu hỏi
  void _showQuestionForm({Question? question}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: QuestionForm(
            question: question,
            onSubmit: (newQuestion) {
              widget.onQuestionUpdated(newQuestion, isNew: question == null);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ngân hàng Câu hỏi Trắc nghiệm'),
      ),
      body: widget.questions.isEmpty
          ? const Center(
              child: Text(
                'Ngân hàng rỗng. Hãy thêm câu hỏi đầu tiên!',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.questions.length,
              itemBuilder: (context, index) {
                final question = widget.questions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: _getColorByDifficulty(question.difficulty),
                      child: Text(
                        question.difficulty[0],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      question.text,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Chủ đề: ${question.topic} | Đáp án: ${question.options[question.correctAnswerIndex]}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.indigo),
                          onPressed: () => _showQuestionForm(question: question),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => widget.onQuestionDeleted(question.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuestionForm(),
        label: const Text('Thêm Câu hỏi'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Color _getColorByDifficulty(String difficulty) {
    switch (difficulty) {
      case 'Dễ':
        return Colors.green;
      case 'Trung bình':
        return Colors.orange;
      case 'Khó':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// --- 6. FORM THÊM/SỬA CÂU HỎI (QuestionForm) ---

class QuestionForm extends StatefulWidget {
  final Question? question;
  final Function(Question) onSubmit;

  const QuestionForm({super.key, this.question, required this.onSubmit});

  @override
  State<QuestionForm> createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _formKey = GlobalKey<FormState>();
  late String _text;
  late List<TextEditingController> _optionControllers;
  late int _correctAnswerIndex;
  late String _topic;
  late String _difficulty;

  final List<String> _difficultyLevels = ['Dễ', 'Trung bình', 'Khó'];
  final List<String> _topics = ['Lập trình Di động', 'Cấu trúc Dữ liệu', 'Hệ điều hành', 'Cơ sở dữ liệu'];

  @override
  void initState() {
    super.initState();
    final question = widget.question;

    _text = question?.text ?? '';
    _correctAnswerIndex = question?.correctAnswerIndex ?? 0;
    _topic = question?.topic ?? _topics.first;
    _difficulty = question?.difficulty ?? _difficultyLevels.first;

    // Khởi tạo 4 controller cho 4 đáp án
    _optionControllers = List.generate(4, (index) {
      return TextEditingController(
        text: question != null && index < question.options.length ? question.options[index] : '',
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final options = _optionControllers.map((c) => c.text).toList();

      final newQuestion = Question(
        id: widget.question?.id ?? Question(
            id: '',
            text: 'temp',
            options: ['a', 'b', 'c', 'd'],
            correctAnswerIndex: 0,
            topic: 'temp',
            difficulty: 'temp'
        ).newId,
        text: _text,
        options: options,
        correctAnswerIndex: _correctAnswerIndex,
        topic: _topic,
        difficulty: _difficulty,
      );

      widget.onSubmit(newQuestion);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.question == null ? 'Thêm Câu Hỏi Mới' : 'Chỉnh Sửa Câu Hỏi',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 30),

            // Nội dung Câu hỏi
            TextFormField(
              initialValue: _text,
              decoration: const InputDecoration(labelText: 'Nội dung Câu hỏi', border: OutlineInputBorder()),
              maxLines: 3,
              validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập nội dung câu hỏi.' : null,
              onSaved: (value) => _text = value!,
            ),
            const SizedBox(height: 20),

            Text('Các Đáp án', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),

            // 4 Đáp án
            ...List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: _correctAnswerIndex,
                      onChanged: (int? value) {
                        setState(() {
                          _correctAnswerIndex = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _optionControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Đáp án ${index + 1}',
                          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                          suffixIcon: index == _correctAnswerIndex ? const Icon(Icons.check_circle, color: Colors.green) : null,
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Đáp án không được để trống.' : null,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 15),

            // Dropdown Độ khó
            DropdownButtonFormField<String>(
              value: _difficulty,
              decoration: const InputDecoration(labelText: 'Độ Khó', border: OutlineInputBorder()),
              items: _difficultyLevels.map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _difficulty = newValue!;
                });
              },
              onSaved: (value) => _difficulty = value!,
            ),
            const SizedBox(height: 15),

            // Dropdown Chủ đề
            DropdownButtonFormField<String>(
              value: _topic,
              decoration: const InputDecoration(labelText: 'Chủ Đề', border: OutlineInputBorder()),
              items: _topics.map((String topic) {
                return DropdownMenuItem<String>(
                  value: topic,
                  child: Text(topic),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _topic = newValue!;
                });
              },
              onSaved: (value) => _topic = value!,
            ),
            const SizedBox(height: 30),

            // Nút Submit
            ElevatedButton.icon(
              onPressed: _submit,
              icon: Icon(widget.question == null ? Icons.add_circle : Icons.save),
              label: Text(widget.question == null ? 'Thêm Câu Hỏi' : 'Lưu Câu Hỏi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
          ],
        ),
      ),
    );
  }
}
