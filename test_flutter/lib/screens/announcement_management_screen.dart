import 'package:flutter/material.dart';

// Mô hình dữ liệu cho Thông báo
class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime date;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });
}

// Màn hình chính
class AnnouncementManagementScreen extends StatefulWidget {
  const AnnouncementManagementScreen({super.key});

  @override
  State<AnnouncementManagementScreen> createState() => _AnnouncementManagementScreenState();
}

class _AnnouncementManagementScreenState extends State<AnnouncementManagementScreen> {
  // Danh sách thông báo mẫu
  List<Announcement> _announcements = [
    Announcement(
      id: 'A003',
      title: 'Thông báo lịch thi giữa kỳ',
      content: 'Lịch thi giữa kỳ cho các môn học đại cương đã được công bố trên cổng thông tin sinh viên.',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Announcement(
      id: 'A002',
      title: 'Hội thảo chuyên đề công nghệ AI',
      content: 'Mời các sinh viên quan tâm tham gia hội thảo vào lúc 14:00 ngày 25/10/2025 tại Hội trường lớn.',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Announcement(
      id: 'A001',
      title: 'Quy định mới về đăng ký môn học',
      content: 'Sinh viên cần lưu ý các thay đổi trong quy trình đăng ký môn học học kỳ mới. Chi tiết xem trong file đính kèm.',
      date: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  // Controller cho form tạo thông báo mới
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Hàm hiển thị dialog tạo thông báo mới
  void _showCreateAnnouncementDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tạo Thông Báo Mới (Đẩy Toàn Hệ Thống)'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Tiêu đề Thông báo',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tiêu đề';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Nội dung Thông báo',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập nội dung';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
                _titleController.clear();
                _contentController.clear();
              },
            ),
            ElevatedButton(
              child: const Text('Gửi Thông Báo'),
              onPressed: _createAnnouncement,
            ),
          ],
        );
      },
    );
  }

  // Hàm xử lý tạo và thêm thông báo
  void _createAnnouncement() {
    if (_formKey.currentState!.validate()) {
      final newAnnouncement = Announcement(
        id: 'A${_announcements.length + 1}',
        title: _titleController.text,
        content: _contentController.text,
        date: DateTime.now(),
      );

      setState(() {
        // Thêm thông báo mới lên đầu danh sách
        _announcements.insert(0, newAnnouncement);
      });

      // Đóng dialog và xóa nội dung form
      Navigator.of(context).pop();
      _titleController.clear();
      _contentController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thông báo đã được gửi thành công đến toàn hệ thống!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sắp xếp danh sách theo ngày mới nhất
    _announcements.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Thông Báo Chung'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: _announcements.isEmpty
          ? const Center(child: Text('Chưa có thông báo nào được gửi.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: _announcements.length,
              itemBuilder: (context, index) {
                final announcement = _announcements[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: const Icon(Icons.campaign, color: Colors.pink),
                    title: Text(
                      announcement.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      'Ngày gửi: ${announcement.date.day}/${announcement.date.month}/${announcement.date.year}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            Text(
                              'Nội dung:',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink.shade700),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              announcement.content,
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      
      // Floating Action Button để tạo thông báo mới
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateAnnouncementDialog,
        icon: const Icon(Icons.add_alert),
        label: const Text('Tạo Thông Báo'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
