import 'package:clipboard_app/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clipboard_app/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ClipboardRepository)
class ClipboardRepositoryImpl implements ClipboardRepository {
  // Simulating local storage or API
  final List<ClipboardItem> _history = [];

  @override
  Future<List<ClipboardItem>> getHistory() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _history;
  }

  @override
  Future<void> addItem(String text) async {
    _history.add(
      ClipboardItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> deleteItem(String id) async {
    _history.removeWhere((item) => item.id == id);
  }
}
