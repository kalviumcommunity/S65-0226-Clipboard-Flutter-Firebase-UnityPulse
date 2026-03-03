import 'package:clipboard_app/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clipboard_app/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:clipboard_app/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clipboard_provider.g.dart';

@riverpod
class ClipboardNotifier extends _$ClipboardNotifier {
  ClipboardRepository get _repository => getIt<ClipboardRepository>();

  @override
  Stream<List<ClipboardItem>> build() {
    return _repository.getHistoryStream();
  }

  Future<void> add(String text) async {
    // Note: We don't manually update state because 
    // Firestore's Stream will push the update automatically.
    await _repository.addItem(text);
  }

  Future<void> remove(String id) async {
    await _repository.deleteItem(id);
  }
}
