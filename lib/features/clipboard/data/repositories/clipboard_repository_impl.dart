import 'package:clipboard_app/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clipboard_app/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ClipboardRepository)
class ClipboardRepositoryImpl implements ClipboardRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  CollectionReference<Map<String, dynamic>> get _clips => _db.collection('clips');

  @override
  Future<List<ClipboardItem>> getHistory() async {
    final snapshot = await _clips.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map(_docToItem).toList();
  }

  @override
  Stream<List<ClipboardItem>> getHistoryStream() {
    return _clips
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_docToItem).toList());
  }

  @override
  Future<void> addItem(String text) async {
    await _clips.add({
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteItem(String id) async {
    await _clips.doc(id).delete();
  }

  ClipboardItem _docToItem(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ClipboardItem(
      id: doc.id,
      text: data['text'] as String,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
