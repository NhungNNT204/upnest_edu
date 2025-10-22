import 'package:flutter/material.dart';
// Import file login screen bạn vừa tạo
import 'screens/login_screen.dart'; 
// import 'package:firebase_core/firebase_core.dart'; // Tạm thời ẩn đi

void main() async {
  // Tạm thời không cần khởi tạo Firebase
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Chúng ta không cần Provider vì chỉ test UI
    return MaterialApp(
      title: 'Student Manager (UI Test)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Dùng Material 3
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // Trỏ thẳng đến LoginScreen
      home: LoginScreen(), 
    );
  }
}

// Tạm thời không cần AuthWrapper
// class AuthWrapper extends StatelessWidget { ... }