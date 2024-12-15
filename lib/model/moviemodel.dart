import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String title;
  final String runtime;
  final String rating;
  final String imageUrl;

  Movie({
    required this.title,
    required this.runtime,
    required this.rating,
    required this.imageUrl,
  });

  factory Movie.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Movie(
      title: data['title'] ?? 'Unknown Title',
      runtime: data['runtime'] ?? 'Unknown Runtime',
      rating: data['rating'] ?? 'Unknown Rating',
      imageUrl: data['imageUrl'] ?? 'default_image_url',
    );
  }
}


