import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_django/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text('Sample Text'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddTodoPage();
        },
        label: const Text('Add Todo'),
      ),
    );
  }

  void navigateToAddTodoPage() {
    final route = MaterialPageRoute(
      builder: (context) {
        return AddTodoPage();
      },
    );
    print(items);
    Navigator.push(context, route);
  }

  Future<void> fetchData() async {
    // fetch data from API
    final uri = Uri.parse('http://10.0.2.2:8000/api/todos/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      print(result);
      setState(() {
        items = result;
      });
    } else {
      print('Failed to fetch data');
    }
  }
}
