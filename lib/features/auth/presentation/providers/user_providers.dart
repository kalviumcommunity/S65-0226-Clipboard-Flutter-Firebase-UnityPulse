import 'package:clipboard_app/features/auth/domain/entities/auth_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final volunteersProvider = StreamProvider<List<AuthUser>>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'volunteer')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return AuthUser(
              id: doc.id,
              email: (data['email'] as String?) ?? '',
              name: (data['name'] as String?) ?? 'Unknown',
              role: UserRole.volunteer,
            );
          }).toList());
});
