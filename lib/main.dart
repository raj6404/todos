import 'package:dummy_sources/Todos/todoList.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Todos());
}

class Todos extends StatelessWidget {
  const Todos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoList(title: 'Todos'),
      debugShowCheckedModeBanner: false,
    );
  }
}
