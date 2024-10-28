import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

class VideoPlayerScreen extends StatefulWidget {
  final File videoFile;
  final bool showSaveButton;

  VideoPlayerScreen({required this.videoFile, this.showSaveButton = false});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {}); // Actualiza cuando el video esté listo
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _confirmPermissionRequest(
      BuildContext context, String permissionType) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Solicitar permiso de $permissionType'),
          content: Text('¿Quieres permitir el acceso a $permissionType?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Usuario no acepta
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Usuario acepta
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );

    return confirm ?? false;
  }

  Future<bool> _requestStoragePermission(BuildContext context) async {
    try {
      // Verificar la versión de Android
      int sdkInt = await _getSdkInt();
      print('SDK Version: $sdkInt'); // Debug SDK version

      Permission permission = (Platform.isAndroid && sdkInt >= 30)
          ? Permission.manageExternalStorage
          : Permission.storage;

      // Obtener el estado actual del permiso
      PermissionStatus status = await permission.status;
      print('Estado inicial del permiso: $status');

      // Si ya está concedido, retornamos true inmediatamente
      if (status.isGranted) {
        print('Permiso ya concedido');
        return true;
      }

      // Mostrar diálogo de confirmación solo si no está permanentemente denegado
      if (!status.isPermanentlyDenied) {
        bool confirm =
            await _confirmPermissionRequest(context, 'almacenamiento');
        if (!confirm) {
          print('Usuario rechazó el diálogo de confirmación');
          return false;
        }

        // Solicitar el permiso
        print('Solicitando permiso...');
        status = await permission.request();
        print('Estado después de solicitar: $status');

        if (status.isGranted) {
          print('Permiso concedido');
          return true;
        }
      }

      // Si llegamos aquí, significa que el permiso ha sido denegado permanentemente o no se pudo obtener
      print('Abriendo configuración de la aplicación');
      await openAppSettings(); // Aquí se redirige a la configuración de la app
      return false;
    } catch (e) {
      print('Error al solicitar permiso: $e');
      return false;
    }
  }

  // Método para abrir la configuración de la app
  Future<void> openAppSettings() async {
    if (Platform.isAndroid) {
      const settingsUrl = 'app-settings:';
      if (await canLaunch(settingsUrl)) {
        await launch(settingsUrl);
      } else {
        print('No se pudo abrir la configuración');
      }
    } else if (Platform.isIOS) {
      await openAppSettings(); // iOS-specific implementation
    }
  }

  Future<int> _getSdkInt() async {
    try {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      return deviceInfo.version.sdkInt;
    } catch (e) {
      print("Error al obtener la información del SDK: $e");
      return 0;
    }
  }

  // Guardar el video en una carpeta personalizada dentro del almacenamiento del dispositivo
  Future<void> _saveVideo() async {
    try {
      Directory? customDirectory = await _getCustomDirectory();
      if (customDirectory != null) {
        // Usamos la fecha y hora actual para crear un nombre único
        String newPath = path.join(customDirectory.path,
            'video_${DateTime.now().millisecondsSinceEpoch}.mp4');
        await widget.videoFile.copy(newPath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video guardado en ${customDirectory.path}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo acceder al directorio de almacenamiento'),
          ),
        );
      }
    } catch (e) {
      print('Error al guardar el video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar el video'),
        ),
      );
    }
  }

  // Obtener el directorio de almacenamiento externo y crear la carpeta personalizada
  Future<Directory?> _getCustomDirectory() async {
    try {
      // Obtiene el directorio de almacenamiento externo (en Android)
      Directory? externalDirectory = await getExternalStorageDirectory();

      if (externalDirectory != null) {
        // Crear la carpeta 'MisVideosGuardados' dentro del almacenamiento externo
        final customDir =
            Directory(path.join(externalDirectory.path, 'MisVideosGuardados'));

        if (!await customDir.exists()) {
          await customDir.create(
              recursive: true); // Crear la carpeta si no existe
        }
        return customDir; // Devuelve el directorio personalizado
      } else {
        print('No se pudo acceder al almacenamiento externo');
        return null;
      }
    } catch (e) {
      print('Error al obtener directorio: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reproductor de Video'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.deepPurple,
                          size: 40,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.stop,
                            color: Colors.deepPurple, size: 40),
                        onPressed: () {
                          _controller.pause();
                          _controller.seekTo(Duration.zero);
                        },
                      ),
                      if (widget.showSaveButton)
                        IconButton(
                          icon: Icon(Icons.save,
                              color: Colors.deepPurple, size: 40),
                          onPressed: () async {
                            try {
                              print('Iniciando proceso de guardado...');
                              bool hasPermission =
                                  await _requestStoragePermission(context);
                              print('¿Tiene permiso?: $hasPermission');

                              if (hasPermission) {
                                await _saveVideo();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'No se pudo obtener el permiso de almacenamiento'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } catch (e) {
                              print('Error en el botón de guardar: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al guardar el video'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
