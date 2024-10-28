import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  List<CameraDescription>? cameras;
  CameraDescription? selectedCamera;
  XFile? _videoFile;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    selectedCamera = cameras!.first;

    _controller = CameraController(
      selectedCamera!,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Función para comenzar la grabación
  Future<void> startRecording() async {
    if (_controller != null && _controller!.value.isInitialized) {
      await _controller!.startVideoRecording();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Grabación iniciada'),
          duration: Duration(seconds: 1), // Duración de 1 segundo
        ),
      );
    }
  }

  // Función para detener la grabación
  Future<void> stopRecording() async {
    if (_controller != null && _controller!.value.isRecordingVideo) {
      _videoFile = await _controller!.stopVideoRecording();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Grabación detenida'),
          duration: Duration(seconds: 1), // Duración de 1 segundo
        ),
      );
      setState(() {});
    }
  }

  // Función para pausar la grabación
  Future<void> pauseRecording() async {
    if (_controller != null && _controller!.value.isRecordingVideo) {
      await _controller!.pauseVideoRecording();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Grabación en pausa'),
          duration: Duration(seconds: 1), // Duración de 1 segundo
        ),
      );
    }
  }

  // Función para reanudar la grabación
  Future<void> resumeRecording() async {
    if (_controller != null && _controller!.value.isRecordingPaused) {
      await _controller!.resumeVideoRecording();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Grabación reanudada'),
          duration: Duration(seconds: 1), // Duración de 1 segundo
        ),
      );
    }
  }

  // Guardar el archivo grabado en la carpeta de la aplicación
  Future<void> saveVideo() async {
    if (_videoFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final newPath = '${directory.path}/${DateTime.now()}.mp4';
      File(_videoFile!.path).copy(newPath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video guardado en Videos Guardados'),
          duration: Duration(seconds: 1), // Duración de 1 segundo
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grabación de Video'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child:
                      CameraPreview(_controller!), // Vista previa de la cámara
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.videocam,
                            color: Colors.deepPurple, size: 30),
                        onPressed: startRecording,
                      ),
                      IconButton(
                        icon: Icon(Icons.pause,
                            color: Colors.deepPurple, size: 30),
                        onPressed: pauseRecording,
                      ),
                      IconButton(
                        icon: Icon(Icons.play_arrow,
                            color: Colors.deepPurple, size: 30),
                        onPressed: resumeRecording,
                      ),
                      IconButton(
                        icon: Icon(Icons.stop,
                            color: Colors.deepPurple, size: 30),
                        onPressed: stopRecording,
                      ),
                      IconButton(
                        icon: Icon(Icons.save,
                            color: Colors.deepPurple, size: 30),
                        onPressed: saveVideo,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
