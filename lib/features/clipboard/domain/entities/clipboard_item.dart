import 'package:freezed_annotation/freezed_annotation.dart';

part 'clipboard_item.freezed.dart';
part 'clipboard_item.g.dart';

@freezed
abstract class ClipboardItem with _$ClipboardItem {
  const factory ClipboardItem({
    required String id,
    required String text,
    required DateTime createdAt,
  }) = _ClipboardItem;

  factory ClipboardItem.fromJson(Map<String, dynamic> json) =>
      _$ClipboardItemFromJson(json);
}
