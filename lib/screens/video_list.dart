import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_app/screens/video_player.dart'; // Asegúrate de que esta ruta sea correcta

class VideoListScreen extends StatelessWidget {
  final List<File> videos = []; // Aquí carga los videos guardados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos Guardados'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder(
        future: _getVideos(), // Función que obtiene los videos
        builder: (context, AsyncSnapshot<List<File>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final videos = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Dos videos por fila
              ),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                          videoFile: videos[index],
                          showSaveButton: true, // Habilitar el botón de guardar
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Icon(Icons.play_circle_filled,
                            size: 50, color: Colors.deepPurple),
                        Text('Video ${index + 1}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<File>> _getVideos() async {
    final directory = await getApplicationDocumentsDirectory();
    final videoDir = Directory(directory.path);
    List<FileSystemEntity> files = videoDir.listSync();

    // Filtrar solo archivos de video
    return files
        .where((file) => file.path.endsWith('.mp4'))
        .map((file) => File(file.path))
        .toList();
  }
}
