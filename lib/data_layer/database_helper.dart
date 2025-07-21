
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data_layer/my_todo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  // static Database? _database;
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todos.db');
    print("initDb()");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo (
        id INTEGER PRIMARY KEY,
        name TEXT,
        priority TEXT,
        completed INTEGER NOT NULL
      )
    ''');
  }

  Future<List<MyTodo>> fetchTodos() async {
    Database db = await instance.db;
    final List<Map<String, dynamic>> todoMaps = await db.query('todo');

    return List.generate(todoMaps.length, (i) {
      return MyTodo.fromMap(todoMaps[i]);
    });
  }

  Future<int> insertTodo(MyTodo todo) async {
    print("data: ${todo.toString()}");
    Database db = await instance.db;
    print(db.path);
    return await db.insert("todo", todo.toMap());
  }

  Future<int> updateTodo(MyTodo todo) async {
    Database db = await instance.db;
    return await db.update("todo", todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }
}