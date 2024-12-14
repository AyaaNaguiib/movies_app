import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/colors_manager.dart';
import 'package:movies_app/presentaions/screens/home/tabs/search/search_result.dart';
import 'categories_service.dart';

class MoviesByGenreScreen extends StatelessWidget {
  final int genreId;
  final String genreName;

  const MoviesByGenreScreen({
    Key? key,
    required this.genreId,
    required this.genreName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.bg,
      appBar: AppBar(
        backgroundColor: ColorsManager.bg,
        elevation: 0,
        title: Text(
          genreName,
          style: TextStyle(color: ColorsManager.white, fontSize: 20.sp),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: CategoryService.fetchMoviesByGenre(genreId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No movies found.',
                style: TextStyle(color: ColorsManager.white, fontSize: 18.sp),
              ),
            );
          } else {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return SearchResultItem(
                  movie: movie,
                  baseUrl: CategoryService.imageUrl,
                );
              },
            );
          }
        },
      ),
    );
  }
}
