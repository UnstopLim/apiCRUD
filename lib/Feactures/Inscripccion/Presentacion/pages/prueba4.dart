import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:path_provider/path_provider.dart';

late List<CameraDescription> cameras;

class Prueba3 extends StatefulWidget {
  const Prueba3({super.key});

  @override
  State<Prueba3> createState() => _Prueba3State();
}

class _Prueba3State extends State<Prueba3> {
  late CameraController _cameraController;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  bool _faceConfirmed = false;
  XFile? _capturedImage;

  double _detectionProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    final frontCam = cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCam,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController.initialize();
    await _cameraController.startImageStream(_processImage);
    setState(() {});
  }

  Future<void> _processImage(CameraImage cameraImage) async {
    if (_isDetecting || _faceConfirmed) return;
    _isDetecting = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in cameraImage.planes) {
        allBytes.putUint8List(plane.bytes);
      }

      final bytes = allBytes.done().buffer.asUint8List();
      final Size imageSize = Size(
        cameraImage.width.toDouble(),
        cameraImage.height.toDouble(),
      );

      final camera = _cameraController.description;
      final rotation =
          InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
              InputImageRotation.rotation0deg;

      final format =
      InputImageFormatValue.fromRawValue(cameraImage.format.raw);

      if (format == null) {
        print('Formato de imagen no soportado: ${cameraImage.format.raw}');
        _isDetecting = false;
        return;
      }

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: imageSize,
          rotation: rotation,
          format: format,
          bytesPerRow: cameraImage.planes[0].bytesPerRow,
        ),
      );

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;
        final leftEyeOpen = face.leftEyeOpenProbability ?? 0;
        final rightEyeOpen = face.rightEyeOpenProbability ?? 0;
        final smile = face.smilingProbability ?? 0;

        _detectionProgress = ((leftEyeOpen + rightEyeOpen + smile) / 3).clamp(0, 1);

        if (_detectionProgress > 0.85) {
          _faceConfirmed = true;
          await _takePicture();
        }
      } else {
        _detectionProgress = 0.0;
      }
    } catch (e) {
      print("Error en procesamiento: $e");
    } finally {
      _isDetecting = false;
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    await _cameraController.stopImageStream();
    await _cameraController.pausePreview();
    final image = await _cameraController.takePicture();
    setState(() {
      _capturedImage = image;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _capturedImage == null
          ? Stack(
        children: [
          CameraPreview(_cameraController),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Abre los ojos y sonríe para confirmar',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: _detectionProgress,
                    color: Colors.green,
                    backgroundColor: Colors.white,
                    minHeight: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(_capturedImage!.path)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                _faceConfirmed = false;
                _capturedImage = null;
                _detectionProgress = 0.0;
                await _cameraController.resumePreview();
                await _cameraController.startImageStream(_processImage);
                setState(() {});
              },
              child: const Text("Intentar de nuevo"),
            )
          ],
        ),
      ),
    );
  }
}
