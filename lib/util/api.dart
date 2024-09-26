import 'package:dio/dio.dart';
import 'package:todo_app/util/urls.dart';

mixin Api {
  final Dio httpClient = Dio(BaseOptions(baseUrl: baseUrl, headers: {
    "accept": "application/json",
  }));

  ApiError handleDioError(DioException error) {
    var data = error.response?.data;
    switch (error.type) {
      case DioExceptionType.badResponse:
        return ApiError(data['message'] ?? data['error'] ?? "An error occurred",
            errors: Map<String, List<dynamic>>.from(data['errors'] ?? {}),
            statusCode: error.response?.statusCode);

      case DioExceptionType.connectionError:
        return ApiError("Connection Error, Please check internet connection.",
            statusCode: error.response?.statusCode);

      case DioExceptionType.cancel:
        return ApiError("Request Canceled",
            statusCode: error.response?.statusCode);

      case DioExceptionType.connectionTimeout:
        return ApiError("Connection Time Out.",
            statusCode: error.response?.statusCode);

      case DioExceptionType.receiveTimeout:
        return ApiError("Unable to complete request.",
            statusCode: error.response?.statusCode);

      case DioExceptionType.sendTimeout:
        return ApiError("Could not post request",
            statusCode: error.response?.statusCode);
      default:
        return ApiError("An error has occurred",
            statusCode: error.response?.statusCode);
    }
  }
}

class ApiError {
  String? message;
  Map<String, List<dynamic>>? errors;
  int? statusCode;

  ApiError(
    this.message, {
    this.errors,
    this.statusCode,
  });
}
