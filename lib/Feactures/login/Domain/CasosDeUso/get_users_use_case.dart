// domain/usecases/get_users_use_case.dart

import 'package:prueba_api/Feactures/login/Domain/Entities/user_model.dart';
import 'package:prueba_api/Feactures/login/Data/Repository/user_repository.dart';


class UserUseCases {
  final UserRepository repository;

  UserUseCases(this.repository);

  Future<List<UserModel>> getUsers() async {
    return await repository.getUsers();
  }

  Future<void> createUser(UserModel user) async {
    return await repository.createUser(user);
  }

  Future<void> updateUser(UserModel user) async {
    return await repository.updateUser(user);
  }

  Future<void> deleteUser(int id) async {
    return await repository.deleteUser(id);
  }
}