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

                // Card with a shadow effect for a modern look
                return Card(
                  color: todo.completed ? Colors.green[50] : Colors.red[50],
                  elevation: 4,  // Shadow effect for better separation
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),  // Rounded corners for the card
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),  // Add padding inside the tile
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User ID: ${todo.userId}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],  // Subtle gray color
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),  // Add spacing between the user ID and the title
                        Text(
                          todo.title,
                          style: TextStyle(
                            fontSize: 18,
                            color: todo.completed ? Colors.green[800] : Colors.red[800],
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      todo.completed ? Icons.check_circle : Icons.cancel,
                      color: todo.completed ? Colors.green[600] : Colors.red[600],
                      size: 28,  // Icon size for better visibility
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
