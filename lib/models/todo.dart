import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo {
  int id;
  @JsonKey(defaultValue: '')
  String todo;
  @JsonKey(defaultValue: false)
  bool completed;

  Todo(this.id, this.todo, this.completed);

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

@JsonSerializable()
class TodoResponse {
  List<Todo> todos;

  TodoResponse(this.todos);

  factory TodoResponse.fromJson(Map<String, dynamic> json) => _$TodoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TodoResponseToJson(this);
}

@JsonSerializable()
class TodoStatus {
  bool completed;

  TodoStatus(this.completed);

  factory TodoStatus.fromJson(Map<String, dynamic> json) => _$TodoStatusFromJson(json);
  Map<String, dynamic> toJson() => _$TodoStatusToJson(this);
}
