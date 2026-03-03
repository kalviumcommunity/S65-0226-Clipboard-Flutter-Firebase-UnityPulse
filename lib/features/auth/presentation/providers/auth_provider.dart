import 'package:clipboard_app/features/auth/domain/entities/auth_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthUser? build() {
    return null;
  }

  Future<void> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    
    // Simulate role logic based on email
    final role = email.toLowerCase().contains('coord') 
        ? UserRole.coordinator 
        : UserRole.volunteer;

    state = AuthUser(
      id: 'uuid-1234',
      email: email,
      name: role == UserRole.coordinator ? 'Head Coordinator' : 'Volunteer Assistant',
      role: role,
    );
  }

  Future<void> signUp(String name, String email, String password, UserRole role) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    
    state = AuthUser(
      id: 'uuid-1234',
      email: email,
      name: name,
      role: role,
    );
  }

  void signOut() {
    state = null;
  }
}
