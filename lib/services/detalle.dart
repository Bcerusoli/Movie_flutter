import 'package:flutter/material.dart';
import 'package:movie_flutter/models/movie.dart';
import 'package:movie_flutter/services/Bd_movie.dart';

class Detalle extends StatelessWidget {
  final Movie movie;

  Detalle({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(movie.imageUrl),
            SizedBox(height: 8.0),
            Text('Año: ${movie.year}', style: TextStyle(fontSize: 16.0)),
            Text('Duración: ${movie.duration}', style: TextStyle(fontSize: 16.0)),
            Text('Género: ${movie.genre}', style: TextStyle(fontSize: 16.0)),
            Text('Director: ${movie.director}', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 8.0),
            Text('Sinopsis:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            Text(movie.synopsis, style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 8.0),
            Text('Calificación: ${movie.rating}', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _guardarEnHistorial(movie);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Película guardada en el historial')),
                  );
                },
                child: Text('Guardar en Historial'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _guardarEnHistorial(Movie movie) async {
    final dbHelper = Bd_movie();
    await dbHelper.insertMovie(movie);
  }
}