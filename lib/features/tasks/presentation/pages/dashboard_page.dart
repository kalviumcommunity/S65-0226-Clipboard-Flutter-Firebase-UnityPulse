import 'dart:async';

import 'package:clipboard_app/features/auth/domain/entities/auth_user.dart';
import 'package:clipboard_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clipboard_app/features/tasks/domain/entities/task.dart';
import 'package:clipboard_app/features/tasks/presentation/providers/task_providers.dart';
import 'package:clipboard_app/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final tasksAsync = ref.watch(tasksStreamProvider);
    final isCoordinator = authState?.role == UserRole.coordinator;
    
    // For filtering (Volunteer only)
    final filterTabController = useTabController(initialLength: 4);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Text(isCoordinator ? 'Global Management' : 'My Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: !isCoordinator 
          ? TabBar(
              controller: filterTabController,
              isScrollable: true,
              indicatorColor: const Color(0xFF00D2FF),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Pending'),
                Tab(text: 'In Progress'),
                Tab(text: 'Completed'),
              ],
            )
          : null,
      ),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks found.', style: TextStyle(color: Colors.white70)));
          }

          if (isCoordinator) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  isCoordinator: true,
                  onDelete: () => _confirmDelete(context, ref, task),
                  onTap: () {}, // Navigate to details
                );
              },
            );
          } else {
            return TabBarView(
              controller: filterTabController,
              children: [
                _buildTaskList(tasks, null, ref, false), // All
                _buildTaskList(tasks, TaskStatus.pending, ref, false),
                _buildTaskList(tasks, TaskStatus.inProgress, ref, false),
                _buildTaskList(tasks, TaskStatus.completed, ref, false),
              ],
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, TaskStatus? filter, WidgetRef ref, bool isCoordinator) {
    final filteredTasks = filter == null 
        ? tasks 
        : tasks.where((t) => t.status == filter).toList();

    return filteredTasks.isEmpty 
      ? const Center(child: Text('Empty list.', style: TextStyle(color: Colors.white60)))
      : ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return TaskCard(
              task: task,
              isCoordinator: isCoordinator,
              onStatusChange: () => _updateStatusPopup(context, ref, task),
            );
          },
        );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Task task) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('Delete Task', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete "${task.title}"?', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              unawaited(ref.read(taskRepositoryProvider).deleteTask(task.id));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFE94560))),
          ),
        ],
      ),
    ));
  }

  void _updateStatusPopup(BuildContext context, WidgetRef ref, Task task) {
    unawaited(showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF16213E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Update Task Status', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...TaskStatus.values.map((status) => ListTile(
              title: Text(status.name.toUpperCase(), style: const TextStyle(color: Colors.white)),
              onTap: () {
                unawaited(ref.read(taskRepositoryProvider).updateTaskStatus(task.id, status));
                Navigator.pop(context);
              },
              trailing: task.status == status ? const Icon(Icons.check_circle, color: Color(0xFF00D2FF)) : null,
            )),
          ],
        ),
      ),
    ));
  }
}
