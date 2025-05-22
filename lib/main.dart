import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_api/Core/di/injection.dart';
import 'package:prueba_api/Feactures/Inscripccion/Presentacion/pages/prueba.dart';
import 'package:prueba_api/Feactures/Inscripccion/Presentacion/pages/prueba2.dart';
import 'package:prueba_api/Feactures/login/Presentacion/Pages/user_screen.dart';

void main() {
  runApp(
      ProviderScope(child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Incripcion2(),
    );
  }
}

