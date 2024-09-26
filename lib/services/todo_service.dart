import 'package:dio/dio.dart';
import 'package:todo_app/services/model/todo.dart';
import 'package:todo_app/util/api.dart';
import 'package:todo_app/util/storage.dart';

class TodoService with Api, AppStorage {

  Future<List<Todo>> getTodos() async {
    var token = await getToken();
    var response = await httpClient.get(
      "/todos",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    return todoFromJson(response.data);
  }

  Future<Todo> updateTodo(
    int id,
    Map<String, dynamic> payload,
  ) async {
    var token = await getToken();
    var response = await httpClient.put(
      "/todos/$id",
      data: payload,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    return Todo.fromJson(response.data);
  }

  Future<Todo> createTodo(
      Map<String, dynamic> payload,
      ) async {
    var token = await getToken();
    var response = await httpClient.post(
      "/todos",
      data: payload,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    return Todo.fromJson(response.data);
  }

  Future deleteTodo(
      int id,
      ) async {
    var token = await getToken();
    var response = await httpClient.delete(
      "/todos/$id",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    return response.data;
  }
}
