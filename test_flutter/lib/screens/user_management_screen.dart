import 'package:flutter/material.dart';

// Model giả lập cho Người dùng
class User {
  final String id;
  final String name;
  final String role;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
  });
}

// Dữ liệu người dùng giả lập
final List<User> mockUsers = [
  User(id: '1', name: 'Nguyễn Văn An', role: 'Student', email: 'an.nv@edu.vn'),
  User(id: '2', name: 'Trần Thị Bình', role: 'Student', email: 'binh.tt@edu.vn'),
  User(id: '3', name: 'Lê Văn Chính', role: 'Admin', email: 'chinh.lv@admin.vn'),
  User(id: '4', name: 'Phạm Thị Diệu', role: 'Teacher', email: 'dieu.pt@teacher.vn'),
  User(id: '5', name: 'Hoàng Văn Duy', role: 'Student', email: 'duy.hv@edu.vn'),
];

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _selectedRoleFilter = 'All';
  List<User> _filteredUsers = mockUsers;

  @override
  void initState() {
    super.initState();
    _filteredUsers = mockUsers;
  }

  void _filterUsers(String role) {
    setState(() {
      _selectedRoleFilter = role;
      if (role == 'All') {
        _filteredUsers = mockUsers;
      } else {
        _filteredUsers = mockUsers.where((user) => user.role == role).toList();
      }
    });
  }

  void _showEditUserDialog(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sửa chi tiết Người dùng: ${user.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(initialValue: user.name, decoration: const InputDecoration(labelText: 'Tên')),
                TextFormField(initialValue: user.email, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: user.role,
                  decoration: const InputDecoration(labelText: 'Vai trò (Role)'),
                  items: <String>['Admin', 'Teacher', 'Student']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Cập nhật giả lập
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Mock password reset logic
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã gửi yêu cầu đặt lại mật khẩu cho ${user.email}')),
                    );
                  },
                  icon: const Icon(Icons.lock_reset),
                  label: const Text('Đặt lại Mật khẩu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade100,
                    foregroundColor: Colors.orange.shade800,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Lưu')),
          ],
        );
      },
    );
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm Người dùng Mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(decoration: const InputDecoration(labelText: 'Họ và Tên')),
                TextFormField(decoration: const InputDecoration(labelText: 'Email')),
                TextFormField(decoration: const InputDecoration(labelText: 'Mật khẩu ban đầu')),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: 'Student',
                  decoration: const InputDecoration(labelText: 'Vai trò (Role)'),
                  items: <String>['Admin', 'Teacher', 'Student']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Cập nhật giả lập
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Thêm Người dùng')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Người dùng'),
        backgroundColor: Colors.teal.shade50,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUserDialog,
        icon: const Icon(Icons.person_add),
        label: const Text('Thêm Người dùng'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Bộ lọc theo Vai trò
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Lọc theo Vai trò:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedRoleFilter,
                  items: <String>['All', 'Admin', 'Teacher', 'Student']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _filterUsers(newValue);
                    }
                  },
                ),
                const Spacer(),
                Text('Tổng: ${_filteredUsers.length} người dùng', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          // Danh sách Người dùng
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: user.role == 'Admin' ? Colors.red.shade100 : Colors.blue.shade100,
                      child: Icon(Icons.person, color: user.role == 'Admin' ? Colors.red : Colors.blue),
                    ),
                    title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email),
                        Text('Vai trò: ${user.role}', style: TextStyle(color: user.role == 'Admin' ? Colors.red.shade700 : Colors.green.shade700)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.teal),
                      onPressed: () => _showEditUserDialog(user),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
