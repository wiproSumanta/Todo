
import 'package:flutter/material.dart';
import 'package:todo_app/data_layer/database_helper.dart';
import 'package:todo_app/data_layer/my_todo.dart';

class TodoRepository{
  DatabaseHelper? _dbHelper = DatabaseHelper.instance;

  TodoRepository() {
    WidgetsFlutterBinding.ensureInitialized();
    DatabaseHelper.instance.db;
  }

  Future<int>? insertTodo(MyTodo todo) => _dbHelper?.insertTodo(todo);

  Future<List<MyTodo>>? fetchTodos() => _dbHelper?.fetchTodos();

  Future<int>? updateTodo(MyTodo todo) => _dbHelper?.updateTodo(todo);
}