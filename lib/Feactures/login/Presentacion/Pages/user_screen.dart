import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_api/Feactures/login/Presentacion/provider/user_provider.dart';


class UserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Users CRUD')),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return Center(child: Text("No hay usuarios disponibles"));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          );
        },
        loading: () {
          print("Cargando usuarios...");
          return Center(child: CircularProgressIndicator());
        },
        error: (err, stack) {
          debugPrint("Error en usersProvider: $err");
          return Center(child: Text('Error: $err'));
        },
      ),
    );
  }
}
