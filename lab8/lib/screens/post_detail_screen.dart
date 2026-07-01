// ============================================================
// FILE: screens/post_detail_screen.dart
// MỤC ĐÍCH: Màn hình chi tiết hiển thị toàn bộ thông tin của một
// bài đăng khi người dùng bấm vào item trong danh sách.
// BONUS: Màn hình chi tiết (tap item → detail screen)
// ============================================================

import 'package:flutter/material.dart';
import '../models/post.dart';

/// [PostDetailScreen]: Màn hình Stateless vì không cần quản lý state.
/// Nhận vào đối tượng [Post] đã được tải sẵn từ màn hình danh sách.
class PostDetailScreen extends StatelessWidget {
  /// Đối tượng Post cần hiển thị chi tiết
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // ---- AppBar ----
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Text('Bài đăng #${post.id}'),
        // Nút back tự động được thêm vì màn hình này được push lên stack
      ),

      // ---- Body ----
      body: SingleChildScrollView(
        // SingleChildScrollView cho phép cuộn khi nội dung dài
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Thẻ thông tin metadata ----
            Row(
              children: [
                // Badge ID bài đăng
                _buildInfoChip(
                  context,
                  icon: Icons.tag,
                  label: 'ID: ${post.id}',
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 10),
                // Badge User ID
                _buildInfoChip(
                  context,
                  icon: Icons.person,
                  label: 'User: ${post.userId}',
                  color: colorScheme.secondary,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ---- Tiêu đề bài đăng ----
            Text(
              'Tiêu đề',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            // Container để tô nền cho tiêu đề
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                // Viết hoa chữ cái đầu
                post.title[0].toUpperCase() + post.title.substring(1),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---- Nội dung bài đăng ----
            Text(
              'Nội dung',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: Text(
                post.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ---- Section JSON Raw Data (để học sinh thấy cấu trúc JSON) ----
            ExpansionTile(
              leading: Icon(Icons.code, color: colorScheme.primary),
              title: const Text(
                'Xem JSON gốc',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Dữ liệu trả về từ API'),
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // Màu nền tối cho code block
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    // Hiển thị JSON format đẹp
                    '{\n'
                    '  "userId": ${post.userId},\n'
                    '  "id": ${post.id},\n'
                    '  "title": "${post.title}",\n'
                    '  "body": "${post.body}"\n'
                    '}',
                    style: const TextStyle(
                      color: Color(0xFF9CDCFE), // Màu xanh nhạt kiểu VS Code
                      fontFamily: 'monospace',
                      fontSize: 12,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget tạo chip thông tin nhỏ
  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(76)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
