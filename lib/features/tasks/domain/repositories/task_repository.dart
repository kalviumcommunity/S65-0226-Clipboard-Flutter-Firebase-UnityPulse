import 'package:clipboard_app/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> getTasks(String? volunteerId);
  Stream<List<Task>> getAllTasks();
  Future<void> createTask(Task task);
  Future<void> updateTaskStatus(String taskId, TaskStatus status);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}
