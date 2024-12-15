import '../repo/moviemodel.dart';

abstract class WatchlistState {}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<Movie> movies;
  WatchlistLoaded(this.movies);
}

class WatchlistError extends WatchlistState {
  final String error;
  WatchlistError(this.error);
}
