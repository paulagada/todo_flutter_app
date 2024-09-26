import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/navigation_page.dart';
import 'package:todo_app/services/model/todo.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/util/api.dart';

class AddOrEditTodoPage extends StatefulWidget {
  final bool isEdit;
  final Todo? todo;

  const AddOrEditTodoPage({super.key, this.isEdit = false, this.todo});

  @override
  State<AddOrEditTodoPage> createState() => _AddOrEditTodoPageState();
}

class _AddOrEditTodoPageState extends State<AddOrEditTodoPage> with Api {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TodoService service = TodoService();
  bool loading = false;

  @override
  void initState() {
    if (widget.isEdit == true) {
      title.text = widget.todo!.title!;
      description.text = widget.todo?.description ?? "";
    }
    super.initState();
  }

  Future<void> createTodo(Map<String, dynamic> payload) async {
    setState(() {
      loading = true;
    });
    try {
      await service.createTodo(payload);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Created"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, NavigationPage.path);
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

  Future<void> updateTodo(payload) async {
    setState(() {
      loading = true;
    });
    try {
      await service.updateTodo(widget.todo!.id!, payload);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Updated"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, NavigationPage.path);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? "Edit Task" : "Add Task",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 20,
        ),
        child: Column(
          children: [
            TextFormField(
              controller: title,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLines: 5,
              controller: description,
              decoration: const InputDecoration(
                hintText: "Body",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    if (widget.isEdit) {
                      await updateTodo(Todo(
                        title: title.text,
                        description: description.text,
                        completed: widget.todo!.completed
                      ).toJson());
                    } else {
                      await createTodo(
                        {
                          "title" : title.text,
                          "description" : description.text,
                        }
                      );
                    }
                  },
                  child: loading ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(color: Colors.white,)) : Text(
                    widget.isEdit ? "Update" : "Add",
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
