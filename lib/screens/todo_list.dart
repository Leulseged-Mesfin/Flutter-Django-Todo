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
  bool isLoading = true;
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
      body: Visibility(
        visible: isLoading,
        child: const Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(item['title']),
                subtitle: Text(item['description'] ?? ''),
                );
            },
          ),
        ),
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
    final uri = Uri.parse('http://10.0.2.2:8000/api/todos/');
    final response = await http.get(uri);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
