// ============================================================
// FILE: screens/create_post_screen.dart
// MỤC ĐÍCH: Màn hình tạo bài đăng mới bằng POST request.
// BONUS – Lab 8: Optional POST request (full CRUD workflow)
// ============================================================

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/post.dart';

/// [CreatePostScreen]: Màn hình Stateful vì cần quản lý:
/// - Nội dung trong các TextField (form)
/// - Trạng thái loading khi đang gửi request
/// - Kết quả sau khi tạo thành công
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // Key để quản lý và validate form
  final _formKey = GlobalKey<FormState>();

  // Controller để đọc/ghi nội dung của TextField tiêu đề
  final _titleController = TextEditingController();

  // Controller để đọc/ghi nội dung của TextField nội dung
  final _bodyController = TextEditingController();

  // Instance ApiService để gọi POST API
  final _apiService = ApiService();

  // Biến kiểm soát trạng thái loading (đang gửi request hay không)
  bool _isLoading = false;

  // Lưu kết quả Post được tạo thành công (null nếu chưa tạo)
  Post? _createdPost;

  @override
  void dispose() {
    // Giải phóng controller khi widget bị hủy (tránh memory leak)
    _titleController.dispose();
    _bodyController.dispose();
    _apiService.dispose();
    super.dispose();
  }

  /// Phương thức [_submitForm]: Xử lý sự kiện gửi form
  /// 1. Validate dữ liệu form
  /// 2. Gọi ApiService.createPost() để gửi POST request
  /// 3. Cập nhật UI theo kết quả
  Future<void> _submitForm() async {
    // Validate form — nếu không hợp lệ thì dừng lại
    if (!_formKey.currentState!.validate()) return;

    // Bật trạng thái loading
    setState(() {
      _isLoading = true;
      _createdPost = null; // Reset kết quả cũ
    });

    try {
      // Gọi ApiService để gửi POST request
      final newPost = await _apiService.createPost(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        userId: 1, // Dùng userId mặc định
      );

      // Cập nhật UI khi tạo thành công
      if (mounted) {
        setState(() {
          _createdPost = newPost;
          _isLoading = false;
        });
        // Hiển thị SnackBar thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Tạo bài đăng thành công! (HTTP 201 Created)'),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Xử lý lỗi — hiển thị SnackBar thông báo lỗi
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Phương thức [_resetForm]: Đặt lại form về trạng thái ban đầu
  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _bodyController.clear();
    setState(() => _createdPost = null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // ---- AppBar ----
      appBar: AppBar(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tạo bài đăng mới',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'POST /posts',
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                color: colorScheme.onSecondary.withAlpha(200),
              ),
            ),
          ],
        ),
      ),

      // ---- Body ----
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Thông tin về POST request ----
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colorScheme.secondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Dữ liệu sẽ được gửi qua HTTP POST đến '
                      'jsonplaceholder.typicode.com. '
                      'API này giả lập tạo mới và trả về ID mới.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---- Form nhập liệu ----
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label cho trường Tiêu đề
                  Text(
                    'Tiêu đề *',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // TextField cho tiêu đề bài đăng
                  TextFormField(
                    controller: _titleController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      hintText: 'Nhập tiêu đề bài đăng...',
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                    ),
                    maxLength: 100,
                    // Validator: kiểm tra không để trống
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Tiêu đề không được để trống';
                      }
                      if (value.trim().length < 5) {
                        return 'Tiêu đề phải có ít nhất 5 ký tự';
                      }
                      return null; // null = hợp lệ
                    },
                  ),

                  const SizedBox(height: 16),

                  // Label cho trường Nội dung
                  Text(
                    'Nội dung *',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // TextField cho nội dung bài đăng
                  TextFormField(
                    controller: _bodyController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      hintText: 'Nhập nội dung bài đăng...',
                      prefixIcon: const Icon(Icons.article_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      // Đẩy icon lên trên khi có nhiều dòng
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                    ),
                    // Cho phép nhập nhiều dòng
                    maxLines: 5,
                    maxLength: 500,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nội dung không được để trống';
                      }
                      if (value.trim().length < 10) {
                        return 'Nội dung phải có ít nhất 10 ký tự';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // ---- Nút Gửi ----
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _submitForm,
                      // Hiển thị spinner khi đang loading, icon khi bình thường
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send),
                      label: Text(
                        _isLoading ? 'Đang gửi...' : 'Gửi POST Request',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---- Hiển thị kết quả sau khi tạo thành công ----
            if (_createdPost != null) ...[
              const SizedBox(height: 28),
              const Divider(),
              const SizedBox(height: 16),

              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Kết quả từ server (HTTP 201)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Hiển thị JSON response từ server
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SelectableText(
                  '// Response từ POST /posts\n'
                  '{\n'
                  '  "userId": ${_createdPost!.userId},\n'
                  '  "id": ${_createdPost!.id},  // ID mới được server tạo\n'
                  '  "title": "${_createdPost!.title}",\n'
                  '  "body": "${_createdPost!.body}"\n'
                  '}',
                  style: const TextStyle(
                    color: Color(0xFF9CDCFE),
                    fontFamily: 'monospace',
                    fontSize: 12.5,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Nút tạo bài mới
              OutlinedButton.icon(
                onPressed: _resetForm,
                icon: const Icon(Icons.add),
                label: const Text('Tạo bài đăng khác'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
