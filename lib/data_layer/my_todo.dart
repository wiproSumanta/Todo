import '../todo_priority.dart';

class MyTodo{
  int id;
  String name;
  TodoPriority priority;
  bool completed;

  MyTodo({
    required this.id,
    required this.name,
    required this.priority,
    this.completed = false,
  });

  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'priority': priority.name,
      'completed': completed ? 1 : 0,
    };
  }

  factory MyTodo.fromMap(Map<String, dynamic> map) {
    return MyTodo(
      id: map['id'],
      name: map['name'],
      priority: TodoPriority.values.firstWhere((e) => e.name == map['priority']),
      completed: (map['completed'] as int) == 1,
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Todo{id: $id, name: $name, property: ${priority.name}, completed: $completed,}";
  }
}