import 'package:flutter/foundation.dart';

@immutable
class Task {
  const Task({required this.id, required this.title, this.isDone = false});

  final String id;
  final String title;
  final bool isDone;

  Task copyWith({String? id, String? title, bool? isDone}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
