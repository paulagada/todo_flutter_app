import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/view_todo.dart';
import 'package:todo_app/services/model/todo.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/util/api.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> with Api{
  List<Todo>? todos;
  TodoService service = TodoService();
  bool loading = false;

  @override
  void initState() {
    getTodos();
    super.initState();
  }

  void getTodos() async {
    setState(() {
      loading = true;
    });
    try {
      var response = await service.getTodos();
      var filterTodos = response.cast<Todo>().where((t) => t.completed!).toList();
      todos = filterTodos;
    } on DioException catch (e) {
      var apiError = handleDioError(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(apiError.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (todos!.isEmpty) {
      return const Center(
        child: Text("No completed Todo(s) yet"),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ...todos!.map(
                  (e) => Padding(
                padding: const EdgeInsets.all(5),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (con) => ViewTodo(todo: e),
                        ),
                      );
                    },
                    title: Text(e.title!.toUpperCase()),
                    subtitle: Text(
                      e.description ?? "",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

  }
}
