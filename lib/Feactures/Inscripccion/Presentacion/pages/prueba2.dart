import 'dart:io';
import 'package:flutter/material.dart';

import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:permission_handler/permission_handler.dart';


class Incripcion2 extends StatefulWidget {
  const Incripcion2({super.key});

  @override
  State<Incripcion2> createState() => _IncripcionState();

}

class _IncripcionState extends State<Incripcion2> {
  String? _imagePath;

  Future<void> _scanDocument()
  async
  {
    final status = await Permission.camera.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permiso de cámara denegado")),
      );
      return;
    }

    final scanner = DocumentScanner(
      options: DocumentScannerOptions(
        documentFormat: DocumentFormat.jpeg,
        mode: ScannerMode.filter,
        pageLimit: 2,
        //isGalleryImport: true,
      ),
    );

    try {
      final result = await scanner.scanDocument();
      // Lanza la interfaz para escanear el documento

      if (result.images.isNotEmpty) {
        setState(() {
          _imagePath = result.images.first;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se capturó ninguna imagen actualizate.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al escanear: $e")),
      );
    } finally {
      scanner.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escaneo de Carnet")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _scanDocument,
              child: const Text("Escanear Carnet"),
            ),
            const SizedBox(height: 20),

            if (_imagePath != null)

              Column(
                children: [
                  const Text("Imagen escaneada:"),
                  const SizedBox(height: 10),
                  Image.file(
                    File(_imagePath!),
                    height: 300,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
