import 'package:flutter/material.dart';
import 'package:flutter_tasks/widget.dart';

class Todo {
  final String title;
  final String? description;
  final bool isFavorite;
  final bool isDone;

  Todo({
    required this.title,
    this.description,
    this.isFavorite = false,
    this.isDone = false,
  });
}

class HomePage extends StatefulWidget {
  final String userName;
  HomePage({required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.userName}'s Tasks",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: todos.isEmpty
          ? NoTodo(userName: widget.userName)
          : YesTodo(
              todos: todos,
              onToggleDone: (index) {
                setState(() {
                  final todo = todos[index];
                  todos[index] = Todo(
                    title: todo.title,
                    description: todo.description,
                    isFavorite: todo.isFavorite,
                    isDone: !todo.isDone,
                  );
                });
              },
              onToggleFavorite: (index) {
                setState(() {
                  final todo = todos[index];
                  todos[index] = Todo(
                    title: todo.title,
                    description: todo.description,
                    isFavorite: !todo.isFavorite,
                    isDone: todo.isDone,
                  );
                });
              },
            ),
      floatingActionButton: AddButton(
        onAddTodo: (todo) {
          setState(() {
            todos.add(todo);
          });
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

Future<Todo?> addTodo(BuildContext context) async {
  final result = await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return TaskBottomSheet();
    },
  );
  Future.delayed(const Duration(), () {
    FocusScope.of(context).requestFocus(FocusNode());
  });
  if (result == null) return null;
  return Todo(
    title: result['title'] ?? '',
    description: result['description'],
    isFavorite: result['isFavorite'] ?? false,
    isDone: result['isDone'] ?? false,
  );
}
