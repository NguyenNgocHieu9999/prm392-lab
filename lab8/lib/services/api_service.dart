// ============================================================
// FILE: services/api_service.dart
// MỤC ĐÍCH: Tầng Service Layer — tách biệt toàn bộ logic gọi API
// ra khỏi UI. Đây là Lab 8.4 – Service Layer Pattern.
// ============================================================

// Import thư viện chuẩn của Dart để xử lý HTTP
import 'dart:convert'; // Dùng để decode JSON (json.decode)

// Import package http để thực hiện HTTP request
import 'package:http/http.dart' as http;

// Import model Post đã tạo
import '../models/post.dart';

/// Lớp [ApiService] chịu trách nhiệm giao tiếp với REST API.
/// Toàn bộ logic gọi mạng được đóng gói trong class này,
/// giúp UI (Screen) tập trung vào việc hiển thị dữ liệu.
///
/// Pattern: Service Layer — tách biệt Business Logic & Network khỏi UI
class ApiService {
  /// URL gốc của API (base URL)
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// [http.Client] có thể được inject từ bên ngoài để dễ unit test.
  /// Nếu không truyền vào, sẽ dùng client mặc định.
  final http.Client _client;

  /// Constructor: nhận vào một http.Client tùy chọn (mặc định là http.Client())
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // ============================================================
  // LAB 8.1 & 8.2: GET Request — Lấy danh sách bài đăng
  // ============================================================

  /// Phương thức [fetchPosts]: Gửi GET request tới API để lấy danh sách posts.
  ///
  /// Luồng xử lý:
  /// 1. Gửi HTTP GET request tới endpoint /posts
  /// 2. Kiểm tra status code phản hồi
  /// 3. Decode JSON response thành List&lt;dynamic&gt;
  /// 4. Chuyển đổi mỗi phần tử thành đối tượng Post qua fromJson()
  /// 5. Trả về List&lt;Post&gt;
  ///
  /// Ném ra [Exception] nếu:
  /// - Server trả về status code khác 200
  /// - Có lỗi kết nối mạng
  Future<List<Post>> fetchPosts() async {
    // Xây dựng URI từ base URL và endpoint
    final uri = Uri.parse('$_baseUrl/posts');

    try {
      // Gửi GET request và chờ phản hồi (async/await)
      final response = await _client.get(uri);

      // Kiểm tra HTTP status code
      if (response.statusCode == 200) {
        // Decode chuỗi JSON thành List<dynamic>
        // json.decode() từ thư viện dart:convert
        final List<dynamic> jsonList = json.decode(response.body);

        // Chuyển đổi mỗi phần tử JSON thành đối tượng Post
        // Sử dụng factory constructor Post.fromJson()
        return jsonList
            .map((jsonItem) => Post.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
      } else {
        // Nếu server trả lỗi (400, 404, 500,...), ném Exception
        throw Exception(
          'Lỗi từ server: HTTP ${response.statusCode}. '
          'Không thể tải danh sách bài đăng.',
        );
      }
    } on http.ClientException catch (e) {
      // Lỗi kết nối mạng (không có internet, timeout,...)
      throw Exception('Lỗi kết nối mạng: ${e.message}');
    } catch (e) {
      // Các lỗi khác (JSON parse error, ...)
      rethrow;
    }
  }

  // ============================================================
  // LAB 8.2: GET Request — Lấy chi tiết một bài đăng theo ID
  // ============================================================

  /// Phương thức [fetchPostById]: Lấy thông tin chi tiết của một post.
  ///
  /// [id]: ID của bài đăng cần lấy
  Future<Post> fetchPostById(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id');

    try {
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        // Decode JSON thành Map<String, dynamic>
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        // Chuyển đổi Map thành đối tượng Post
        return Post.fromJson(jsonMap);
      } else {
        throw Exception(
          'Không tìm thấy bài đăng với ID: $id (HTTP ${response.statusCode})',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================
  // OPTIONAL – LAB 8 BONUS: POST Request — Tạo bài đăng mới
  // ============================================================

  /// Phương thức [createPost]: Gửi POST request để tạo mới một bài đăng.
  ///
  /// [title]: Tiêu đề bài đăng mới
  /// [body]: Nội dung bài đăng mới
  /// [userId]: ID người dùng tạo bài đăng (mặc định là 1)
  ///
  /// Trả về đối tượng [Post] mới được tạo (từ response JSON của server).
  Future<Post> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts');

    try {
      // Gửi POST request với:
      // - headers: khai báo Content-Type là JSON
      // - body: JSON string của dữ liệu cần tạo
      final response = await _client.post(
        uri,
        headers: {
          // Khai báo Content-Type để server biết format dữ liệu gửi lên
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // Chuyển Map thành JSON string bằng json.encode()
        body: json.encode({
          'title': title,
          'body': body,
          'userId': userId,
        }),
      );

      // Status 201 = Created (tạo thành công)
      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return Post.fromJson(jsonMap);
      } else {
        throw Exception(
          'Không thể tạo bài đăng mới (HTTP ${response.statusCode})',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Phương thức [dispose]: Giải phóng tài nguyên của HTTP client
  /// Nên gọi khi không cần dùng ApiService nữa
  void dispose() {
    _client.close();
  }
}
