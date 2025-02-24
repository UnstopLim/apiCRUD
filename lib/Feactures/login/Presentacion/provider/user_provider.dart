import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_api/Feactures/login/Domain/Entities/user_model.dart';
import 'package:prueba_api/Feactures/login/Data/Repository/user_repository.dart';
import 'package:prueba_api/core/di/injection.dart';
import 'package:prueba_api/core/network/api_client.dart';


// 1️⃣ Proveedor para ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// 2️⃣ Proveedor para UserRepository, usando apiClientProvider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(apiClientProvider));
});

// 3️⃣ Proveedor para obtener usuarios
final usersProvider = FutureProvider<List<UserModel>>((ref) async {
  try {
    return await ref.watch(userRepositoryProvider).getUsers();
  } catch (e) {
    print("❌ Error cargando usuarios: $e");
    return [];
  }
});
