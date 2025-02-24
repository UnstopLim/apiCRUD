// domain/usecases/get_users_use_case.dart

import 'package:prueba_api/Feactures/login/Domain/Entities/user_model.dart';
import 'package:prueba_api/Feactures/login/Data/Repository/user_repository.dart';


class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<UserModel>> call() async {
    return await repository.getUsers();
  }
}
