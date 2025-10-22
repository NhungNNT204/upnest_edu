import 'package:flutter/material.dart';

// Import các hàm Firestore nếu cần (giả lập)
// import 'package:cloud_firestore/cloud_firestore.dart';

// --- 1. MÔ HÌNH DỮ LIỆU TIN TỨC/SỰ KIỆN ---

class NewsEvent {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final bool isNews; // true: Tin tức, false: Sự kiện
  final String category; // Ví dụ: "Học tập", "Hoạt động", "Thông báo"

  // Constructor
  NewsEvent({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.isNews,
    required this.category,
  });

  // Tạo một ID giả lập mới (UUID)
  String get newId => DateTime.now().millisecondsSinceEpoch.toString();

  // Chuyển đổi từ Object sang Map cho Firestore (giả lập)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'isNews': isNews,
      'category': category,
    };
  }

  // Chuyển đổi từ Map sang Object (giả lập)
  factory NewsEvent.fromMap(Map<String, dynamic> map) {
    return NewsEvent(
      id: map['id'] ?? '',
      title: map['title'] ?? 'Không tiêu đề',
      content: map['content'] ?? 'Không nội dung',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      isNews: map['isNews'] ?? true,
      category: map['category'] ?? 'Thông báo',
    );
  }
}

// --- 2. DỮ LIỆU GIẢ LẬP (MOCK DATA) ---

List<NewsEvent> mockNewsEvents = [
  NewsEvent(
    id: '1',
    title: 'Thông báo lịch thi cuối kỳ mùa thu 2024',
    content: 'Chi tiết lịch thi đã được cập nhật trên cổng thông tin sinh viên.',
    date: DateTime.now().subtract(const Duration(days: 3)),
    isNews: true,
    category: 'Thông báo',
  ),
  NewsEvent(
    id: '2',
    title: 'Hội thảo "Công nghệ AI trong Giáo dục"',
    content: 'Tham gia hội thảo để tìm hiểu về các công cụ AI mới.',
    date: DateTime.now().add(const Duration(days: 7)),
    isNews: false,
    category: 'Học tập',
  ),
  NewsEvent(
    id: '3',
    title: 'Cuộc thi lập trình ACM/ICPC cấp trường',
    content: 'Đăng ký ngay để thử thách khả năng lập trình của bạn.',
    date: DateTime.now().subtract(const Duration(days: 10)),
    isNews: false,
    category: 'Hoạt động',
  ),
];

// --- 3. MÀN HÌNH QUẢN LÝ TIN TỨC & SỰ KIỆN ---

class NewsEventScreen extends StatefulWidget {
  const NewsEventScreen({super.key});

  @override
  State<NewsEventScreen> createState() => _NewsEventScreenState();
}

class _NewsEventScreenState extends State<NewsEventScreen> {
  List<NewsEvent> _events = mockNewsEvents;

  // Giả lập việc thêm/sửa/xóa sự kiện
  void _addEvent(NewsEvent event) {
    setState(() {
      _events.add(event);
      _events.sort((a, b) => b.date.compareTo(a.date)); // Sắp xếp lại theo ngày
    });
  }

  void _updateEvent(NewsEvent updatedEvent) {
    setState(() {
      final index = _events.indexWhere((e) => e.id == updatedEvent.id);
      if (index != -1) {
        _events[index] = updatedEvent;
        _events.sort((a, b) => b.date.compareTo(a.date));
      }
    });
  }

  void _deleteEvent(String id) {
    setState(() {
      _events.removeWhere((e) => e.id == id);
    });
  }

  // Hiển thị modal thêm/sửa
  void _showFormModal({NewsEvent? event}) {
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
          child: NewsEventForm(
            event: event,
            onSubmit: (newEvent) {
              if (event == null) {
                _addEvent(newEvent);
              } else {
                _updateEvent(newEvent);
              }
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
        title: const Text('Quản Lý Tin Tức & Sự Kiện'),
        elevation: 1,
      ),
      body: _events.isEmpty
          ? const Center(
              child: Text(
                'Chưa có tin tức/sự kiện nào được tạo.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: event.isNews ? Colors.blue.shade100 : Colors.orange.shade100,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: event.isNews ? Colors.blue : Colors.orange,
                      child: Icon(
                        event.isNews ? Icons.article : Icons.event,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          event.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Loại: ${event.isNews ? "Tin tức" : "Sự kiện"} | Danh mục: ${event.category}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        Text(
                          'Ngày: ${event.date.day}/${event.date.month}/${event.date.year}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.indigo),
                          onPressed: () => _showFormModal(event: event),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteEvent(event.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đã xóa sự kiện/tin tức.')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFormModal(),
        label: const Text('Thêm Mới'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

// --- 4. FORM THÊM/SỬA TIN TỨC/SỰ KIỆN ---

class NewsEventForm extends StatefulWidget {
  final NewsEvent? event;
  final Function(NewsEvent) onSubmit;

  const NewsEventForm({super.key, this.event, required this.onSubmit});

  @override
  State<NewsEventForm> createState() => _NewsEventFormState();
}

class _NewsEventFormState extends State<NewsEventForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  late DateTime _date;
  late bool _isNews;
  late String _category;

  final List<String> _categories = [
    "Thông báo",
    "Học tập",
    "Hoạt động",
    "Tuyển sinh",
    "Khác"
  ];

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    _title = event?.title ?? '';
    _content = event?.content ?? '';
    _date = event?.date ?? DateTime.now();
    _isNews = event?.isNews ?? true;
    _category = event?.category ?? _categories.first;
  }

  // Hàm chọn ngày
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final isEditing = widget.event != null;
      
      // *** ĐIỀM CHÍNH ĐÃ SỬA LỖI: CUNG CẤP title KHI TẠO ĐỐI TƯỢNG TẠM ***
      final newEvent = NewsEvent(
        // Nếu là sửa, dùng ID cũ. Nếu là thêm mới, tạo ID mới.
        id: isEditing ? widget.event!.id : NewsEvent(id: '', title: 'temp', content: '', date: DateTime.now(), isNews: true, category: '').newId,
        title: _title,
        content: _content,
        date: _date,
        isNews: _isNews,
        category: _category,
      );

      widget.onSubmit(newEvent);
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
              widget.event == null ? 'Thêm Tin Tức/Sự Kiện Mới' : 'Chỉnh Sửa Tin Tức/Sự Kiện',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 30),

            // Tiêu đề
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tiêu đề.';
                }
                return null;
              },
              onSaved: (value) {
                _title = value!;
              },
            ),
            const SizedBox(height: 15),

            // Nội dung
            TextFormField(
              initialValue: _content,
              decoration: const InputDecoration(
                labelText: 'Nội dung chi tiết',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập nội dung.';
                }
                return null;
              },
              onSaved: (value) {
                _content = value!;
              },
            ),
            const SizedBox(height: 15),

            // Chọn Loại (Tin tức/Sự kiện)
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Tin tức'),
                    value: true,
                    groupValue: _isNews,
                    onChanged: (bool? value) {
                      setState(() {
                        _isNews = value!;
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Sự kiện'),
                    value: false,
                    groupValue: _isNews,
                    onChanged: (bool? value) {
                      setState(() {
                        _isNews = value!;
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Danh mục
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Danh mục',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _category = newValue!;
                });
              },
              onSaved: (value) {
                _category = value!;
              },
            ),
            const SizedBox(height: 15),

            // Chọn ngày
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              leading: const Icon(Icons.calendar_today, color: Colors.blue),
              title: Text(
                'Ngày: ${_date.day}/${_date.month}/${_date.year}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _selectDate,
            ),
            const SizedBox(height: 30),

            // Nút Submit
            ElevatedButton.icon(
              icon: Icon(widget.event == null ? Icons.add : Icons.save),
              label: Text(widget.event == null ? 'Thêm Mới' : 'Lưu Thay Đổi'),
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            // Nút Hủy
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
