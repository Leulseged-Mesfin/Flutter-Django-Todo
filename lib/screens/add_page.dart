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
    
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      'title': title,
      'description': description,
      'completed': false,
    };

    // send data to backend server
    final url = 'http://10.0.2.2:8000/api/todos/';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri, 
      body: jsonEncode(body), 
      headers: {
      'Content-Type': 'application/json',
    });
    // handle response in UI
    if (response.statusCode == 201) {
      titleController.clear();
      descriptionController.clear();
      print("Creation Successful");
      successMessage("Todo Created Successfully");
    } else {
      print("Creation Failed");
      errorMessage("Failed to Create Todo");
    }
    print(response.body);
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