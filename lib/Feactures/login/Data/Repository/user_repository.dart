// data/user_repository.dart

import 'package:prueba_api/Feactures/login/Data/Mapper/user_mapper.dart';
import 'package:prueba_api/Feactures/login/Domain/Entities/user_model.dart';
import 'package:prueba_api/core/network/api_client.dart';



class UserRepository {
  final ApiClient apiClient;

  UserRepository(this.apiClient);

  Future<List<UserModel>> getUsers() async {
    try
    {
      final response = await apiClient.get('/users');
      print("📡 Respuesta de la API: ${response.data}");

      if (response.data is List) {
        final users = (response.data as List)
            .map((json) => UserMapper.fromJson(json)) // Usamos el mapper
            .toList();

        print("✅ Usuarios obtenidos: $users");
        return users;
      } else {
        print("⚠️ Respuesta inesperada de la API: ${response.data}");
        return [];
      }
    } catch (e) {
      print("❌ Error obteniendo usuarios: $e");
      return [];
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await apiClient.post('/users', UserMapper.toJson(user)); // Usamos el mapper
      print("✅ Usuario creado: ${UserMapper.toJson(user)}");
    } catch (e) {
      print("❌ Error al crear usuario: $e");
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await apiClient.put('/users/${user.id}', UserMapper.toJson(user)); // Usamos el mapper
      print("✅ Usuario actualizado: ${UserMapper.toJson(user)}");
    } catch (e) {
      print("❌ Error al actualizar usuario: $e");
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await apiClient.delete('/users/$id');
      print("✅ Usuario eliminado: ID $id");
    } catch (e) {
      print("❌ Error al eliminar usuario: $e");
    }
  }
}
