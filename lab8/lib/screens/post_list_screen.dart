// ============================================================
// FILE: screens/post_list_screen.dart
// MỤC ĐÍCH: Màn hình chính hiển thị danh sách bài đăng từ API.
// Kết hợp Lab 8.1 (GET), 8.2 (JSON→Model), 8.3 (Loading/Error),
// và 8.4 (ApiService) vào một màn hình hoàn chỉnh.
// ============================================================

import 'package:flutter/material.dart';

// Import ApiService để gọi API
import '../services/api_service.dart';
// Import Model Post
import '../models/post.dart';
// Import Widget PostCard tái sử dụng
import '../widgets/post_card.dart';
// Import màn hình chi tiết
import 'post_detail_screen.dart';
// Import màn hình tạo bài đăng mới
import 'create_post_screen.dart';

/// [PostListScreen]: Màn hình Stateful vì cần quản lý state của Future.
/// Sử dụng FutureBuilder để hiển thị dữ liệu bất đồng bộ từ API.
class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  // Tạo instance của ApiService (tầng service)
  // ApiService chịu trách nhiệm gọi API, UI chỉ cần gọi method
  late final ApiService _apiService;

  // Future chứa danh sách posts — sẽ được FutureBuilder lắng nghe
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    // Khởi tạo ApiService khi widget được tạo lần đầu
    _apiService = ApiService();
    // Bắt đầu tải dữ liệu ngay khi màn hình được khởi tạo
    _loadPosts();
  }

  /// Phương thức [_loadPosts]: Kích hoạt việc tải danh sách bài đăng.
  /// Gọi lại phương thức này để refresh dữ liệu (retry/pull-to-refresh).
  void _loadPosts() {
    setState(() {
      // Gán Future mới → FutureBuilder sẽ tự động rebuild UI
      _postsFuture = _apiService.fetchPosts();
    });
  }

  @override
  void dispose() {
    // Giải phóng tài nguyên HTTP client khi widget bị hủy
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // ---- AppBar ----
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lab 8 – REST API',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'jsonplaceholder.typicode.com',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onPrimary.withAlpha(204),
              ),
            ),
          ],
        ),
        actions: [
          // Nút refresh để tải lại danh sách thủ công
          IconButton(
            onPressed: _loadPosts,
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại danh sách',
          ),
        ],
      ),

      // ---- Body: FutureBuilder để xử lý trạng thái async ----
      // FutureBuilder tự động rebuild UI khi Future hoàn thành
      body: RefreshIndicator(
        // Pull-to-refresh: kéo xuống để tải lại (BONUS)
        onRefresh: () async => _loadPosts(),
        color: colorScheme.primary,
        child: FutureBuilder<List<Post>>(
          // Truyền Future vào FutureBuilder
          future: _postsFuture,

          // Builder được gọi mỗi khi trạng thái của Future thay đổi
          builder: (context, snapshot) {
            // ---- TRẠNG THÁI 1: Đang tải dữ liệu (waiting) ----
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState(colorScheme);
            }

            // ---- TRẠNG THÁI 2: Có lỗi xảy ra (hasError) ----
            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error, colorScheme);
            }

            // ---- TRẠNG THÁI 3: Không có dữ liệu ----
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState(colorScheme);
            }

            // ---- TRẠNG THÁI 4: Tải thành công — hiển thị danh sách ----
            final posts = snapshot.data!;
            return _buildSuccessState(posts, theme, colorScheme);
          },
        ),
      ),

      // ---- FAB: Nút tạo bài đăng mới (BONUS – POST request) ----
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Điều hướng đến màn hình tạo bài đăng mới
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreatePostScreen(),
            ),
          );
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Tạo bài đăng'),
      ),
    );
  }

  // ============================================================
  // CÁC WIDGET CON CHO TỪNG TRẠNG THÁI
  // ============================================================

  /// Widget hiển thị khi đang tải dữ liệu (Loading State)
  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CircularProgressIndicator: spinner tròn thể hiện đang tải
          CircularProgressIndicator(
            color: colorScheme.primary,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Đang tải dữ liệu từ API...',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'GET /posts',
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  /// Widget hiển thị khi có lỗi xảy ra (Error State)
  Widget _buildErrorState(Object? error, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon lỗi
            Icon(
              Icons.cloud_off_rounded,
              size: 80,
              color: colorScheme.error.withAlpha(178),
            ),
            const SizedBox(height: 20),
            Text(
              'Đã xảy ra lỗi!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 10),
            // Hiển thị thông báo lỗi chi tiết
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                error.toString().replaceFirst('Exception: ', ''),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onErrorContainer,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Nút Retry: thử lại khi có lỗi (BONUS)
            FilledButton.icon(
              onPressed: _loadPosts,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget hiển thị khi danh sách rỗng (Empty State)
  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            'Không có bài đăng nào',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  /// Widget hiển thị khi tải thành công — ListView danh sách bài đăng
  Widget _buildSuccessState(
    List<Post> posts,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        // Header thông tin số lượng bài đăng
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: colorScheme.surfaceContainerHighest,
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Tải thành công ${posts.length} bài đăng',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                'HTTP 200 OK',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),

        // ListView.builder: hiển thị danh sách tối ưu hiệu suất
        // Chỉ render các item đang hiển thị trên màn hình
        Expanded(
          child: ListView.builder(
            // Số lượng item trong danh sách
            itemCount: posts.length,
            // Khoảng cách padding trên/dưới danh sách
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            // Builder được gọi cho mỗi item với index tương ứng
            itemBuilder: (context, index) {
              final post = posts[index];
              // Sử dụng PostCard widget đã tạo riêng
              return PostCard(
                post: post,
                // Khi bấm vào card, điều hướng đến màn hình chi tiết
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(post: post),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
