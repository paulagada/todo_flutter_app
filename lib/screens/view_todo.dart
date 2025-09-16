import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/model/todo.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/util/api.dart';

class ViewTodo extends StatefulWidget {
  final Todo todo;

  const ViewTodo({super.key, required this.todo});

  @override
  State<ViewTodo> createState() => _ViewTodoState();
}

class _ViewTodoState extends State<ViewTodo> with Api {
  TodoService service = TodoService();
  TextEditingController email = TextEditingController();
  Map<int, bool> tileDeleteLoading = {};
  final _dialogFormKey = GlobalKey<FormState>();
  List<Map<String, dynamic>>? users;
  bool loading = false;
  bool dLoading = false;

  @override
  void initState() {
    getTodoAssignedUsers();
    super.initState();
  }

  void getTodoAssignedUsers() async {
    setState(() {
      loading = true;
    });
    try {
      setState(() {
        users = null;
      });
      var response =
          await service.getUserAssignedTodo(widget.todo.id.toString());
      users = response;
    } on DioException catch (e) {
      var apiError = handleDioError(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(apiError.message.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e, s) {
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

  Future<void> assignUser() async {
    setState(() {
      loading = true;
    });
    try {
      var response = await service.assignTodo(
        widget.todo.id.toString(),
        {
          "email": email.text,
        },
      );
      getTodoAssignedUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["message"]),
          backgroundColor: Colors.green,
        ),
      );
    } on DioException catch (e, s) {
      var apiError = handleDioError(e);
      print(e.error);
      print(apiError.message.toString());
      print(s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(apiError.message.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e, s) {
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

  Future<void> deleteAssignUser(id, String email) async {
    setState(() {
      tileDeleteLoading[id] = true;
    });
    try {
      var response = await service.deleteAssignTodo(
        widget.todo.id.toString(),
        {
          "email": email,
        },
      );
      getTodoAssignedUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["message"]),
          backgroundColor: Colors.green,
        ),
      );
    } on DioException catch (e) {
      var apiError = handleDioError(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(apiError.message.toString()),
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

  assignUserDialog() {
    showDialog(
      context: context,
      builder: (_) =>
          StatefulBuilder(builder: (context, StateSetter setStates) {
        return AlertDialog(
          title: const Text("Enter User Email"),
          content: Form(
            key: _dialogFormKey,
            child: TextFormField(
              readOnly: loading,
              controller: email,
              validator: (val) {
                return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                    ? null
                    : "Please enter a valid email";
              },
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(_),
              child: const Text(
                "cancel",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: dLoading
                  ? null
                  : () async {
                      try {
                        setStates(() {
                          dLoading = true;
                        });
                        await assignUser();
                        Navigator.pop(_);
                      } finally {
                        setStates(() {
                          dLoading = false;
                        });
                      }
                    },
              child: dLoading
                  ? const CircularProgressIndicator()
                  : const Text("Send"),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.todo.title!,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Assign to user"),
                value: 1,
              ),
            ],
            onSelected: (v) {
              switch (v) {
                case 1:
                  assignUserDialog();
                  break;
              }
            },
          ),
        ],
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
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(
                height: 20,
              ),
              const Text("Assigned To:"),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: users == null
                      ? CircularProgressIndicator()
                      : users!.isNotEmpty
                          ? Column(
                              children: [
                                ...users!.map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(e['email']),
                                          tileDeleteLoading[e["id"]] == true
                                              ? CircularProgressIndicator()
                                              : GestureDetector(
                                                  onTap: () => deleteAssignUser(
                                                      e["id"], e["email"]),
                                                  child: Icon(Icons.delete)),
                                        ],
                                      ),
                                    )),
                              ],
                            )
                          : GestureDetector(
                              onTap: () => assignUserDialog(),
                              child: Icon(Icons.add),
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
