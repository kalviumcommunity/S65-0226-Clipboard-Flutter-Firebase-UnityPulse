import 'package:clipboard_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:clipboard_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:clipboard_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clipboard_app/features/clipboard/presentation/pages/clipboard_page.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isAuthPage = state.uri.toString() == '/signin' ||
          state.uri.toString() == '/signup';

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
        path: '/',
        builder: (context, state) => const ClipboardPage(),
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
