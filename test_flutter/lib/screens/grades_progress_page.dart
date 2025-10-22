import 'package:flutter/material.dart';

// --- MOCK DATA MODELS (Mô hình dữ liệu giả lập) ---

/// Mô hình cho từng điểm thành phần trong một môn học.
class ChiTietDiem {
  final String tenBaiKiemTra; // Tên bài kiểm tra
  final double diem; // Điểm
  final int trongSoPhanTram; // Trọng số (%)

  ChiTietDiem({
    required this.tenBaiKiemTra,
    required this.diem,
    required this.trongSoPhanTram,
  });
}

/// Mô hình cho một môn học đã/đang học.
class MonHoc {
  final String tenMon; // Tên môn học
  final String maMon; // Mã môn
  final String hocKy; // Học kỳ
  final double diemTongKet; // Điểm tổng kết (Final Grade)
  final String xepHang; // Xếp hạng trong lớp (ví dụ: Top 10%)
  final String nhanXetGiangVien; // Nhận xét cuối kỳ
  final List<ChiTietDiem> chiTietDiem; // Chi tiết điểm thành phần

  MonHoc({
    required this.tenMon,
    required this.maMon,
    required this.hocKy,
    required this.diemTongKet,
    required this.xepHang,
    required this.nhanXetGiangVien,
    required this.chiTietDiem,
  });
}

/// Mô hình cho tiến độ tổng quát qua các kỳ.
class TienDoHocKy {
  final String hocKy; // Học kỳ
  final double diemTB; // Điểm trung bình (GPA)

  TienDoHocKy({
    required this.hocKy,
    required this.diemTB,
  });
}

final List<MonHoc> mockGrades = [
  MonHoc(
    tenMon: 'Lập trình Di động (Flutter)',
    maMon: 'CS401',
    hocKy: '2025/1',
    diemTongKet: 9.2,
    xepHang: 'Top 5%',
    nhanXetGiangVien:
        'Sinh viên thể hiện sự nắm vững các nguyên tắc lập trình Dart và Flutter. Bài tập lớn hoàn thành xuất sắc.',
    chiTietDiem: [
      ChiTietDiem(tenBaiKiemTra: 'Thực hành 1', diem: 9.5, trongSoPhanTram: 20),
      ChiTietDiem(tenBaiKiemTra: 'Bài tập giữa kỳ', diem: 8.8, trongSoPhanTram: 30),
      ChiTietDiem(tenBaiKiemTra: 'Bài tập cuối kỳ', diem: 9.3, trongSoPhanTram: 50),
    ],
  ),
  MonHoc(
    tenMon: 'Cấu trúc Dữ liệu & Giải thuật',
    maMon: 'CS205',
    hocKy: '2024/2',
    diemTongKet: 8.5,
    xepHang: 'Top 15%',
    nhanXetGiangVien: 'Kiến thức nền tảng vững chắc. Cần cải thiện tốc độ giải quyết vấn đề trong các bài toán khó.',
    chiTietDiem: [
      ChiTietDiem(tenBaiKiemTra: 'Giữa kỳ', diem: 7.5, trongSoPhanTram: 40),
      ChiTietDiem(tenBaiKiemTra: 'Cuối kỳ', diem: 9.2, trongSoPhanTram: 60),
    ],
  ),
  MonHoc(
    tenMon: 'Thiết kế Trải nghiệm Người dùng',
    maMon: 'UX302',
    hocKy: '2024/2',
    diemTongKet: 9.5,
    xepHang: 'Top 3%',
    nhanXetGiangVien: 'Sản phẩm demo cuối khóa có tính sáng tạo cao và tuân thủ tốt nguyên tắc UX/UI hiện đại.',
    chiTietDiem: [
      ChiTietDiem(tenBaiKiemTra: 'Đồ án 1', diem: 9.0, trongSoPhanTram: 30),
      ChiTietDiem(tenBaiKiemTra: 'Đồ án cuối kỳ', diem: 9.8, trongSoPhanTram: 70),
    ],
  ),
];

final List<TienDoHocKy> mockProgress = [
  TienDoHocKy(hocKy: '2024/1', diemTB: 7.8),
  TienDoHocKy(hocKy: '2024/2', diemTB: 8.6),
  TienDoHocKy(hocKy: '2025/1', diemTB: 9.1), // Dự kiến/Hiện tại
];

// --- WIDGET CHÍNH ---

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hệ thống Kết quả Học tập',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: false,
      ),
      home: const GradesProgressPage(),
    );
  }
}

class GradesProgressPage extends StatelessWidget {
  const GradesProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Kết Quả Học Tập (Grades & Progress)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.indigo,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Bảng Điểm Cá Nhân'),
              Tab(text: 'Biểu Đồ Tiến Bộ'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // 1. Bảng điểm cá nhân
            PersonalGradesView(),
            // 2. Biểu đồ tiến bộ
            ProgressChartView(),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET: BẢNG ĐIỂM CÁ NHÂN ---

class PersonalGradesView extends StatelessWidget {
  const PersonalGradesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: mockGrades.length,
      itemBuilder: (context, index) {
        final MonHoc course = mockGrades[index];
        return MonHocCard(course: course);
      },
    );
  }
}

class MonHocCard extends StatelessWidget {
  final MonHoc course;
  const MonHocCard({required this.course, super.key});

  @override
  Widget build(BuildContext context) {
    Color gradeColor;
    if (course.diemTongKet >= 9.0) {
      gradeColor = Colors.green.shade700;
    } else if (course.diemTongKet >= 8.0) {
      gradeColor = Colors.blue.shade700;
    } else {
      gradeColor = Colors.orange.shade700;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16.0),
        // Tiêu đề chính của môn học
        title: Text(
          course.tenMon,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // Điểm tổng kết và xếp hạng
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${course.diemTongKet}',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: gradeColor,
              ),
            ),
            Text(
              course.xepHang,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        // Thông tin phụ
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mã: ${course.maMon} - Học kỳ: ${course.hocKy}'),
              const SizedBox(height: 4),
              const Text(
                'Chạm để xem chi tiết...',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ],
          ),
        ),
        // Nội dung chi tiết (Mở rộng)
        children: <Widget>[
          const Divider(height: 1, thickness: 1),
          // Bảng chi tiết điểm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ChiTietDiemTable(gradeItems: course.chiTietDiem),
          ),
          // Nhận xét giảng viên
          NhanXetGiangVien(nhanXet: course.nhanXetGiangVien),
        ],
      ),
    );
  }
}

// --- WIDGET: CHI TIẾT KHÓA HỌC (Bảng điểm thành phần) ---

class ChiTietDiemTable extends StatelessWidget {
  final List<ChiTietDiem> gradeItems;
  const ChiTietDiemTable({required this.gradeItems, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Điểm Từng Bài Kiểm Tra',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey.shade300, width: 0.5),
            ),
            children: [
              // Hàng tiêu đề
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                children: const [
                  _TableCell(text: 'Bài kiểm tra', isHeader: true),
                  _TableCell(text: 'Điểm', isHeader: true),
                  _TableCell(text: 'Trọng số', isHeader: true),
                ],
              ),
              // Dữ liệu
              ...gradeItems.map((item) {
                return TableRow(
                  children: [
                    _TableCell(text: item.tenBaiKiemTra),
                    _TableCell(text: '${item.diem}', color: Colors.black87),
                    _TableCell(text: '${item.trongSoPhanTram}%'),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final Color? color;
  const _TableCell({required this.text, this.isHeader = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 14 : 15,
          color: color ?? (isHeader ? Colors.indigo.shade900 : Colors.black54),
        ),
      ),
    );
  }
}

// --- WIDGET: NHẬN XÉT GIẢNG VIÊN ---

class NhanXetGiangVien extends StatelessWidget {
  final String nhanXet;
  const NhanXetGiangVien({required this.nhanXet, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0).copyWith(top: 0),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📝 Nhận Xét Cuối Kỳ của Giảng Viên',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nhanXet,
            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET: BIỂU ĐỒ TIẾN BỘ (Mô phỏng) ---

class ProgressChartView extends StatelessWidget {
  const ProgressChartView({super.key});

  @override
  Widget build(BuildContext context) {
    // Tìm điểm trung bình cao nhất để chuẩn hóa đồ thị
    final double maxGpa = mockProgress
            .map((e) => e.diemTB)
            .reduce((a, b) => a > b ? a : b) +
        0.5; // Thêm một chút padding

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Xu Hướng Điểm Trung Bình Qua Các Học Kỳ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 16),
          // Khung biểu đồ (Mô phỏng Line Chart bằng CustomPaint hoặc Container)
          Container(
            height: 200,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 4), blurRadius: 8)
              ],
            ),
            child: CustomPaint(
              painter: ProgressLinePainter(mockProgress: mockProgress, maxGpa: maxGpa),
              child: Container(), // CustomPaint sẽ vẽ biểu đồ
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Chi Tiết Tiến Độ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 12),
          // Bảng chi tiết tiến độ
          ...mockProgress.map((p) => DiemTBRow(progress: p)).toList(),
        ],
      ),
    );
  }
}

// CustomPainter để vẽ đường (mô phỏng) biểu đồ
class ProgressLinePainter extends CustomPainter {
  final List<TienDoHocKy> mockProgress;
  final double maxGpa;

  ProgressLinePainter({required this.mockProgress, required this.maxGpa});

  @override
  void paint(Canvas canvas, Size size) {
    // Cài đặt cọ vẽ
    final Paint linePaint = Paint()
      ..color = Colors.indigo.shade400
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final Paint pointPaint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.fill;

    // Tính toán tỷ lệ
    final double stepX = size.width / (mockProgress.length - 1);
    const double minY = 0.0; // Điểm bắt đầu của GPA
    final double maxY = maxGpa; // Điểm tối đa để chuẩn hóa

    List<Offset> points = [];

    // Tạo các điểm
    for (int i = 0; i < mockProgress.length; i++) {
      final progress = mockProgress[i];
      // Tính toán vị trí Y (đảo ngược vì 0 là đỉnh trên)
      final double normalizedY = (progress.diemTB - minY) / (maxY - minY);
      final double y = size.height * (1.0 - normalizedY);
      final double x = stepX * i;
      points.add(Offset(x, y));

      // Vẽ text (Điểm TB)
      final textPainter = TextPainter(
        text: TextSpan(
          text: progress.diemTB.toStringAsFixed(2),
          style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x - (textPainter.width / 2), y - 25));

      // Vẽ text (Học kỳ)
      final semesterPainter = TextPainter(
        text: TextSpan(
          text: progress.hocKy,
          style: const TextStyle(
              color: Colors.grey, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      semesterPainter.layout();
      semesterPainter.paint(
          canvas, Offset(x - (semesterPainter.width / 2), size.height + 5));
    }

    // Vẽ đường nối các điểm
    if (points.length > 1) {
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], linePaint);
      }
    }

    // Vẽ các điểm (circles)
    for (final point in points) {
      canvas.drawCircle(point, 6.0, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressLinePainter oldDelegate) {
    return mockProgress != oldDelegate.mockProgress;
  }
}

// Hàng chi tiết điểm TB
class DiemTBRow extends StatelessWidget {
  final TienDoHocKy progress;
  const DiemTBRow({required this.progress, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Học kỳ: ${progress.hocKy}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.indigo),
            ),
          ),
          Text(
            'Điểm TB (GPA): ${progress.diemTB.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: progress.diemTB >= 9.0 ? Colors.green.shade700 : Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
