import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_or_edit_todo_page.dart';
import 'package:todo_app/screens/view_todo.dart';
import 'package:todo_app/services/model/todo.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/util/api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with Api {
  List<Todo>? todos;
  TodoService service = TodoService();
  bool loading = false;
  Map<int, bool> tileLoading = {};
  Map<int, bool> tileDeleteLoading = {};

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
      todos = response.cast<Todo>();
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

  void markComplete(id, payload) async {
    setState(() {
      tileLoading[id] = true;
    });
    try {
      await service.updateTodo(id, payload);
      getTodos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Marked as ${payload["completed"] ? "completed" : "incomplete"}",
          ),
          backgroundColor: Colors.green,
        ),
      );
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
        tileLoading[id] = false;
      });
    }
  }

  void deleteTodo(id) async {
    setState(() {
      tileDeleteLoading[id] = true;
    });
    try {
      await service.deleteTodo(id);
      getTodos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Deleted"),
          backgroundColor: Colors.green,
        ),
      );
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
        tileDeleteLoading[id] = false;
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
        child: Text("No Todo(s) yet"),
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
                    trailing: SizedBox(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => AddOrEditTodoPage(
                                    isEdit: true,
                                    todo: e,
                                  ),
                                ),
                              );
                            },
                            iconSize: 18,
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteTodo(e.id);
                            },
                            iconSize: 18,
                            icon: tileDeleteLoading[e.id] == true
                                ? const SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator())
                                : const Icon(Icons.delete_outline),
                          ),
                          IconButton(
                            onPressed: () {
                              markComplete(
                                e.id,
                                Todo(
                                        completed: !e.completed!,
                                        description: e.description,
                                        title: e.title)
                                    .toJson(),
                              );
                            },
                            iconSize: 18,
                            icon: tileLoading[e.id] == true
                                ? const SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator())
                                : Icon(
                                    e.completed!
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                  ),
                          ),
                        ],
                      ),
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
