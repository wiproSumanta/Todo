
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data_layer/my_todo.dart';
import 'package:todo_app/state/todo_state.dart';
import 'package:todo_app/todo_priority.dart';

import '../data_layer/todo_repository.dart';

class TodoViewModelCubit extends Cubit<TodoState>{
  final TodoRepository _repository;
  TodoViewModelCubit(this._repository):super(TodoInitial());

  Future<void> fetchTodos() async {
    emit(TodoLoading());
    print("fetchTodos()");

    try{
      var todos = await _repository.fetchTodos();
      print(todos?.length);
      emit(TodoLoaded(todos ?? []));

    } catch (e) {
      emit(TodoError("Failed to load todos."));
    }

  }

  Future<void> fetchTodosByPriority(TodoPriority priority) async {
    emit(TodoLoading());
    try{
      var todos = await _repository.fetchTodos();
      print(todos?.length);
      var filterTodos = todos?.where((todo) => todo.priority == priority).toList();
      emit(TodoLoaded(filterTodos ?? []));

    } catch (e) {
      emit(TodoError("Failed to load todos."));
    }
  }

  Future<void> addTodos(MyTodo todo) async {
    print(todo.id);

    var rowEfect = await _repository.insertTodo(todo);
    print("Hi $rowEfect");
    await fetchTodos();
  }

  Future<void> updateTodos(MyTodo todo) async {
    var rowEffect = await _repository.updateTodo(todo);
    print("Hi $rowEffect");
    await fetchTodos();
  }

  Future<void> toggleCompletion(MyTodo todo) async {
    final updatedTodo = MyTodo(id: todo.id, name: todo.name, priority: todo.priority, completed: !todo.completed);
    await updateTodos(updatedTodo);
  }

}