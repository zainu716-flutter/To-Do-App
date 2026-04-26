import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/task_model.dart';
import 'dart:math';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoaded = false;

  List<Task> get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  bool get isLoaded => _isLoaded;

  TaskProvider() {
    loadTasks();
  }

  
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('tasks');

    if (data != null) {
      _tasks = Task.decode(data);
    }

    _isLoaded = true;
    notifyListeners();
  }

  
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', Task.encode(_tasks));
  }

  Future<void> _update() async {
    await saveTasks();
    notifyListeners();
  }

  
 Future<void> addTask(String title) async {
  if (title.trim().isEmpty) return;

  _tasks.add(Task(
    id: '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99999)}',
    title: title.trim(),
  ));

  await _update();
}

  
  Future<void> toggleTask(String id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;

    await _update();
  }

  
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);

    await _update();
  }

  
  Future<void> editTask(String id, String newTitle) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.title = newTitle.trim();

    await _update();
  }

  
  Future<void> deleteAll() async {
    _tasks.clear();

    await _update();
  }

  
  Future<void> clearCompleted() async {
    _tasks.removeWhere((task) => task.isCompleted);

    await _update();
  }
}