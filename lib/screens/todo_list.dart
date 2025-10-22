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
  List<dynamic> items = [];

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
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final id = item['id'].toString();
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item['title']),
                subtitle: Text(item['description'] ?? ''),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    // Handle menu item selection
                    if (value == 'edit') {
                      // Navigate to edit page
                      navigateToEditPage(item);
                    } else if (value == 'delete') {
                      // Handle delete action
                      deleteById(id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddTodoPage();
        },
        label: const Text('Add Todo'),
      ),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) {
        return AddTodoPage(todo: item);
      },
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> navigateToAddTodoPage() async {
    final route = MaterialPageRoute(
      builder: (context) {
        return AddTodoPage();
      },
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> deleteById(id) async {
    final uri = Uri.parse('http://10.0.2.2:8000/api/todos/$id/');
    final response = await http.delete(uri);
    if (response.statusCode == 204) {
      final filtered = items.where((item) => item['id'].toString() != id).toList();
      setState(() {
        items = filtered;
      });
      successMessage("Todo Deleted Successfully");
    } else {
      errorMessage("Failed to Delete Todo");
    }
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

  
  void successMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void errorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
