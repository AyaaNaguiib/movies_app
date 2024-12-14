// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class MovieService {
//   static const String apiKey = "48c9c8777253bd8945c7d1da1a02653d";
//   static const String baseUrl = "https://api.themoviedb.org/3";
//
//   static Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'),
//     );
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load movie details');
//     }
//   }
//
//   static Future<List<dynamic>> fetchSimilarMovies(int movieId) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiKey'),
//     );
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body)['results'];
//     } else {
//       throw Exception('Failed to load similar movies');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieService {
  static const String apiKey = "48c9c8777253bd8945c7d1da1a02653d";
  static const String baseUrl = "https://api.themoviedb.org/3";
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Local in-memory watchlist for quick access
  static final List<Map<String, dynamic>> _watchlist = [];

  // Fetch movie details from the API
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

  // Fetch similar movies from the API
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

  // Add movie to Firestore watchlist
  static Future<void> addToWatchlist(Map<String, dynamic> movie) async {
    // Ensuring that all fields are checked for null before adding to Firestore
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

    // Optionally, update the local in-memory watchlist
    if (!_watchlist.any((item) => item['id'] == movieId)) {
      _watchlist.add(movie);
    }
  }

  // Remove movie from Firestore watchlist
  static Future<void> removeFromWatchlist(int movieId) async {
    if (movieId <= 0) {
      throw Exception('Invalid movie ID');
    }
    await firestore.collection('watchlist').doc(movieId.toString()).delete();

    // Optionally, remove from the local in-memory watchlist
    _watchlist.removeWhere((item) => item['id'] == movieId);
  }

  // Fetch movies from Firestore watchlist
  static Future<List<Map<String, dynamic>>> fetchWatchlist() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('watchlist').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .map((data) {
        // Check for null values in fields
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

  // Fetch movies from the local watchlist
  static List<Map<String, dynamic>> getLocalWatchlist() {
    return _watchlist;
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class MovieService {
//   static const String apiKey = "48c9c8777253bd8945c7d1da1a02653d";
//   static const String baseUrl = "https://api.themoviedb.org/3";
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   // Fetch movie details from the API
//   static Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'),
//     );
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load movie details');
//     }
//   }
//
//   // Fetch similar movies from the API
//   static Future<List<dynamic>> fetchSimilarMovies(int movieId) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiKey'),
//     );
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body)['results'];
//     } else {
//       throw Exception('Failed to load similar movies');
//     }
//   }
//
//   // Add movie to Firestore watchlist
//   static Future<void> addToWatchlist(Map<String, dynamic> movie) async {
//     final watchlistRef = firestore.collection('watchlist').doc(movie['id'].toString());
//     await watchlistRef.set(movie); // Add movie to Firestore
//   }
//
//   // Remove movie from Firestore watchlist
//   static Future<void> removeFromWatchlist(int movieId) async {
//     await firestore.collection('watchlist').doc(movieId.toString()).delete();
//   }
//
//   // Fetch movies from Firestore watchlist
//   static Future<List<Map<String, dynamic>>> fetchWatchlist() async {
//     QuerySnapshot snapshot = await firestore.collection('watchlist').get();
//     return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//   }
// }
