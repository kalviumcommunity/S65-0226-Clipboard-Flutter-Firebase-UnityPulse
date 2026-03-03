import 'package:clipboard_app/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clipboard_app/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:clipboard_app/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clipboard_provider.g.dart';

@riverpod
class ClipboardNotifier extends _$ClipboardNotifier {
  ClipboardRepository get _repository => getIt<ClipboardRepository>();

  @override
  Future<List<ClipboardItem>> build() async {
    return _repository.getHistory();
  }

  Future<void> add(String text) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.addItem(text);
      return _repository.getHistory();
    });
  }

  Future<void> remove(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteItem(id);
      return _repository.getHistory();
    });
  }
}
