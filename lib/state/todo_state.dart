import '../data_layer/my_todo.dart';

abstract class TodoState{
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState{}

class TodoLoading extends TodoState{}

class TodoLoaded extends TodoState {
  final List<MyTodo> todos;

  TodoLoaded(this.todos);

  @override
  // TODO: implement hashCode
  List<Object?> get props => [todos];
}

class TodoError extends TodoState{
  final String message;

  TodoError(this.message);

  @override
  List<Object?> get props => [message];
}