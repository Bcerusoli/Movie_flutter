import 'package:flutter/material.dart';
import 'package:movie_flutter/services/api_service.dart';
import 'package:movie_flutter/services/Bd_movie.dart';
import 'package:movie_flutter/models/movie.dart';
import 'package:movie_flutter/services/detalle.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrunPeliculas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PantallaBusquedaPeliculas(),
    );
  }
}

class PantallaBusquedaPeliculas extends StatefulWidget {
  @override
  _PantallaBusquedaPeliculasState createState() => _PantallaBusquedaPeliculasState();
}

class _PantallaBusquedaPeliculasState extends State<PantallaBusquedaPeliculas> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Movie> _movies = [];

  void _buscarPeliculas() async {
    final query = _controller.text;
    final movies = await _apiService.searchMovies(query);
    setState(() {
      _movies = movies;
    });
  }

  void _verHistorial() async {
    final movies = await Bd_movie().getMovies();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaHistorialPeliculas(movies: movies),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscador de Películas'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _verHistorial,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Buscar una película',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _buscarPeliculas,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return ListTile(
                    title: Text(movie.title),
                    subtitle: Text(movie.year),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detalle(movie: movie),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PantallaHistorialPeliculas extends StatefulWidget {
  final List<Movie> movies;

  PantallaHistorialPeliculas({required this.movies});

  @override
  _PantallaHistorialPeliculasState createState() => _PantallaHistorialPeliculasState();
}

class _PantallaHistorialPeliculasState extends State<PantallaHistorialPeliculas> {
  void _borrarHistorial() async {
    await Bd_movie().deleteAllMovies();
    setState(() {
      widget.movies.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Historial borrado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Búsqueda'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _borrarHistorial,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          final movie = widget.movies[index];
          return ListTile(
            title: Text(movie.title),
            subtitle: Text(movie.year),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Detalle(movie: movie),
                ),
              );
            },
          );
        },
      ),
    );
  }
}