import 'package:flutter/material.dart';
import 'package:flutter_tasks/home_page.dart';
import 'package:flutter_tasks/todo_detail_page.dart';

// 눈에 보여지는 Todo 구성
class TodoView extends StatelessWidget {
  final TodoEntity todo;
  final VoidCallback onToggleDone;
  final VoidCallback onToggleFavorite;
  const TodoView({
    required this.todo,
    required this.onToggleDone,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggleDone,
              child: Icon(
                todo.isDone ? Icons.check_circle : Icons.circle,
                color: todo.isDone
                    ? (isDarkMode ? Colors.grey[400] : Colors.grey[600])
                    : (isDarkMode ? Colors.grey[600] : Colors.grey[400]),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            SizedBox(width: 12),
            GestureDetector(
              onTap: onToggleFavorite,
              child: Icon(
                todo.isFavorite ? Icons.star : Icons.star_border,
                color: todo.isFavorite
                    ? Colors.amber
                    : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Todo가 없을때의 위젯
// 사용자 이름 받아옴
class NoTodo extends StatelessWidget {
  final String userName;
  NoTodo({required this.userName});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                Icons.check_circle,
                size: 100,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[300]
                    : Colors.black,
              ),
              SizedBox(height: 12),
              Text(
                '아직 할 일이 없음',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "할 일을 추가하고 $userName's Tasks에서\n할 일을 추적하세요",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Todo가 있을 때 기능이 구현된 위젯
class YesTodo extends StatelessWidget {
  final List<TodoEntity> todos;
  final Function(int) onToggleDone;
  final Function(int) onToggleFavorite;

  YesTodo({
    required this.todos,
    required this.onToggleDone,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return GestureDetector(
          onTap: () async {
            final result = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) => TodoDetailPage(
                  todo: todo,
                  onFavoriteChanged: (fav) {
                    Navigator.of(context).pop(fav);
                  },
                ),
              ),
            );
            if (result != null && result != todo.isFavorite) {
              onToggleFavorite(index);
            }
          },
          child: TodoView(
            todo: todo,
            onToggleDone: () => onToggleDone(index),
            onToggleFavorite: () => onToggleFavorite(index),
          ),
        );
      },
    );
  }
}

// Todo 추가 버튼
class AddButton extends StatelessWidget {
  final Function(TodoEntity) onAddTodo;
  AddButton({required this.onAddTodo});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await addTodo(context);
        if (result != null) {
          onAddTodo(result);
        }
      },
      backgroundColor: Colors.red,
      shape: CircleBorder(),
      child: Icon(Icons.add, color: Colors.white, size: 24),
    );
  }
}

// 바텀시트 위젯
class ShowBottomSheet extends StatefulWidget {
  @override
  State<ShowBottomSheet> createState() => _ShowBottomSheetState();
}

class _ShowBottomSheetState extends State<ShowBottomSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final FocusNode titleFocus = FocusNode();
  bool showDesc = false;
  bool isFavorite = false;

  void saveTodo() {
    if (titleController.text.trim().isNotEmpty) {
      Navigator.of(context).pop({
        'title': titleController.text.trim(),
        'description': descController.text.trim(),
        'isFavorite': isFavorite,
      });
    }
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('할 일을 입력해주세요', style: TextStyle(color: Colors.white)),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 30,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            focusNode: titleFocus,
            autofocus: true,
            decoration: InputDecoration(
              hintText: '새 할 일',
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[600]!
                      : Colors.grey[400]!,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]!
                      : Colors.grey[600]!,
                  width: 2,
                ),
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => saveTodo(),
            onChanged: (_) => setState(() {}),
          ),
          if (showDesc)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: SizedBox(
                height: 80,
                child: TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    hintText: '세부정보 추가',
                    hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[600]!
                            : Colors.grey[400]!,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]!
                            : Colors.grey[600]!,
                        width: 2,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  maxLines: null,
                ),
              ),
            ),
          SizedBox(height: 12),
          Row(
            children: [
              if (!showDesc)
                IconButton(
                  icon: Icon(
                    Icons.short_text_rounded,
                    size: 24,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                  onPressed: () => setState(() => showDesc = true),
                ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  size: 24,
                  color: isFavorite
                      ? Colors.amber
                      : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54),
                ),
                onPressed: () => setState(() => isFavorite = !isFavorite),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: titleController.text.trim().isNotEmpty
                    ? saveTodo
                    : showSnackBar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text('저장', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
