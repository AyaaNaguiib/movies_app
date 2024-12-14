import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieService {
  static const String apiKey = "48c9c8777253bd8945c7d1da1a02653d";
  static const String baseUrl = "https://api.themoviedb.org/3";
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final List<Map<String, dynamic>> _watchlist = [];

  static Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }

  static Future<List<dynamic>> fetchSimilarMovies(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['results'] ?? [];
      } else {
        throw Exception('Failed to load similar movies');
      }
    } catch (e) {
      throw Exception('Failed to load similar movies: $e');
    }
  }

  static Future<void> addToWatchlist(Map<String, dynamic> movie) async {

    final movieId = movie['id']?.toString() ?? '';
    final movieTitle = movie['title'] ?? 'Unknown Title';
    final movieRating = movie['rating']?.toString() ?? '0.0';
    final movieImageUrl = movie['imageUrl'] ?? '';
    final movieRuntime = movie['runtime']?.toString() ?? 'N/A';

    if (movieId.isEmpty) {
      throw Exception('Movie ID is null or empty');
    }

    final watchlistRef = firestore.collection('watchlist').doc(movieId);
    await watchlistRef.set({
      'id': movieId,
      'title': movieTitle,
      'rating': movieRating,
      'imageUrl': movieImageUrl,
      'runtime': movieRuntime,
    });

    if (!_watchlist.any((item) => item['id'] == movieId)) {
      _watchlist.add(movie);
    }
  }

  static Future<void> removeFromWatchlist(int movieId) async {
    if (movieId <= 0) {
      throw Exception('Invalid movie ID');
    }
    await firestore.collection('watchlist').doc(movieId.toString()).delete();


    _watchlist.removeWhere((item) => item['id'] == movieId);
  }

  static Future<List<Map<String, dynamic>>> fetchWatchlist() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('watchlist').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .map((data) {

        return {
          'id': data['id'] ?? '',
          'title': data['title'] ?? 'Unknown Title',
          'rating': data['rating'] ?? '0.0',
          'imageUrl': data['imageUrl'] ?? '',
          'runtime': data['runtime'] ?? 'N/A',
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch watchlist: $e');
    }
  }

  static List<Map<String, dynamic>> getLocalWatchlist() {
    return _watchlist;
  }
}
