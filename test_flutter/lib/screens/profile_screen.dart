import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Widget để hiển thị mục thống kê (số bạn bè, khóa học,...)
  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ Cá nhân'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // PHẦN 1: ẢNH ĐẠI DIỆN VÀ THÔNG TIN CƠ BẢN
            Container(
              padding: const EdgeInsets.only(top: 24, bottom: 20),
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              child: Column(
                children: [
                  // Ảnh Đại diện
                  CircleAvatar(
                    radius: 50,
                    // Giả định dùng ảnh placeholder
                    backgroundImage: NetworkImage('https://placehold.co/100x100/A0B2C4/FFFFFF/png?text=AVT'),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Nguyễn Văn A',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'MSSV: 20240001',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nút Chỉnh sửa Hồ sơ
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chức năng chỉnh sửa hồ sơ')),
                      );
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Chỉnh sửa hồ sơ'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),

            // PHẦN 2: THỐNG KÊ (STATISTICS)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildStatItem('12', 'Khóa học', Colors.green),
                      Container(height: 40, width: 1, color: Colors.grey.shade300),
                      _buildStatItem('35', 'Sách đã đọc', Colors.orange),
                      Container(height: 40, width: 1, color: Colors.grey.shade300),
                      _buildStatItem('5', 'Huy hiệu', Colors.deepPurple),
                    ],
                  ),
                ),
              ),
            ),
            
            // PHẦN 3: THÔNG TIN CHI TIẾT
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Thông tin Cá nhân',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Danh sách thông tin chi tiết
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 1,
              child: Column(
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.cake, color: Colors.blue),
                    title: Text('Ngày sinh'),
                    subtitle: Text('01/01/2000'),
                  ),
                  Divider(height: 0),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.red),
                    title: Text('Địa chỉ'),
                    subtitle: Text('TP. Hồ Chí Minh'),
                  ),
                  Divider(height: 0),
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.green),
                    title: Text('Điện thoại'),
                    subtitle: Text('+84 901 234 567'),
                  ),
                  Divider(height: 0),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.orange),
                    title: Text('Email'),
                    subtitle: Text('nguyenvana@hcm.edu.vn'),
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
