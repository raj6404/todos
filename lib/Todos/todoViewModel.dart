import 'dart:convert';
import 'package:dummy_sources/Todos/data_model.dart';
import 'package:http/http.dart' as http;

class TodoViewModel {

  late Future<List<Todo>> todos;
  String filter = 'All';
  String selectedFilter = 'All';

  // get Todos List
  Future<List<Todo>> getTodos() async {
    String _url = 'https://jsonplaceholder.typicode.com/todos';
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((e) => Todo.fromJson(e)).toList();
    } else {
      throw Exception('Failed to Load data');
    }
  }

  // get Filters
  Future<List<Todo>> getFilteredTodos() async {
    List<Todo> allTodos = await todos;
    if (filter == 'Finished') {
      return allTodos.where((todo) => todo.completed).toList();
    } else if (filter == 'Unfinished') {
      return allTodos.where((todo) => !todo.completed).toList();
    } else {
      return allTodos;
    }
  }
}
