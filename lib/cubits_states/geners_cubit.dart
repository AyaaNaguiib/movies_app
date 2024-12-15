import 'package:bloc/bloc.dart';
import 'package:movies_app/API/categories_API.dart';

abstract class GenreState {}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final List<Map<String, dynamic>> genres;
  GenreLoaded(this.genres);
}

class GenreError extends GenreState {
  final String error;
  GenreError(this.error);
}

class GenreCubit extends Cubit<GenreState> {
  GenreCubit() : super(GenreInitial());

  Future<void> fetchGenres() async {
    emit(GenreLoading());
    try {
      final genres = await CategoryService.fetchGenres();
      emit(GenreLoaded(genres));
    } catch (e) {
      emit(GenreError(e.toString()));
    }
  }
}
