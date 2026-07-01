class TaskItem {
  final String id;
  final String title;
  final String content;
  final String dueDate;
  final String priority; // High, Medium, Low

  TaskItem({
    required this.id,
    required this.title,
    required this.content,
    required this.dueDate,
    required this.priority,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      dueDate: json['dueDate']?.toString() ?? '',
      priority: json['priority']?.toString() ?? 'Medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dueDate': dueDate,
      'priority': priority,
    };
  }

  TaskItem copyWith({
    String? id,
    String? title,
    String? content,
    String? dueDate,
    String? priority,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}
