import 'package:clipboard_app/features/auth/domain/entities/auth_user.dart';
import 'package:clipboard_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clipboard_app/features/tasks/domain/entities/task.dart';
import 'package:clipboard_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:clipboard_app/injectable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) => getIt<TaskRepository>());

final tasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final authState = ref.watch(authProvider);
  final repository = ref.watch(taskRepositoryProvider);
  
  if (authState == null) return Stream.value([]);
  
  if (authState.role == UserRole.coordinator) {
    return repository.getAllTasks();
  } else {
    return repository.getTasks(authState.id);
  }
});

final taskStatsProvider = Provider<Map<String, int>>((ref) {
  final tasksAsync = ref.watch(tasksStreamProvider);
  
  return tasksAsync.when(
    data: (tasks) {
      final total = tasks.length;
      final pending = tasks.where((t) => t.status == TaskStatus.pending).length;
      final completed = tasks.where((t) => t.status == TaskStatus.completed).length;
      final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).length;
      
      return {
        'total': total,
        'pending': pending,
        'completed': completed,
        'inProgress': inProgress,
      };
    },
    loading: () => {'total': 0, 'pending': 0, 'completed': 0, 'inProgress': 0},
    error: (e, s) => {'total': 0, 'pending': 0, 'completed': 0, 'inProgress': 0},
  );
});
