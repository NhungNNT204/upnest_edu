import 'package:flutter/material.dart';
// Import các màn hình Dashboard
import 'admin_home_screen.dart'; // Admin screen
import 'student_home_screen.dart'; // Student screen
import 'teacher_home_screen.dart'; // Teacher screen

// Định nghĩa các quyền truy cập
enum UserRole {
  admin,
  student,
  teacher,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  // State mới để lưu trữ vai trò được chọn, mặc định là Học viên
  UserRole? _selectedRole = UserRole.student; 

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // CẬP NHẬT: Hàm xử lý khi nhấn nút Login
  void _handleLogin() {
    // Tạm thời bỏ qua xác minh Email/Pass

    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn quyền đăng nhập!')),
      );
      return;
    }

    Widget destinationScreen;

    switch (_selectedRole) {
      case UserRole.admin:
        // ĐÃ SỬA LỖI: Bỏ 'const'
        destinationScreen = const HomePageScreen(); 
        break;
      case UserRole.student:
        // ĐÃ SỬA LỖI: Bỏ 'const'
        destinationScreen = StudentHomeScreen(); 
        break;
      case UserRole.teacher:
        // ĐÃ SỬA LỖI: Bỏ 'const'
        destinationScreen = TeacherHomeScreen(); 
        break;
      default:
        // Trường hợp không chọn gì hoặc lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi lựa chọn vai trò.')),
        );
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. AppBar
      appBar: AppBar(
        title: const Text('Đăng nhập'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      // 2. Body
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon hoặc Logo
              Icon(
                Icons.school,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),

              // Tiêu đề
              Text(
                'Hệ thống Quản lý Đào tạo',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              
              // --- KHỐI CHỌN QUYỀN ĐĂNG NHẬP ---
              DropdownButtonFormField<UserRole>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Quyền đăng nhập',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: UserRole.admin,
                    child: Text('Quản trị viên'),
                  ),
                  DropdownMenuItem(
                    value: UserRole.student,
                    child: Text('Học viên'),
                  ),
                  DropdownMenuItem(
                    value: UserRole.teacher,
                    child: Text('Giảng viên'),
                  ),
                ],
                onChanged: (UserRole? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              // --- KẾT THÚC KHỐI MỚI ---

              // Trường nhập Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'vidu@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Trường nhập Mật khẩu
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // Nút ẩn/hiện mật khẩu
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Nút 'Quên mật khẩu?' (Tùy chọn)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Chưa làm gì cả
                  },
                  child: const Text('Quên mật khẩu?'),
                ),
              ),
              const SizedBox(height: 16),

              // Nút Đăng nhập
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleLogin, 
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
