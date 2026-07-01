// ============================================================
// FILE: widgets/post_card.dart
// MỤC ĐÍCH: Widget tái sử dụng để hiển thị một bài đăng dạng Card.
// Tách widget ra file riêng giúp code gọn gàng và dễ bảo trì.
// ============================================================

import 'package:flutter/material.dart';
import '../models/post.dart';

/// Widget [PostCard] hiển thị thông tin tóm tắt của một bài đăng.
/// Nhận vào một [Post] và một callback [onTap] khi người dùng bấm vào.
class PostCard extends StatelessWidget {
  /// Đối tượng Post chứa dữ liệu cần hiển thị
  final Post post;

  /// Callback được gọi khi người dùng bấm vào card
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Card widget bao ngoài để có hiệu ứng shadow và bo góc
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      // Bo góc cho card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      // InkWell để có hiệu ứng ripple khi bấm
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge hiển thị ID bài đăng
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  // Dùng màu primaryContainer từ color scheme
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '#${post.id}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Phần nội dung bên phải (chiếm toàn bộ không gian còn lại)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hiển thị tiêu đề bài đăng
                    Text(
                      // Viết hoa chữ cái đầu tiên của tiêu đề
                      post.title[0].toUpperCase() + post.title.substring(1),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      // Giới hạn 2 dòng, phần còn lại hiển thị dấu "..."
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Hiển thị nội dung tóm tắt
                    Text(
                      post.body,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Thẻ hiển thị thông tin User ID
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'User #${post.userId}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        // Icon mũi tên gợi ý có thể bấm để xem thêm
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
