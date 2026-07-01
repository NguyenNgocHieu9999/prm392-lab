// ============================================================
// FILE: main.dart
// MỤC ĐÍCH: Điểm khởi đầu (Entry Point) của ứng dụng Flutter.
// Khai báo MaterialApp và thiết lập theme, routing.
//
// LAB 8 – Building an API-powered List Screen
// ============================================================

import 'package:flutter/material.dart';

// Import màn hình chính (danh sách bài đăng)
import 'screens/post_list_screen.dart';

/// Hàm [main]: Điểm khởi chạy ứng dụng Dart/Flutter.
/// [runApp] nhận vào một Widget và gắn nó vào màn hình.
void main() {
  runApp(const MyApp());
}

/// [MyApp]: Widget gốc của ứng dụng (StatelessWidget vì không cần state).
/// Bao gồm MaterialApp để cung cấp theme, navigation, và localization.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Tiêu đề ứng dụng (hiển thị trên task switcher của thiết bị)
      title: 'Lab 8 – API List App',

      // Ẩn banner "DEBUG" ở góc trên bên phải khi chạy debug mode
      debugShowCheckedModeBanner: false,

      // ---- Thiết lập Theme (Giao diện) ----
      // Sử dụng Material 3 (Material You) để có giao diện hiện đại
      theme: ThemeData(
        // ColorScheme.fromSeed: tự động tạo bảng màu hài hòa từ màu seed
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Màu xanh dương chủ đạo
          brightness: Brightness.light,        // Chế độ sáng
        ),
        // Bật Material 3 (phiên bản Material Design mới nhất)
        useMaterial3: true,

        // Cấu hình AppBar mặc định
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),

        // Cấu hình Card mặc định
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.zero,
        ),

        // Cấu hình InputDecoration mặc định cho TextField
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
        ),
      ),

      // ---- Màn hình mặc định (Home) ----
      // PostListScreen là màn hình chính hiển thị danh sách bài đăng từ API
      home: const PostListScreen(),
    );
  }
}
