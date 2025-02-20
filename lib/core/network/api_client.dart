import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

  Future<Response> get(String endpoint) async {
    print("Haciendo GET a: $endpoint");  // Añadir print para depuración
    return await _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    print("Haciendo POST a: $endpoint con datos: $data");  // Depuración
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, Map<String, dynamic> data) async {
    print("Haciendo PUT a: $endpoint con datos: $data");  // Depuración
    return await _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint) async {
    print("Haciendo DELETE a: $endpoint");  // Depuración
    return await _dio.delete(endpoint);
  }
}
