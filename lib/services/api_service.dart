import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String apiKey = '6a38471ed1263431f42413681f2a8459';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'));
    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      List<Movie> movies = [];
      for (var result in results) {
        final movieDetails = await getMovieDetails(result['id']);
        movies.add(Movie.fromJson(movieDetails));
      }
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=credits'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}