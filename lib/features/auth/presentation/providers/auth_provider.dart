import 'package:clipboard_app/features/auth/domain/entities/auth_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  AuthUser? build() {
    // Listen to auth state changes to keep Riverpod state in sync
    final subscription = _auth.authStateChanges().listen((user) {
      if (user == null) {
        state = null;
      } else {
        _syncUserRole(user).ignore();
      }
    });

    ref.onDispose(subscription.cancel);

    return null;
  }

  Future<void> _syncUserRole(User user) async {
    // Basic Firestore role check (default to volunteer if doc doesn't exist)
    final doc = await _db.collection('users').doc(user.uid).get();
    final role = doc.exists && doc.data()?['role'] == 'coordinator'
        ? UserRole.coordinator
        : UserRole.volunteer;

    state = AuthUser(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'New User',
      role: role,
      photoUrl: user.photoURL,
    );
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String name, String email, String password, UserRole role) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      // Update display name
      await credential.user!.updateDisplayName(name);

      // Store role in Firestore
      await _db.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'role': role.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
