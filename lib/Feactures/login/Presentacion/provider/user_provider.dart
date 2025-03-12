import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_api/Feactures/login/Domain/Entities/user_model.dart';
import 'package:prueba_api/Feactures/login/Data/Repository/user_repository.dart';
import 'package:prueba_api/core/network/api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(apiClientProvider));
});

final userUseCasesProvider = Provider((ref) {
  return UserRepository(ref.watch(apiClientProvider));
});

// Proveedor para obtener la lista de usuarios
final usersProvider = FutureProvider<List<UserModel>>((ref) async {
  return await ref.watch(userRepositoryProvider).getUsers();
});

// Provider para agregar un usuario
final createUserProvider = FutureProvider.family<void, UserModel>((ref, user) async {
  await ref.watch(userRepositoryProvider).createUser(user);
  ref.invalidate(usersProvider); // Recargar lista
});

// Provider para actualizar un usuario
final updateUserProvider = FutureProvider.family<void, UserModel>((ref, user) async {
  await ref.watch(userRepositoryProvider).updateUser(user);
  ref.invalidate(usersProvider);
});

// Provider para eliminar un usuario
final deleteUserProvider = FutureProvider.family<void, int>((ref, id) async {
  await ref.watch(userRepositoryProvider).deleteUser(id);
  ref.invalidate(usersProvider);
});
