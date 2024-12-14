import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  static const String apiKey = "48c9c8777253bd8945c7d1da1a02653d";
  static const String baseUrl = "https://api.themoviedb.org/3";
  static const String imageUrl = "https://image.tmdb.org/t/p/w500";

  static const Map<String, String> genreImages = {
    'Action': 'assets/images/action.jpg',
    'Comedy': 'assets/images/comedy.jpg',
    'Drama': 'assets/images/drama.jpg',
    'Horror': 'assets/images/horror.jpg',
    'Science Fiction': 'assets/images/scifi.jpg',
    'Default': 'assets/images/default.jpg',
  };

  static Future<List<Map<String, dynamic>>> fetchGenres() async {
    final response = await http.get(
      Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final genres = json.decode(response.body)['genres'] as List;
      return genres.map((genre) {
        final genreName = genre['name'] as String;
        return {
          'id': genre['id'],
          'name': genreName,
          'image': genreImages[genreName] ?? genreImages['Default'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }

  static Future<List<dynamic>> fetchMoviesByGenre(int genreId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load movies by genre');
    }
  }
}
