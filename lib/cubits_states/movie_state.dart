abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final Map<String, dynamic> movie;
  MovieLoaded(this.movie);
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}
