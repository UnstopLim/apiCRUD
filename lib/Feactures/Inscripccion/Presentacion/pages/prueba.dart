import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class Incripcion extends StatefulWidget {
  const Incripcion({super.key});

  @override
  State<Incripcion> createState() => _IncripcionState();
}

class _IncripcionState extends State<Incripcion> {

  CameraController? _cameraController;


  List<CameraDescription>? _cameras;
  String? _capturedImagePath;


  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {

    await Permission.camera.request();
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) return;
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String filePath = path.join(extDir.path, '${DateTime.now()}.jpg');
    await _cameraController!.takePicture().then((XFile file) {
      setState(() {
        _capturedImagePath = file.path;
      });
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foto Carnet")),
      body: Column(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            SizedBox(
              height: 300,
              child: CameraPreview(_cameraController!),
            ),

          ElevatedButton(
            onPressed: _takePicture,
            child: const Text("Tomar foto"),
          ),

          if (_capturedImagePath != null)
            Image.file(
              File(_capturedImagePath!),
              height: 200,

            )
        ],
      ),
    );
  }
}
