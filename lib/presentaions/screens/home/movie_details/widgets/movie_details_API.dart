import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  static const String apiKey = "48c9c8777253bd8945c7d1da1a02653d";
  static const String baseUrl = "https://api.themoviedb.org/3";

  static Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  static Future<List<dynamic>> fetchSimilarMovies(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load similar movies');
    }
  }
}
