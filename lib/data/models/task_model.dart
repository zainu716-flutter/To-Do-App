import 'dart:convert';

class Task {
  String id;
  String title;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Convert from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
       isCompleted: map['isCompleted'] ?? false,
    );
  }

  // Encode to JSON string
  static String encode(List<Task> tasks) =>
      json.encode(tasks.map((t) => t.toMap()).toList());

  // Decode from JSON string
  static List<Task> decode(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<Task>((item) => Task.fromMap(item))
          .toList();
}