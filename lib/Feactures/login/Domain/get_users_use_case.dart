import '../data/user_repository.dart';
import '../data/user_model.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<UserModel>> call() async {
    return await repository.getUsers();
  }
}
