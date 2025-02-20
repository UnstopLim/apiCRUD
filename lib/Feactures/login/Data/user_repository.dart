import '../../../core/network/api_client.dart';
import 'user_model.dart';

import '../../../core/network/api_client.dart';
import 'user_model.dart';

class UserRepository {
  final ApiClient apiClient;

  UserRepository(this.apiClient);

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await apiClient.get('/users');

      print("📡 Respuesta de la API: ${response.data}"); // Debug: Ver datos crudos

      if (response.data is List) {
        final users = (response.data as List)
            .map((json) => UserModel.fromJson(json))
            .toList();

        print("✅ Usuarios obtenidos: $users"); // Debug: Ver si los datos se procesan bien
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
      await apiClient.post('/users', user.toJson());
      print("✅ Usuario creado: ${user.toJson()}");
    } catch (e) {
      print("❌ Error al crear usuario: $e");
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await apiClient.put('/users/${user.id}', user.toJson());
      print("✅ Usuario actualizado: ${user.toJson()}");
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
