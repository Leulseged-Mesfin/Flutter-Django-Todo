import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
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
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
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
              // Handle save action
            },
            child: Text('Submit'),
          ),
        ],
      ),
      
    );
  }
}