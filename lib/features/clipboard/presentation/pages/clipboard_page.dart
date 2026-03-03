import 'package:clipboard_app/features/auth/domain/entities/auth_user.dart';
import 'package:clipboard_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clipboard_app/features/clipboard/presentation/providers/clipboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClipboardPage extends ConsumerWidget {
  const ClipboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(clipboardProvider);
    final user = ref.watch(authProvider);
    final isCoordinator = user?.role == UserRole.coordinator;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Clipboard History'),
            if (user != null)
              Text(
                '${user.name} (${user.role.name.toUpperCase()})',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(authProvider.notifier).signOut(),
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () => ref.refresh(clipboardProvider),
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: historyAsync.when(
        data: (history) => history.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_toggle_off,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No history yet',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(item.text),
                      subtitle: Text(
                        item.createdAt.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: isCoordinator
                          ? IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Color(0xFFE94560),
                              ),
                              onPressed: () => ref
                                  .read(clipboardProvider.notifier)
                                  .remove(item.id),
                            )
                          : null,
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: isCoordinator
          ? FloatingActionButton(
              onPressed: () => _showAddDialog(context, ref),
              backgroundColor: const Color(0xFFE94560),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Clipboard'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter text here'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await ref.read(clipboardProvider.notifier).add(controller.text);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
