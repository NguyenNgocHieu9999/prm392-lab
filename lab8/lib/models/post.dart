// ============================================================
// FILE: models/post.dart
// MỤC ĐÍCH: Định nghĩa Model class đại diện cho một bài đăng (post)
// được lấy từ API https://jsonplaceholder.typicode.com/posts
// ============================================================

// Lớp [Post] ánh xạ dữ liệu JSON trả về từ API thành đối tượng Dart.
/// Mỗi bài đăng có các trường: userId, id, title, body.
class Post {
  /// ID của người dùng đã tạo bài đăng
  final int userId;

  /// ID duy nhất của bài đăng
  final int id;

  /// Tiêu đề của bài đăng
  final String title;

  /// Nội dung của bài đăng
  final String body;

  /// Constructor chính: yêu cầu tất cả các trường bắt buộc
  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  /// Factory constructor [fromJson]:
  /// Chuyển đổi một Map&lt;String, dynamic&gt; (JSON đã decode) thành đối tượng [Post].
  ///
  /// Ví dụ JSON đầu vào:
  /// {
  ///   "userId": 1,
  ///   "id": 1,
  ///   "title": "sunt aut facere...",
  ///   "body": "quia et suscipit..."
  /// }
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      // Lấy giá trị 'userId' từ JSON, ép kiểu thành int
      userId: json['userId'] as int,
      // Lấy giá trị 'id' từ JSON, ép kiểu thành int
      id: json['id'] as int,
      // Lấy giá trị 'title' từ JSON, ép kiểu thành String
      title: json['title'] as String,
      // Lấy giá trị 'body' từ JSON, ép kiểu thành String
      body: json['body'] as String,
    );
  }

  /// Phương thức [toJson]:
  /// Chuyển đổi đối tượng [Post] thành Map để gửi qua POST request.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  /// Override [toString] để dễ dàng debug in ra thông tin post
  @override
  String toString() {
    return 'Post(userId: $userId, id: $id, title: $title)';
  }
}
