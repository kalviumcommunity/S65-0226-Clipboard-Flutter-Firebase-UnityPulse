import 'package:clipboard_app/features/auth/presentation/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VolunteersPage extends ConsumerWidget {
  const VolunteersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volunteersAsync = ref.watch(volunteersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(title: const Text('Our Volunteers'), backgroundColor: Colors.transparent),
      body: volunteersAsync.when(
        data: (volunteers) {
          if (volunteers.isEmpty) {
            return const Center(child: Text('No volunteers found.', style: TextStyle(color: Colors.white70)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: volunteers.length,
            itemBuilder: (context, index) {
              final volunteer = volunteers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFFDBB2D).withValues(alpha: 0.2),
                      child: Text(volunteer.name[0], style: const TextStyle(color: Color(0xFFFDBB2D))),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(volunteer.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(volunteer.email, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}
