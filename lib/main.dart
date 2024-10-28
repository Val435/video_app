import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Importación correcta del paquete
import 'dart:io';

import 'package:video_app/screens/camera.dart';
import 'package:video_app/screens/video_list.dart';
import 'package:video_app/screens/video_player.dart'; // Para manejar archivos

void main() {
  runApp(VideoApp());
}

class VideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Captura un Video',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Cambiar el tema principal a morado
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        '/camera': (context) => CameraScreen(),
        '/videos': (context) => VideoListScreen(),
        '/player': (context) => FutureBuilder<File?>(
              future: getLastVideoFile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    return VideoPlayerScreen(
                      videoFile: snapshot.data!,
                      showSaveButton: true, // Habilitar el botón de guardar
                    );
                  } else {
                    return Scaffold(
                      appBar: AppBar(title: Text('Reproductor de Video')),
                      body: Center(
                        child:
                            Text('No hay videos disponibles para reproducir.'),
                      ),
                    );
                  }
                } else {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
      },
    );
  }

  // Función para obtener el último archivo de video grabado
  Future<File?> getLastVideoFile() async {
    final directory =
        await getApplicationDocumentsDirectory(); // Obtén el directorio de la app
    final videoDir = Directory(directory.path);
    List<FileSystemEntity> files = videoDir.listSync();

    // Filtrar archivos de video por extensión (e.g., .mp4)
    List<File> videos = files
        .where((file) => file.path.endsWith('.mp4'))
        .map((file) => File(file.path))
        .toList();

    if (videos.isNotEmpty) {
      return videos.last; // Devuelve el último video de la lista
    }
    return null; // Devuelve null si no hay videos
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas para cambiar a través del BottomNavigationBar
  static List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Grabar Video', style: TextStyle(fontSize: 24))),
    Center(child: Text('Ver Videos Guardados', style: TextStyle(fontSize: 24))),
    Center(
        child: Text('Reproducir Último Video', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Cambiar de pantalla según el botón seleccionado
    if (index == 0) {
      Navigator.pushNamed(context, '/camera');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/videos');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/player');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Capture App'),
        backgroundColor: Colors.deepPurple, // Color del AppBar morado
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Grabar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Guardados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill),
            label: 'Reproducir',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple, // Color seleccionado morado
        onTap: _onItemTapped,
      ),
    );
  }
}
