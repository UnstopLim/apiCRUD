import 'dart:io';
// Permite trabajar con archivos para manejar la imagen escaneada y mostrarla desde la ruta local.

import 'package:flutter/material.dart';
// Librería base para construir la interfaz gráfica en Flutter.

import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
// Librería oficial de Google ML Kit para escanear documentos con la cámara o desde galería.

import 'package:permission_handler/permission_handler.dart';
// Permite solicitar y gestionar permisos en tiempo de ejecución, aquí para pedir permiso de cámara.

class Incripcion2 extends StatefulWidget {
  const Incripcion2({super.key});

  @override
  State<Incripcion2> createState() => _IncripcionState();
// Crea el estado mutable para manejar la lógica del escaneo y la UI.
}

class _IncripcionState extends State<Incripcion2> {
  String? _imagePath;
  // Variable que guarda la ruta local de la imagen escaneada para luego mostrarla en pantalla.

  Future<void> _scanDocument() async {
    final status = await Permission.camera.request();
    // Solicita permiso para usar la cámara, importante para poder capturar imagenes.

    if (!status.isGranted) {
      // Si el permiso es denegado, muestra un mensaje y termina la función.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permiso de cámara denegado")),
      );
      return;
    }

    final scanner = DocumentScanner(
      options: DocumentScannerOptions(
        documentFormat: DocumentFormat.jpeg,
        // Formato en que se guardará la imagen escaneada, aquí JPEG.

        mode: ScannerMode.filter,
        // Modo de escaneo: "filter" aplica filtros para mejorar la imagen (borde, brillo, etc.)

        pageLimit: 1,
        // Limita el escaneo a una sola página o imagen.

        isGalleryImport: true,
        // Permite que el usuario pueda importar imágenes desde la galería también.
      ),
    );

    try {
      final result = await scanner.scanDocument();
      // Lanza la interfaz para escanear el documento o importar desde galería, y espera el resultado.

      if (result.images.isNotEmpty) {
        // Si se escaneó o importó alguna imagen, actualiza el estado con la ruta del archivo.
        setState(() {
          _imagePath = result.images.first;
        });
      } else {
        // Si no se obtuvo ninguna imagen, muestra un mensaje.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se capturó ninguna imagen.")),
        );
      }
    } catch (e) {
      // Captura cualquier error en el proceso de escaneo e informa al usuario.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al escanear: $e")),
      );
    } finally {
      scanner.close();
      // Siempre cierra el scanner para liberar recursos.
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
              // Botón que inicia el proceso de escaneo o importación.
              child: const Text("Escanear Carnet"),
            ),
            const SizedBox(height: 20),

            if (_imagePath != null)
            // Si ya hay una imagen escaneada, la muestra en pantalla.
              Column(
                children: [
                  const Text("Imagen escaneada:"),
                  const SizedBox(height: 10),
                  Image.file(
                    File(_imagePath!),
                    height: 300,
                    // Muestra la imagen desde el archivo local con altura fija de 300 px.
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
