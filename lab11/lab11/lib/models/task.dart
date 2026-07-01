class Task {
  Task({required this.title, this.completed = false, String? id})
    : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  final String id;
  final String title;
  final bool completed;

  Task toggle() {
    return copyWith(completed: !completed);
  }

  Task copyWith({String? id, String? title, bool? completed}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
