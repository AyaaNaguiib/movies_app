import 'package:bloc/bloc.dart';

import '../API/movie_details_API.dart';
import 'movie_state.dart';


class MovieCubit extends Cubit<MovieState> {
  final MovieService movieService;

  MovieCubit(this.movieService) : super(MovieInitial());

  Future<void> getMovieDetails(int movieId) async {
    try {
      emit(MovieLoading());
      final movieDetails = await MovieService.fetchMovieDetails(movieId);
      emit(MovieLoaded(movieDetails));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }
}
