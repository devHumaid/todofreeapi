import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/api_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<ApiModel> fetchTodo() async {
    final url = 'https://dummyjson.com/todos';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = ApiModel.fromJson(res);
      return data;
    } else {
      throw Exception('Failed to load todos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: FutureBuilder<ApiModel>(
        future: fetchTodo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.todos != null) {
            return ListView.builder(
              itemCount: snapshot.data!.todos!.length,
              itemBuilder: (context, index) {
                final todo = snapshot.data!.todos![index];

                return Card(
                  child: ListTile(
                    leading: Text(todo.id.toString()),
                    title: Text(todo.todo ?? 'No description'),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No todos found'));
          }
        },
      ),
    );
  }
}
