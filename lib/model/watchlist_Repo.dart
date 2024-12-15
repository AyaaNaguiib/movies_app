import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_app/repo/moviemodel.dart';

class WatchlistRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Movie>> getWatchlist() async {
    try {
      final snapshot = await _firestore.collection('watchlist').get();

      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) {
        return Movie.fromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load watchlist: $e');
    }
  }
}

