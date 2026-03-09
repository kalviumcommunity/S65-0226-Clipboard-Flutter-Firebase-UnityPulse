import 'package:clipboard_app/features/auth/presentation/pages/profile_page.dart';
import 'package:clipboard_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:clipboard_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:clipboard_app/features/auth/presentation/pages/splash_page.dart';
import 'package:clipboard_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clipboard_app/features/settings/presentation/pages/settings_page.dart';
import 'package:clipboard_app/features/tasks/domain/entities/task.dart';
import 'package:clipboard_app/features/tasks/presentation/pages/create_task_page.dart';
import 'package:clipboard_app/features/tasks/presentation/pages/dashboard_page.dart';
import 'package:clipboard_app/features/tasks/presentation/pages/home_page.dart';
import 'package:clipboard_app/features/tasks/presentation/pages/task_details_page.dart';
import 'package:clipboard_app/features/tasks/presentation/pages/volunteers_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isSplash = state.uri.toString() == '/splash';
      final isAuthPage = state.uri.toString() == '/signin' ||
          state.uri.toString() == '/signup';

      if (isSplash) return null;

      if (!isLoggedIn && !isAuthPage) {
        return '/signin';
      }
      if (isLoggedIn && isAuthPage) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/tasks/create',
        builder: (context, state) => const CreateTaskPage(),
      ),
      GoRoute(
        path: '/tasks/details',
        builder: (context, state) {
          final task = state.extra as Task?;
          if (task == null) {
            return const Scaffold(
              body: Center(child: Text('Task not found')),
            );
          }
          return TaskDetailsPage(task: task);
        },
      ),
      GoRoute(
        path: '/volunteers',
        builder: (context, state) => const VolunteersPage(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpPage(),
      ),
    ],
  );
});
