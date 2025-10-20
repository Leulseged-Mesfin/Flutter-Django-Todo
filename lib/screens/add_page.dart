import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 8,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              submitData();
            },
            child: Text('Submit'),
          ),
        ],
      ),
      
    );
  }

  Future<void> submitData() async {
    // get data from text fields
    
    final String title = titleController.text;
    final String description = descriptionController.text;
    final body = {
      'title': title,
      'description': description,
      'completed': false,
    };

    // send data to backend server
    final uri = Uri.parse('http://127.0.0.1:8000/api/todos/');
    final response = await http.post(uri, body: jsonEncode(body));
    // handle response in UI
    print(response.statusCode);
    print(response.body);
  }
}