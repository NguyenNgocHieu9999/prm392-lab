import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task_item.dart';
import '../models/product.dart';

class StorageService {
  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // File names
  static const String _tasksFileName = 'tasks.json';
  static const String _productsFileName = 'products.json';

  // Helper to get directory path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get file references
  Future<File> get _tasksFile async {
    final path = await _localPath;
    return File('$path/$_tasksFileName');
  }

  Future<File> get _productsFile async {
    final path = await _localPath;
    return File('$path/$_productsFileName');
  }

  // Tasks (Lab 9.2) - Read
  Future<List<TaskItem>> readTasks() async {
    try {
      final file = await _tasksFile;
      if (!await file.exists()) {
        // Create file with initial default data
        final defaultTasks = _getDefaultTasks();
        await writeTasks(defaultTasks);
        return defaultTasks;
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => TaskItem.fromJson(json)).toList();
    } catch (e) {
      print('Error reading tasks: $e');
      return _getDefaultTasks();
    }
  }

  // Tasks (Lab 9.2) - Write
  Future<File> writeTasks(List<TaskItem> tasks) async {
    final file = await _tasksFile;
    final jsonString = jsonEncode(tasks.map((t) => t.toJson()).toList());
    return await file.writeAsString(jsonString);
  }

  // Products (Lab 9.3) - Read
  Future<List<Product>> readProducts() async {
    try {
      final file = await _productsFile;
      if (!await file.exists()) {
        // Create file with initial default data
        final defaultProducts = _getDefaultProducts();
        await writeProducts(defaultProducts);
        return defaultProducts;
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error reading products: $e');
      return _getDefaultProducts();
    }
  }

  // Products (Lab 9.3) - Write
  Future<File> writeProducts(List<Product> products) async {
    final file = await _productsFile;
    final jsonString = jsonEncode(products.map((p) => p.toJson()).toList());
    return await file.writeAsString(jsonString);
  }

  // Default Mock Data for Tasks
  List<TaskItem> _getDefaultTasks() {
    return [
      TaskItem(
        id: 't_1',
        title: 'Learn Flutter Basics',
        content: 'Understand Widgets, Stateless vs Stateful, and simple layouts.',
        dueDate: '2026-06-25',
        priority: 'High',
      ),
      TaskItem(
        id: 't_2',
        title: 'Complete Lab 9 Project',
        content: 'Code Local Storage with assets and JSON reading/writing.',
        dueDate: '2026-06-26',
        priority: 'High',
      ),
      TaskItem(
        id: 't_3',
        title: 'Review Flutter State Management',
        content: 'Understand Provider, Riverpod, or simple InheritedWidgets.',
        dueDate: '2026-06-30',
        priority: 'Medium',
      ),
      TaskItem(
        id: 't_4',
        title: 'Buy Groceries',
        content: 'Purchase milk, bread, eggs, and fruits for the week.',
        dueDate: '2026-06-27',
        priority: 'Low',
      ),
    ];
  }

  // Default Mock Data for Products
  List<Product> _getDefaultProducts() {
    return [
      Product(
        id: '1',
        name: 'iPhone 15 Pro Max',
        category: 'Electronics',
        price: 1199.99,
        stock: 24,
        description: 'Flagship Apple smartphone with Titanium frame, 3nm A17 Pro chip, and advanced cameras.',
      ),
      Product(
        id: '2',
        name: 'MacBook Air M3',
        category: 'Electronics',
        price: 1099.00,
        stock: 12,
        description: 'Supercharged thin and light Apple laptop with powerful 8-core CPU and up to 10-core GPU.',
      ),
      Product(
        id: '3',
        name: 'Sony WH-1000XM5',
        category: 'Audio',
        price: 348.00,
        stock: 5,
        description: 'Premium wireless industry-leading noise canceling over-ear headphones.',
      ),
      Product(
        id: '4',
        name: 'Logitech MX Master 3S',
        category: 'Accessories',
        price: 99.99,
        stock: 45,
        description: 'Ergonomic performance wireless mouse with 8K DPI tracking and ultra-quiet clicks.',
      ),
      Product(
        id: '5',
        name: 'Keychron K2 V2',
        category: 'Accessories',
        price: 89.00,
        stock: 15,
        description: 'Hot-swappable tactile wireless mechanical keyboard with RGB backlight and aluminum frame.',
      ),
    ];
  }
}
