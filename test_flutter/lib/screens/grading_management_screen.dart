import 'package:flutter/material.dart';

// --- WIDGET PLACEHOLDER CHO MÀN HÌNH CHẤM ĐIỂM CHI TIẾT ---
class GradingDetailScreen extends StatelessWidget {
  final String essayTitle;
  final String studentName;

  const GradingDetailScreen({super.key, required this.essayTitle, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chấm điểm: $essayTitle'),
        backgroundColor: Colors.amber.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin chung
            Text('Bài làm của: $studentName', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text('Chủ đề: $essayTitle', style: Theme.of(context).textTheme.titleMedium),
            const Divider(height: 30),

            // Khu vực nội dung bài làm (Placeholder)
            Text('Nội dung Bài luận (Mô phỏng)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Đây là nội dung bài luận mà sinh viên đã nộp. Cần có giao diện hiển thị rõ ràng, hỗ trợ cuộn và có thể hỗ trợ các tính năng ghi chú/highlight trực tiếp (trong hệ thống thực tế).\n\n"
                "Sinh viên đã thể hiện sự hiểu biết sâu sắc về chủ đề. Cấu trúc bài viết chặt chẽ và lập luận logic. Tuy nhiên, phần kết luận còn hơi ngắn gọn và chưa tổng hợp được hết các điểm chính.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 30),

            // Khu vực chấm điểm và nhận xét
            Text('Đánh giá & Chấm điểm', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // Nhập điểm
            TextFormField(
              initialValue: '9.0',
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Điểm (0-10)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Nhận xét chi tiết
            TextFormField(
              maxLines: 5,
              initialValue: 'Bài viết xuất sắc, lập luận rất thuyết phục. Cần cải thiện phần tổng kết cuối bài.',
              decoration: const InputDecoration(
                labelText: 'Nhận xét cho Sinh viên',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Nút hành động
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Lưu Nháp'),
                ),
                const SizedBox(width: 15),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bài luận đã được Phê duyệt & Chấm điểm!')),
                    );
                    Navigator.pop(context); // Quay lại danh sách
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Phê duyệt & Chấm điểm', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// --- WIDGET CHÍNH CHO MÀN HÌNH QUẢN LÝ CHẤM ĐIỂM ---
class GradingManagementScreen extends StatelessWidget {
  const GradingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Chỉ cần 2 tab: Danh sách Bài luận và Báo cáo Điểm
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản Lý Chấm Điểm & Đánh Giá'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.assignment), text: 'Bài Luận Chờ Chấm'),
              Tab(icon: Icon(Icons.analytics), text: 'Báo Cáo Điểm'),
            ],
          ),
          elevation: 1,
        ),
        body: TabBarView(
          children: [
            // TAB 1: DANH SÁCH BÀI LUẬN CHỜ CHẤM
            _buildEssayListTab(context),
            // TAB 2: BÁO CÁO ĐIỂM
            _buildScoreReportTab(context),
          ],
        ),
      ),
    );
  }

  // Widget xây dựng Tab Danh sách Bài Luận Chờ Chấm
  Widget _buildEssayListTab(BuildContext context) {
    final List<Map<String, String>> essays = [
      {'title': 'Tác động của AI đến Giáo dục', 'student': 'Nguyễn Văn A', 'date': '20/10/2025', 'status': 'Chờ chấm'},
      {'title': 'Phân tích Chiến lược Marketing', 'student': 'Trần Thị B', 'date': '19/10/2025', 'status': 'Đã chấm (8.5)'},
      {'title': 'Lịch sử Phát triển Internet', 'student': 'Lê Văn C', 'date': '18/10/2025', 'status': 'Chờ chấm'},
      {'title': 'Thiết kế Hệ thống Cơ sở Dữ liệu', 'student': 'Phạm Thị D', 'date': '17/10/2025', 'status': 'Chờ chấm'},
    ];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: essays.length,
        itemBuilder: (context, index) {
          final essay = essays[index];
          final bool isPending = essay['status'] == 'Chờ chấm';

          return Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
            child: ListTile(
              leading: Icon(
                isPending ? Icons.pending_actions : Icons.check_circle,
                color: isPending ? Colors.amber.shade700 : Colors.green.shade600,
              ),
              title: Text('${essay['title']} - ${essay['student']}'),
              subtitle: Text('Nộp ngày: ${essay['date']} | Trạng thái: ${essay['status']}'),
              trailing: isPending
                  ? ElevatedButton.icon(
                      onPressed: () {
                        // Điều hướng đến màn hình chấm điểm chi tiết
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GradingDetailScreen(
                              essayTitle: essay['title']!,
                              studentName: essay['student']!,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.rate_review, size: 18),
                      label: const Text('Chấm điểm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade400,
                        foregroundColor: Colors.black87,
                      ),
                    )
                  : const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: !isPending
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Xem chi tiết bài đã chấm của ${essay['student']}')),
                      );
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }

  // Widget xây dựng Tab Báo cáo Điểm
  Widget _buildScoreReportTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Báo Cáo Điểm Tổng Hợp',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 15),
          const Text('Chọn các tiêu chí để xuất báo cáo:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 15),

          // Bộ lọc (Placeholder)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Chọn Khóa học',
              border: OutlineInputBorder(),
            ),
            value: 'Kỹ thuật lập trình',
            items: ['Kỹ thuật lập trình', 'Thiết kế Web', 'Cơ sở Dữ liệu'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Xử lý thay đổi
            },
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Chọn Lớp',
              border: OutlineInputBorder(),
            ),
            value: 'D19CNTT01',
            items: ['D19CNTT01', 'D19CNTT02', 'D20KTPM01'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Xử lý thay đổi
            },
          ),
          const SizedBox(height: 25),

          // Bảng điểm giả định
          Text('Bảng Điểm Tổng Hợp (Mô phỏng)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(4),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(2),
              },
              border: TableBorder.all(color: Colors.grey.shade200),
              children: [
                // Header
                TableRow(
                  decoration: BoxDecoration(color: Colors.blue.shade50),
                  children: [
                    _buildCell('STT', isHeader: true),
                    _buildCell('Họ tên Sinh viên', isHeader: true),
                    _buildCell('Điểm TB', isHeader: true),
                    _buildCell('Hành động', isHeader: true),
                  ],
                ),
                // Data rows
                _buildDataRow('1', 'Nguyễn Văn A', '8.5', context),
                _buildDataRow('2', 'Trần Thị B', '7.9', context),
                _buildDataRow('3', 'Lê Văn C', '9.1', context),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Nút Xuất báo cáo
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đang xuất báo cáo điểm... (Chức năng mô phỏng)')),
              );
            },
            icon: const Icon(Icons.download, color: Colors.white),
            label: const Text('Xuất Báo Cáo CSV', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm hỗ trợ tạo cell cho bảng
  TableCell _buildCell(String text, {bool isHeader = false}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: isHeader ? 14 : 13,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Hàm hỗ trợ tạo dòng dữ liệu cho bảng
  TableRow _buildDataRow(String stt, String name, String score, BuildContext context) {
    return TableRow(
      children: [
        _buildCell(stt),
        _buildCell(name),
        _buildCell(score),
        TableCell(
          child: IconButton(
            icon: const Icon(Icons.remove_red_eye, size: 20, color: Colors.indigo),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Xem bảng điểm chi tiết của $name')),
              );
            },
          ),
        ),
      ],
    );
  }
}
