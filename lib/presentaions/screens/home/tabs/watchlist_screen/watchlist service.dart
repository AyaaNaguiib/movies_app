// import 'package:flutter/material.dart';
//
// class WatchlistService {
//   static final List<dynamic> _watchlist = [];
//
//   static List<dynamic> get watchlist => _watchlist;
//
//   static void addOrRemove(dynamic movie) {
//     if (isInWatchlist(movie)) {
//       _watchlist.removeWhere((item) => item['id'] == movie['id']);
//     } else {
//       _watchlist.add(movie);
//     }
//   }
//
//   static bool isInWatchlist(dynamic movie) {
//     return _watchlist.any((item) => item['id'] == movie['id']);
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WatchlistService {
  static final List<dynamic> _watchlist = [];

  static List<dynamic> get watchlist => _watchlist;

  // Fetch the watchlist from Firebase Firestore
  static Future<void> fetchWatchlist() async {
    final snapshot = await FirebaseFirestore.instance.collection('watchlist').get();
    _watchlist.clear(); // Clear the existing list
    _watchlist.addAll(snapshot.docs.map((doc) => doc.data()).toList());
  }

  static void addOrRemove(dynamic movie) {
    if (isInWatchlist(movie)) {
      _watchlist.removeWhere((item) => item['id'] == movie['id']);
      // Remove from persistent storage (e.g., Firebase, Hive)
    } else {
      _watchlist.add(movie);
      // Save to persistent storage (e.g., Firebase, Hive)
    }
  }

  static bool isInWatchlist(dynamic movie) {
    return _watchlist.any((item) => item['id'] == movie['id']);
  }
}

