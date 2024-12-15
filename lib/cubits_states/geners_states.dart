import 'package:bloc/bloc.dart';
import 'package:movies_app/API/categories_API.dart';

abstract class MovieByGenreState {}

class MovieByGenreInitial extends MovieByGenreState {}

class MovieByGenreLoading extends MovieByGenreState {}

class MovieByGenreLoaded extends MovieByGenreState {
  final List<dynamic> movies;
  MovieByGenreLoaded(this.movies);
}

class MovieByGenreError extends MovieByGenreState {
  final String error;
  MovieByGenreError(this.error);
}

class MovieByGenreCubit extends Cubit<MovieByGenreState> {
  MovieByGenreCubit() : super(MovieByGenreInitial());

  Future<void> fetchMoviesByGenre(int genreId) async {
    emit(MovieByGenreLoading());
    try {
      final movies = await CategoryService.fetchMoviesByGenre(genreId);
      emit(MovieByGenreLoaded(movies));
    } catch (e) {
      emit(MovieByGenreError(e.toString()));
    }
  }
}
