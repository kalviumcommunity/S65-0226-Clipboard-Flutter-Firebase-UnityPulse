import 'dart:async';

import 'package:clipboard_app/features/auth/domain/entities/auth_user.dart';
import 'package:clipboard_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clipboard_app/features/tasks/domain/entities/task.dart';
import 'package:clipboard_app/features/tasks/presentation/providers/task_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskDetailsPage extends ConsumerWidget {
  const TaskDetailsPage({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isCoordinator = authState?.role == UserRole.coordinator;
    final statusColor = _getStatusColor(task.status);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            _buildStatusBadge(task.status, statusColor),
            const SizedBox(height: 16),

            // Title
            Text(
              task.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Info Grid
            _buildInfoTile(
              'Description',
              task.description,
              Icons.description_rounded,
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    'Deadline',
                    _formatDate(task.deadline),
                    Icons.calendar_today_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoTile(
                    'Created At',
                    _formatDate(task.createdAt),
                    Icons.history_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildInfoTile(
              'Assigned Volunteer',
              task.volunteerName ?? 'Unassigned',
              Icons.person_rounded,
            ),
            const SizedBox(height: 40),

            // Actions
            if (isCoordinator)
              _buildCoordinatorActions(context, ref)
            else
              _buildVolunteerActions(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF00D2FF)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinatorActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO(UnityPulse): Implement Edit functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit coming soon...')),
              );
            },
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Edit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D2FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _confirmDelete(context, ref),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE94560).withValues(alpha: 0.2),
              foregroundColor: const Color(0xFFE94560),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE94560)),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVolunteerActions(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _updateStatusPopup(context, ref),
        icon: const Icon(Icons.sync_rounded),
        label: const Text('Update Status'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D2FF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('Delete Task', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete "${task.title}"?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              unawaited(ref.read(taskRepositoryProvider).deleteTask(task.id));
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to list
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFE94560))),
          ),
        ],
      ),
    ));
  }

  void _updateStatusPopup(BuildContext context, WidgetRef ref) {
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
            const Text('Update Task Status',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...TaskStatus.values.map((status) => ListTile(
                  title: Text(status.name.toUpperCase(), style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    unawaited(ref.read(taskRepositoryProvider).updateTaskStatus(task.id, status));
                    Navigator.pop(context); // Close sheet
                    Navigator.pop(context); // Go back to Home/Dashboard to see update
                    // Actually, since it's a stream, staying might be okay, but user requested update status action.
                  },
                  trailing: task.status == status
                      ? const Icon(Icons.check_circle, color: Color(0xFF00D2FF))
                      : null,
                )),
          ],
        ),
      ),
    ));
  }

  Widget _buildStatusBadge(TaskStatus status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const Color(0xFFFDBB2D);
      case TaskStatus.inProgress:
        return const Color(0xFF00D2FF);
      case TaskStatus.completed:
        return const Color(0xFF22C55E);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
