import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/upload/bloc/genres_event.dart';
import 'package:tunezmusic/presentation/upload/bloc/genres_state.dart';

class GenresBloc extends Bloc<GenresEvent, GenresState> {
  final ApiService _apiService;

  GenresBloc(this._apiService) : super(GenresInitial()) {
    on<FetchGenres>(_onFetchGenres);
  }

  Future<void> _onFetchGenres(FetchGenres event, Emitter<GenresState> emit) async {
    try {
      emit(GenresLoading());
      final response = await _apiService.get('musics/getAllGenres');
      if (response['success'] == true) {
        final List<dynamic> genres = response['data'];
        emit(GenresLoaded(genres));
      } else {
        emit(GenresError(response['message'] ?? 'Failed to fetch genres'));
      }
    } catch (e) {
      emit(GenresError(e.toString()));
    }
  }
} 