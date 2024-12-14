abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<dynamic> movies;
  final String imageUrl;

  SearchLoaded(this.movies, {required this.imageUrl});
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}


