import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/presentaions/screens/home/movie_details/widgets/movie_details_API.dart';
import 'package:movies_app/presentaions/screens/home/movie_details/widgets/more_like_this.dart';
import 'package:movies_app/presentaions/screens/home/movie_details/widgets/movie_info.dart';
import 'package:movies_app/presentaions/screens/home/movie_details/widgets/overview.dart';
import '../../../../core/colors_manager.dart';

class MovieDetails extends StatefulWidget {
  final int movieId;
  const MovieDetails({Key? key, required this.movieId}) : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Future<Map<String, dynamic>> movieData;
  late Future<List<dynamic>> similarMovies;

  @override
  void initState() {
    super.initState();
    movieData = MovieService.fetchMovieDetails(widget.movieId);
    similarMovies = MovieService.fetchSimilarMovies(widget.movieId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.bg,
      body: FutureBuilder<Map<String, dynamic>>(
        future: movieData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final movie = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250.h,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      movie['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    background: Stack(
                      children: [
                        Image.network(
                          "https://image.tmdb.org/t/p/w500${movie['backdrop_path']}",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 70.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MovieInfo(movie: movie),
                        const SizedBox(height: 20),
                        Overview(overview: movie['overview']),
                        const SizedBox(height: 20),
                        MoreLikeThis(
                          similarMoviesFuture: similarMovies,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
