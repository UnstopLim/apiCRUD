import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:prueba_api/Feactures/Inscripccion/Presentacion/pages/prueba4.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MaterialApp(home: Prueba3()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Prueba3(),
    );
  }
}
