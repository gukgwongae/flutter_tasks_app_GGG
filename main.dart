import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(Tasks());
}

// 시스템에 맞게 라이트,다크 테마 적용
// HomePage(userName: '') 로 사용자 이름 설정
// 커스텀 테마를 전체적으로 적용하고 싶었지만 다음 과제에서 진행해볼 예정
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
      themeMode: ThemeMode.system,
      home: HomePage(userName: '장수'),
    );
  }
}
