import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_api/Feactures/login/Domain/Entities/user_model.dart';
import 'package:prueba_api/Feactures/login/Data/Repository/user_repository.dart';
import 'package:prueba_api/core/network/api_client.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ApiClient());
});

final usersProvider = FutureProvider<List<UserModel>>((ref) async {
  return await ref.watch(userRepositoryProvider).getUsers();
});

class UserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Users CRUD')),
      body: usersAsync.when(
        data: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showUserForm(context, ref, user),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteUser(ref, user.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserForm(context, ref, null),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showUserForm(BuildContext context, WidgetRef ref, UserModel? user) {
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final isEditing = user != null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Usuario' : 'Nuevo Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
              TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newUser = UserModel(
                  id: isEditing ? user!.id : DateTime.now().millisecondsSinceEpoch, // ID temporal
                  name: nameController.text,
                  email: emailController.text,
                );
                if (isEditing) {
                  _updateUser(ref, newUser);
                } else {
                  _createUser(ref, newUser);
                }
                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Actualizar' : 'Crear'),
            ),
          ],
        );
      },
    );
  }

  void _createUser(WidgetRef ref, UserModel user) async {
    await ref.read(userRepositoryProvider).createUser(user);
    ref.invalidate(usersProvider); // Recargar usuarios
  }

  void _updateUser(WidgetRef ref, UserModel user) async {
    await ref.read(userRepositoryProvider).updateUser(user);
    ref.invalidate(usersProvider);
  }

  void _deleteUser(WidgetRef ref, int id) async {
    await ref.read(userRepositoryProvider).deleteUser(id);
    ref.invalidate(usersProvider);
  }
}
