import 'package:clipboard_app/features/clipboard/domain/entities/clipboard_item.dart';

abstract class ClipboardRepository {
  Future<List<ClipboardItem>> getHistory();
  Future<void> addItem(String text);
  Future<void> deleteItem(String id);
}
