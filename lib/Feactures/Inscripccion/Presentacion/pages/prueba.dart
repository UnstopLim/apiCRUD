import 'dart:io';
// Permite trabajar con archivos y rutas, necesario para mostrar la imagen tomada

import 'package:camera/camera.dart';
// Provee acceso a las cámaras del dispositivo, permite inicializar la cámara y tomar fotos

import 'package:flutter/material.dart';
// Librería base de Flutter para construir interfaces visuales

import 'package:path/path.dart' as path;
// Permite manejar rutas de archivos de manera segura, por ejemplo para crear el nombre de la foto con fecha

import 'package:path_provider/path_provider.dart';
// Permite obtener rutas especiales del dispositivo, como el directorio donde guardar la imagen

import 'package:permission_handler/permission_handler.dart';
// Gestiona permisos (aquí para solicitar acceso a la cámara)

class Incripcion extends StatefulWidget {
  const Incripcion({super.key});

  @override
  State<Incripcion> createState() => _IncripcionState();
// Estado mutable para manejar la cámara y la imagen capturada
}

class _IncripcionState extends State<Incripcion> {
  CameraController? _cameraController;
  // Controlador que maneja la cámara física y su configuración (resolución, captura...)

  List<CameraDescription>? _cameras;
  // Lista de cámaras disponibles (frontal, trasera...)

  String? _capturedImagePath;
  // Guarda la ruta local del archivo de la imagen capturada para mostrarla en pantalla

  @override
  void initState() {
    super.initState();
    _initCamera();
    // Al iniciar el widget, inicializamos la cámara para tenerla lista para usar
  }

  Future<void> _initCamera() async {
    await Permission.camera.request();
    // Solicita permiso al usuario para acceder a la cámara, importante para que funcione en móviles

    _cameras = await availableCameras();
    // Obtiene la lista de cámaras disponibles en el dispositivo (normalmente frontal y trasera)

    if (_cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.medium);
      // Inicializa el controlador con la primera cámara (usualmente la trasera) y resolución media para balancear calidad y rendimiento

      await _cameraController!.initialize();
      // Inicializa la cámara para poder usarla (abre la cámara)

      setState(() {});
      // Actualiza la interfaz para mostrar el preview de la cámara
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) return;
    // Si la cámara no está lista, no hacer nada

    final Directory extDir = await getApplicationDocumentsDirectory();
    // Obtiene el directorio donde se pueden guardar archivos privados de la app en el dispositivo

    final String filePath = path.join(extDir.path, '${DateTime.now()}.jpg');
    // Crea una ruta de archivo con fecha y hora actual para que cada foto tenga un nombre único

    await _cameraController!.takePicture().then((XFile file) {
      setState(() {
        _capturedImagePath = file.path;
        // Guarda la ruta del archivo recién creado para mostrar la imagen en la app
      });
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    // Libera recursos al cerrar la pantalla para evitar fugas de memoria o bloqueo de cámara

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foto Carnet")),
      body: Column(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
          // Verifica que la cámara esté inicializada para mostrar el preview

            SizedBox(
              height: 300,
              child: CameraPreview(_cameraController!),
              // Muestra la imagen en vivo de la cámara dentro de un contenedor de 300 px de alto
            ),

          ElevatedButton(
            onPressed: _takePicture,
            child: const Text("Tomar foto"),
            // Botón para capturar la imagen cuando el usuario esté listo
          ),

          if (_capturedImagePath != null)
            Image.file(
              File(_capturedImagePath!),
              height: 200,
              // Muestra la imagen tomada en un widget debajo del botón, con un tamaño fijo de 200 px de alto
            )
        ],
      ),
    );
  }
}
