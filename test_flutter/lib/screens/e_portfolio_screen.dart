import 'package:flutter/material.dart';

// --- MÔ HÌNH DỮ LIỆU GIẢ LẬP ---
class PortfolioItem {
  final String title;
  final String date;
  final IconData icon;
  final Color color;

  const PortfolioItem({required this.title, required this.date, required this.icon, required this.color});
}

class EPortfolioScreen extends StatelessWidget {
  const EPortfolioScreen({super.key});

  // Dữ liệu giả lập cho các thành phần trong E-Portfolio
  final List<PortfolioItem> portfolioItems = const [
    PortfolioItem(title: "Dự án cuối khóa Lập trình Web", date: "12/2024", icon: Icons.code, color: Colors.blue),
    PortfolioItem(title: "Chứng chỉ tiếng Anh B2", date: "05/2024", icon: Icons.g_translate, color: Colors.green),
    PortfolioItem(title: "Bài luận triết học xuất sắc", date: "03/2024", icon: Icons.edit_note, color: Colors.orange),
    PortfolioItem(title: "Hoạt động tình nguyện hè 2024", date: "08/2024", icon: Icons.volunteer_activism, color: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ Sơ Học Tập Số', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thẻ Thông tin Tổng quan
            _buildSummaryCard(context),
            const SizedBox(height: 20),

            // Phần Danh mục Mục tiêu
            const Text(
              "Thành tựu và Dự án",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            
            // Danh sách các mục trong Portfolio
            ...portfolioItems.map((item) => _buildPortfolioTile(context, item)).toList(),

            const SizedBox(height: 30),

            // Nút Thêm mới
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_to_photos),
                label: const Text("Thêm Thành tựu/Dự án mới"),
                onPressed: () {
                  // Sử dụng context đúng cách trong callback (Khắc phục lỗi)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chức năng thêm mới đang được mở...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hỗ trợ: Thẻ Tổng quan
  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tổng quan E-Portfolio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.auto_stories, color: Colors.blue),
              title: Text("Điểm GPA trung bình"),
              trailing: Text("3.7 / 4.0", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text("Số dự án lớn hoàn thành"),
              trailing: Text("3", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            // Nút xem chi tiết
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Context được sử dụng đúng cách ở đây
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang tải trang chi tiết...')),
                  );
                },
                child: const Text("Xem Chi tiết Hồ sơ"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hỗ trợ: Tile cho mỗi mục trong Portfolio
  Widget _buildPortfolioTile(BuildContext context, PortfolioItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(item.icon, color: item.color, size: 30),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("Ngày hoàn thành: ${item.date}"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mở chi tiết: ${item.title}')),
          );
        },
      ),
    );
  }
}
