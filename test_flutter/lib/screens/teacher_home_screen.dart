import 'package:flutter/material.dart';

// Placeholder cho màn hình Dashboard Giảng viên
class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Giảng Viên'),
        backgroundColor: Colors.indigo,
      ),
      body: const Center(
        child: Text(
          'Đây là màn hình Dashboard dành cho Giảng viên (Đang phát triển)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
