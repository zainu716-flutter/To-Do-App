import 'package:flutter/material.dart';
import 'package:flutter_application_2/providers/theme_provider.dart';
import 'package:flutter_application_2/widgets/section_header.dart';
import 'package:flutter_application_2/widgets/task_input.dart';
import 'package:flutter_application_2/widgets/task_item.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TaskInput(),
            const SizedBox(height: 20),

            // ✅ FIXED: Single ListView
            Expanded(
              child: ListView(
                children: [
                  // 🔹 Pending Section
                  const SectionHeader(title: "Pending Tasks"),

                  ...provider.pendingTasks.map(
                    (task) => TaskItem(task: task),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Completed Section
                  const SectionHeader(title: "Completed Tasks"),

                  ...provider.completedTasks.map(
                    (task) => TaskItem(task: task),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔘 Action Buttons
            Row(
              children: [
                // 🔴 Delete All
                Expanded(
                  child: ElevatedButton(
                    onPressed: provider.deleteAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Delete All",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ⚪ Clear Completed
                Expanded(
                  child: OutlinedButton(
                    onPressed: provider.clearCompleted,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.blue.shade300),
                    ),
                    child: const Text(
                      "Clear Completed",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}