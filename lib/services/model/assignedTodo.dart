// To parse this JSON data, do
//
//     final assignedTodo = assignedTodoFromJson(jsonString);

import 'dart:convert';

List<AssignedTodo> assignedTodoFromJson(str) => List<AssignedTodo>.from(str.map((x) => AssignedTodo.fromJson(x)));

String assignedTodoToJson(List<AssignedTodo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AssignedTodo {
  int? id;
  String? title;
  String? description;
  bool completed;
  String? assignedBy;

  AssignedTodo({
    this.id,
    this.title,
    this.description,
    required this.completed,
    this.assignedBy,
  });

  factory AssignedTodo.fromJson(Map<String, dynamic> json) => AssignedTodo(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    completed: json["completed"],
    assignedBy: json["assigned_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "completed": completed,
    "assigned_by": assignedBy,
  };
}
