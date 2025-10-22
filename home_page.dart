import 'package:flutter/material.dart';
import 'package:flutter_tasks/widget.dart' as custom;
import 'package:flutter_tasks/widget.dart';

// TodoEntity 클래스
class TodoEntity {
  final String title;
  final String? description;
  final bool isFavorite;
  final bool isDone;

  TodoEntity({
    required this.title,
    this.description,
    this.isFavorite = false,
    this.isDone = false,
  });
}

// HomePage 클래스
// 사용자 이름을 받아옴
class HomePage extends StatefulWidget {
  final String userName;
  HomePage({required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoEntity> todos = [];

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
                  todos[index] = TodoEntity(
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
                  todos[index] = TodoEntity(
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
          if (todo is TodoEntity) {
            setState(() {
              todos.add(todo);
            });
          }
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

// ToDo 추가 버튼
Future<TodoEntity?> addTodo(BuildContext context) async {
  final result = await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return custom.BottomSheet();
    },
  );
  Future.delayed(const Duration(), () {
    FocusScope.of(context).requestFocus(FocusNode());
  });
  if (result == null) return null;
  return TodoEntity(
    title: result['title'] ?? '',
    description: result['description'],
    isFavorite: result['isFavorite'] ?? false,
    isDone: result['isDone'] ?? false,
  );
}
