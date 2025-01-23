import 'package:dummy_sources/Todos/data_model.dart';
import 'package:dummy_sources/Todos/todoViewModel.dart';
import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});

  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TodoViewModel viewModel = TodoViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.todos = viewModel.getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                viewModel.filter = value;
                viewModel.selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
               PopupMenuItem<String>(
                value: 'All',
                child: Container(child: Text('All')),
              ),
               PopupMenuItem<String>(
                value: 'Finished',
                child: Text('Finished'),
              ),
              PopupMenuItem<String>(
                value: 'Unfinished',
                child: Text('Unfinished'),
              ),
            ],
            icon: Icon(Icons.filter_list),
            initialValue: viewModel.selectedFilter,
          ),
        ],
      ),
      body: FutureBuilder<List<Todo>>(
        future: viewModel.getFilteredTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Todos Available'));
          } else {
            List<Todo> todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index];
                return Card(
                  color: todo.completed ? Colors.green[100] : Colors.red[100],
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(todo.title),
                    subtitle: Text('User ID: ${todo.userId}'),
                    trailing: Icon(
                      todo.completed ? Icons.check_circle : Icons.cancel,
                      color: todo.completed ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
