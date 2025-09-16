import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/view_assign_todo.dart';
import 'package:todo_app/services/model/assignedTodo.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/util/api.dart';

class AssignedTodoPage extends StatefulWidget {
  const AssignedTodoPage({super.key});

  @override
  State<AssignedTodoPage> createState() => _AssignedTodoPageState();
}

class _AssignedTodoPageState extends State<AssignedTodoPage> with Api {
  List<AssignedTodo>? todos;
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
      var response = await service.getAssignedTodos();
      todos = response;
    } on DioException catch (e) {
      var apiError = handleDioError(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(apiError.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e,s) {
      print(e);
      print(s);
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
      var response = await service.updateAssignedTodoComplete(id.toString(), payload);
      getTodos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response["message"],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on DioException catch (e,s) {

      var apiError = handleDioError(e);
      print(apiError.message);
      print(s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(apiError.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e,s) {
      print(e);
      print(s);
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
                          builder: (con) => ViewAssignedTodo(todo: e),
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
                              markComplete(
                                e.id,
                                {"completed" : !e.completed},
                              );
                            },
                            iconSize: 18,
                            icon: tileLoading[e.id] == true
                                ? const SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator())
                                : Icon(
                              e.completed
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
