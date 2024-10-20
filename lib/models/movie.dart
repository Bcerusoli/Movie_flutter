class Movie {
  final int id;
  final String title;
  final String year;
  final String duration;
  final String genre;
  final String director;
  final String synopsis;
  final String imageUrl;
  final String rating;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.duration,
    required this.genre,
    required this.director,
    required this.synopsis,
    required this.imageUrl,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      year: json['release_date'],
      duration: json['runtime'] != null ? '${json['runtime']} min' : 'N/A',
      genre: json['genres'] != null && json['genres'].isNotEmpty
          ? json['genres'].map((genre) => genre['name']).join(', ')
          : 'N/A',
      director: json['credits'] != null && json['credits']['crew'] != null
          ? json['credits']['crew']
              .firstWhere((crew) => crew['job'] == 'Director', orElse: () => {'name': 'N/A'})['name']
          : 'N/A',
      synopsis: json['overview'],
      imageUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      rating: json['vote_average'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'duration': duration,
      'genre': genre,
      'director': director,
      'synopsis': synopsis,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }
}