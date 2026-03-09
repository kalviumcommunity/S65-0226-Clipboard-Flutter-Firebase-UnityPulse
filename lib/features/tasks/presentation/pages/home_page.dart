import 'package:clipboard_app/features/auth/domain/entities/auth_user.dart';
import 'package:clipboard_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clipboard_app/features/tasks/presentation/providers/task_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final stats = ref.watch(taskStatsProvider);

    if (authState == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/logo.png',
          height: 40,
          errorBuilder: (context, error, stackTrace) => const Text(
            'UnityPulse',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.account_circle_rounded, color: Colors.white70, size: 28),
          ),
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_rounded, color: Colors.white70),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Welcome,',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 16),
            ),
            Text(
              authState.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            // Stats Section
            const Text(
              'Your Progress',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard('Total', stats['total'].toString(), const Color(0xFF00D2FF)),
                const SizedBox(width: 12),
                _buildStatCard('Pending', stats['pending'].toString(), const Color(0xFFFDBB2D)),
                const SizedBox(width: 12),
                _buildStatCard('Done', stats['completed'].toString(), const Color(0xFF22C55E)),
              ],
            ),
            const SizedBox(height: 40),

            // Role-Based Section
            if (authState.role == UserRole.coordinator)
              _buildCoordinatorSections(context)
            else
              _buildVolunteerSections(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinatorSections(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Management',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          context,
          'Create Task',
          Icons.add_task_rounded,
          const Color(0xFFE94560),
          () => context.push('/tasks/create'),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'View All Tasks',
          Icons.dashboard_rounded,
          const Color(0xFF00D2FF),
          () => context.push('/dashboard'),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'View Volunteers',
          Icons.people_alt_rounded,
          const Color(0xFFFDBB2D),
          () => context.push('/volunteers'),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'My Profile',
          Icons.person_rounded,
          const Color(0xFF22C55E),
          () => context.push('/profile'),
        ),
      ],
    );
  }

  Widget _buildVolunteerSections(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Assigned Tasks',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.push('/dashboard'),
              child: const Text('View All', style: TextStyle(color: Color(0xFF00D2FF))),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Quick summary list or Filter tabs as requested
        const Text(
          'Quick Actions',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'Open Dashboard',
          Icons.view_list_rounded,
          const Color(0xFF22C55E),
          () => context.push('/dashboard'),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'My Profile',
          Icons.person_rounded,
          const Color(0xFF00D2FF),
          () => context.push('/profile'),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: color.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
