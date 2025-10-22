import 'package:flutter/material.dart';

// Màn hình Quản lý Tài nguyên (Thư viện)
class ResourceManagementScreen extends StatelessWidget {
  const ResourceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Tài Nguyên Thư Viện'),
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh Sách Tài Nguyên (Ebook, Video, Giáo trình)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Placeholder cho nút Thêm/Sửa
            Row(
              children: [
                _ActionChip(label: 'Thêm Tài Nguyên Mới', icon: Icons.add_box, color: Colors.green),
                SizedBox(width: 8),
                _ActionChip(label: 'Quản Lý Danh Mục', icon: Icons.category, color: Colors.purple),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ResourceListView(),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget mô phỏng nút hành động nhỏ
class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  
  const _ActionChip({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chức năng: $label')),
        );
      },
      side: BorderSide(color: color.withOpacity(0.5)),
      backgroundColor: color.withOpacity(0.1),
    );
  }
}

// Widget mô phỏng danh sách tài nguyên
class ResourceListView extends StatelessWidget {
  const ResourceListView({super.key});

  final List<Map<String, dynamic>> resources = const [
    {'title': 'Ebook: Thuật toán cơ bản', 'type': 'Ebook', 'icon': Icons.book, 'color': Colors.blue},
    {'title': 'Video: Lập trình Flutter nâng cao', 'type': 'Video', 'icon': Icons.ondemand_video, 'color': Colors.red},
    {'title': 'Giáo trình: Cơ sở dữ liệu', 'type': 'Giáo trình', 'icon': Icons.menu_book, 'color': Colors.green},
    {'title': 'Tài liệu: Lịch sử máy tính', 'type': 'Tài liệu', 'icon': Icons.article, 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 1,
          child: ListTile(
            leading: Icon(resource['icon'] as IconData, color: resource['color'] as Color),
            title: Text(resource['title'].toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('Loại: ${resource['type']}'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$value ${resource['title']}')),
                );
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: 'Sửa', child: Text('Sửa')),
                const PopupMenuItem<String>(value: 'Xóa', child: Text('Xóa', style: TextStyle(color: Colors.red))),
              ],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Chi tiết: ${resource['title']}')),
              );
            },
          ),
        );
      },
    );
  }
}
