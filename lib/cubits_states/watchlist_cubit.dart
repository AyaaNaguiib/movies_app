import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/moviemodel.dart';
import '../repo/watchlist_Repo.dart';

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

class WatchlistCubit extends Cubit<WatchlistState> {
  final WatchlistRepository _watchlistRepository;

  WatchlistCubit(this._watchlistRepository) : super(WatchlistInitial());

  void fetchWatchlist() async {
    emit(WatchlistLoading());
    try {
      final movies = await _watchlistRepository.getWatchlist();
      emit(WatchlistLoaded(movies));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }
}

