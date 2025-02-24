// data/mappers/user_mapper.dart

import 'package:prueba_api/Feactures/login/Domain/Entities/user_model.dart';

class UserMapper {
  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  static Map<String, dynamic> toJson(UserModel user) {
    return {
      "id": user.id,
      "name": user.name,
      "email": user.email,
    };
  }
}
