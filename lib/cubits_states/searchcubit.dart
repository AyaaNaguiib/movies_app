import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/domain/searchstate.dart';

import '../API/API_search.dart';


class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      emit(SearchLoaded([], imageUrl: SearchService.imageUrl));
      return;
    }

    try {
      emit(SearchLoading());
      final results = await SearchService.searchMovies(query);
      emit(SearchLoaded(results, imageUrl: SearchService.imageUrl));
    } catch (error) {
      emit(SearchError(error.toString()));
    }
  }
}


