import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data_layer/my_todo.dart';
import 'package:todo_app/data_layer/todo_repository.dart';
import 'package:todo_app/state/todo_state.dart';
import 'package:todo_app/todo_priority.dart';
import 'package:todo_app/viewmodels/todo_view_mode_cubit.dart';

import 'my_todo_nav_drawer.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Flutter Todo App.",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange, primary: Colors.deepOrange, onSecondary: Colors.white),
        ),
        home: BlocProvider(
          create: (_) => TodoViewModelCubit(TodoRepository())..fetchTodos(),
          child: TodoHome(title: "Todo's",),

        ));
  }
}

class TodoHome extends StatefulWidget {
  final String title;
  TodoPriority? selectedItem;
  TodoHome({super.key, required this.title});

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  TodoPriority? selectedItem;
  final _controller = TextEditingController();
  TodoPriority priority = TodoPriority.Normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                context.read<TodoViewModelCubit>().fetchTodos();
              },
              icon: const Icon(Icons.sync)),
          PopupMenuButton<TodoPriority>(
            initialValue: selectedItem,
            onSelected: (TodoPriority item) {
              context.read<TodoViewModelCubit>().fetchTodosByPriority(item);
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<TodoPriority>>[
              const PopupMenuItem<TodoPriority>(
                  value: TodoPriority.Low, child: Text('Filter by Low')),
              const PopupMenuItem<TodoPriority>(
                  value: TodoPriority.Normal, child: Text('Filter by Normal')),
              const PopupMenuItem<TodoPriority>(
                  value: TodoPriority.High, child: Text('Filter by High')),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodo();
        },
        child: const Icon(Icons.add_task_sharp),
      ),
      drawer: NavDrawer(
        addCallBack: addTodo,
      ),
      body: BlocBuilder<TodoViewModelCubit, TodoState>(
        builder: (context, state){
          if(state is TodoLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if(state is TodoError){
            return Center(
              child: Text("Error: ${state.message}"),
            );
          } else if (state is TodoLoaded) {
            final incompleteTodos =
            state.todos.where((i) => !i.completed).toList();

            if (incompleteTodos.isEmpty) {
              return const Center(
                child: Text("Nothing to do... "),
              );
            }else{
              return ListView.builder(
                  itemCount: incompleteTodos.length,
                  itemBuilder: (context, index){
                    final todo = incompleteTodos[index];
                    return TodoItem(
                      todo: todo,
                      onChange: (value){
                        context.read<TodoViewModelCubit>().toggleCompletion(todo);
                      }
                    );
                  }
              );
            }

          }

          return const Center(
            child: Text("Ready to load todos..."),
          );
        },
      ),
    );
  }

  addTodo() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context)=>StatefulBuilder(builder: (context, setBuilderState){
      return Padding(padding: EdgeInsets.all(16.0),child: Column(children: [
        TextField(
          controller: _controller,
          decoration:
          const InputDecoration(hintText: "What to do?"),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Select Priority"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<TodoPriority>(
                value: TodoPriority.Low,
                groupValue: priority,
                onChanged: (value) {
                  setBuilderState(() {
                    priority = value!;
                  });
                }),
            Text(TodoPriority.Low.name),
            Radio<TodoPriority>(
                value: TodoPriority.Normal,
                groupValue: priority,
                onChanged: (value) {
                  setBuilderState(() {
                    priority = value!;
                  });
                }),
            Text(TodoPriority.Normal.name),
            Radio<TodoPriority>(
                value: TodoPriority.High,
                groupValue: priority,
                onChanged: (value) {
                  setBuilderState(() {
                    priority = value!;
                  });
                }),
            Text(TodoPriority.High.name),
          ],
        ),
        ElevatedButton(onPressed: _save, child: const Text("SAVE"))
      ],),);
    }));
  }

  void _save() {
    if (_controller.text.isEmpty) {
      // showMsg(context, "Input field must not be empty");
      print("Input field must not be empty");
      return;
    }

    final todoCubit = context.read<TodoViewModelCubit>();

    final todo = MyTodo(
        id: DateTime.now().microsecond,
        name: _controller.text,
        priority: priority
        );

    todoCubit.addTodos(todo);
    _controller.clear();
    Navigator.pop(context);

  }
}

class TodoItem extends StatelessWidget {
  final MyTodo todo;
  final Function(bool) onChange;
  const TodoItem({
    super.key,
    required this.todo,
    required this.onChange
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(todo.name),
        subtitle: Text("Priority: ${todo.priority.name}"),
        value: todo.completed,
        onChanged: (value) {
          onChange(value!);
        });
  }
}
