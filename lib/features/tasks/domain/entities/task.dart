import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('inProgress')
  inProgress,
  @JsonValue('completed')
  completed,
}

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required String description,
    required String coordinatorId,
    required String? volunteerId,
    required String? volunteerName,
    required TaskStatus status,
    required DateTime deadline,
    required DateTime createdAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
