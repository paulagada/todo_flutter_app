import 'package:flutter/material.dart';
import 'package:todo_app/services/model/todo.dart';

class ViewTodo extends StatefulWidget {
  final Todo todo;

  const ViewTodo({super.key, required this.todo});

  @override
  State<ViewTodo> createState() => _ViewTodoState();
}

class _ViewTodoState extends State<ViewTodo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.todo.title!,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Title:"),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.todo.title!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const Text("Body:"),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.todo.description!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const Text("Completed:"),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.todo.completed! ? "True" : "False",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
