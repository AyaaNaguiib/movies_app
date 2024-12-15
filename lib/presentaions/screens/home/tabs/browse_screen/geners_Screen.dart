import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/colors_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../API/categories_API.dart';
import '../../../../../cubits_states/geners_states.dart';
import '../search/search_result.dart';


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
    context.read<MovieByGenreCubit>().fetchMoviesByGenre(genreId);

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
      body: BlocBuilder<MovieByGenreCubit, MovieByGenreState>(
        builder: (context, state) {
          if (state is MovieByGenreLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieByGenreError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is MovieByGenreLoaded) {
            final movies = state.movies;
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
          return const SizedBox();
        },
      ),
    );
  }
}
