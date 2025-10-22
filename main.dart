import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(Tasks());
}

class Tasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[300],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[800],
        appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900]),
      ),
      themeMode: ThemeMode.light,
      home: HomePage(userName: '장수'),
    );
  }
}
