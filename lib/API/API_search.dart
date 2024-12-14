import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  static const String apiKey = "48c9c8777253bd8945c7d1da1a02653d";
  static const String baseUrl = "https://api.themoviedb.org/3";
  static const String imageUrl = "https://image.tmdb.org/t/p/w500";

  static Future<List<dynamic>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
