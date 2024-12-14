import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://image.tmdb.org/t/p/w500";
  static const String apiKey = "48c9c8777253bd8945c7d1da1a02653d";

  static Future<Map<String, dynamic>> fetchData() async {
    final configResponse = await http.get(
      Uri.parse('https://api.themoviedb.org/3/configuration?api_key=$apiKey'),
    );
    final newReleasesResponse = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey'),
    );
    final recommendedResponse = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey'),
    );

    if (configResponse.statusCode == 200 &&
        newReleasesResponse.statusCode == 200 &&
        recommendedResponse.statusCode == 200) {
      return {
        "config": json.decode(configResponse.body),
        "newReleases": json.decode(newReleasesResponse.body),
        "recommended": json.decode(recommendedResponse.body),
      };
    } else {
      throw Exception("Failed to load data");
    }
  }
}


