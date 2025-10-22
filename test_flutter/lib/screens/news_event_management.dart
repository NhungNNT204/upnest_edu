import 'package:flutter/material.dart';

// --- ENUM VAI TRÒ NGƯỜI DÙNG ---
enum UserRole {
  admin, // Quản lý, có quyền CRUD (Create, Read, Update, Delete)
  student, // Sinh viên, chỉ có quyền đọc (view) Sự kiện
}

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
    isNews: true, // Tin tức
    category: 'Thông báo',
  ),
  NewsEvent(
    id: '2',
    title: 'Hội thảo "Công nghệ AI trong Giáo dục"',
    content: 'Tham gia hội thảo để tìm hiểu về các công cụ AI mới. Diễn giả: GS. Nguyễn Văn A. Địa điểm: Phòng Lab A101.',
    date: DateTime.now().add(const Duration(days: 7)),
    isNews: false, // Sự kiện
    category: 'Học tập',
  ),
  NewsEvent(
    id: '3',
    title: 'Cuộc thi lập trình ACM/ICPC cấp trường',
    content: 'Đăng ký ngay để thử thách khả năng lập trình của bạn. Địa điểm: Phòng Lab B201.',
    date: DateTime.now().subtract(const Duration(days: 10)),
    isNews: false, // Sự kiện
    category: 'Hoạt động',
  ),
];

// --- 3. MÀN HÌNH CHÍNH (QUẢN LÝ HOẶC XEM) ---

class NewsEventScreen extends StatefulWidget {
  // THAM SỐ NÀY BẮT BUỘC (required)
  final UserRole role; 
  const NewsEventScreen({super.key, required this.role});

  @override
  State<NewsEventScreen> createState() => _NewsEventScreenState();
}

class _NewsEventScreenState extends State<NewsEventScreen> {
  // Sử dụng dữ liệu giả lập
  List<NewsEvent> _events = mockNewsEvents;

  // Giả lập việc thêm/sửa/xóa sự kiện (chỉ dành cho Admin)
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

  // Hiển thị modal thêm/sửa (chỉ dành cho Admin)
  void _showFormModal({NewsEvent? event}) {
    // Chỉ Admin mới được phép
    if (widget.role != UserRole.admin) return;

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

  // Lọc danh sách theo vai trò
  List<NewsEvent> _getFilteredEvents() {
    if (widget.role == UserRole.admin) {
      return _events; // Admin thấy tất cả
    } else {
      // Student chỉ thấy Sự kiện (isNews = false)
      return _events.where((e) => !e.isNews).toList();
    }
  }

  // Xử lý khi nhấn vào item
  void _handleItemTap(NewsEvent event) {
    if (widget.role == UserRole.admin) {
      // Admin: mở form chỉnh sửa
      _showFormModal(event: event);
    } else {
      // Student: mở màn hình chi tiết
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailScreen(event: event),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _getFilteredEvents();
    final isAdmin = widget.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Quản Lý Tin Tức & Sự Kiện' : 'Sự Kiện & Hội Thảo'),
        elevation: 1,
        backgroundColor: isAdmin ? Colors.teal : Colors.indigo,
      ),
      body: filteredEvents.isEmpty
          ? Center(
              child: Text(
                isAdmin
                    ? 'Chưa có tin tức/sự kiện nào được tạo.'
                    : 'Hiện chưa có sự kiện nào.',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
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
                    onTap: () => _handleItemTap(event), // Xử lý onTap tùy theo vai trò
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
                          maxLines: isAdmin ? 2 : 1, // Student chỉ cần xem tóm tắt
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Danh mục: ${event.category}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        Text(
                          'Ngày: ${event.date.day}/${event.date.month}/${event.date.year}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    trailing: isAdmin
                        ? Row(
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
                            )
                        : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // Student chỉ có icon xem
                  ),
                );
              },
            ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showFormModal(),
              label: const Text('Thêm Mới'),
              icon: const Icon(Icons.add),
              backgroundColor: Colors.teal,
            )
          : null, // Sinh viên không có nút thêm
    );
  }
}

// --- 4. FORM THÊM/SỬA TIN TỨC/SỰ KIỆN (Chỉ Admin dùng) ---

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

  final List<String> _categories = const [
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
      
      // Tạo ID mới nếu là thêm mới, hoặc giữ ID cũ nếu là chỉnh sửa
      final String id = isEditing
          ? widget.event!.id
          : DateTime.now().millisecondsSinceEpoch.toString();

      final newEvent = NewsEvent(
        id: id,
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

// --- 5. MÀN HÌNH CHI TIẾT SỰ KIỆN (Dành cho Sinh viên) ---

class EventDetailScreen extends StatelessWidget {
  final NewsEvent event;
  const EventDetailScreen({super.key, required this.event});

  // Hàm giả lập thêm vào lịch
  void _addToCalendar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã giả lập thêm sự kiện "${event.title}" vào lịch của bạn!'),
        backgroundColor: Colors.green,
      ),
    );
    // Trong ứng dụng thực tế: sử dụng package `add_2_calendar` hoặc `url_launcher`
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Sự Kiện'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
            ),
            const Divider(height: 25),

            _buildDetailRow(
              context,
              icon: Icons.calendar_today,
              label: 'Thời gian',
              value: '${event.date.day}/${event.date.month}/${event.date.year}',
            ),
            _buildDetailRow(
              context,
              icon: Icons.category,
              label: 'Danh mục',
              value: event.category,
            ),
            _buildDetailRow(
              context,
              icon: Icons.location_on,
              label: 'Nơi tổ chức',
              // Giả lập tìm kiếm nơi tổ chức trong nội dung
              value: event.content.contains('Địa điểm:') 
                ? event.content.split('Địa điểm:')[1].split('.')[0].trim()
                : 'Xem chi tiết bên dưới',
            ),
            const SizedBox(height: 20),
            
            Text(
              'Mô tả chi tiết:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                event.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            const SizedBox(height: 40),

            // Nút "Thêm vào lịch"
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _addToCalendar(context),
                icon: const Icon(Icons.add_alert_rounded),
                label: const Text('Thêm vào Lịch & Nhận Nhắc Nhở'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange.shade700, size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- WIDGET KHỞI CHẠY ỨNG DỤNG ---
class MyApp extends StatelessWidget {
  // Thay đổi quyền hạn tại đây để kiểm tra
  // Hiện đang đặt là Student (Sinh viên)
  final UserRole initialRole = UserRole.student; // <<< THAY ĐỔI ĐỂ KIỂM TRA QUYỀN

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Tin Tức & Sự Kiện',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      // Truyền tham số role vào màn hình chính
      home: NewsEventScreen(role: initialRole), 
    );
  }
}

void main() {
  runApp(const MyApp());
}
