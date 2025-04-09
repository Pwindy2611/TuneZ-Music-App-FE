import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/user_music/bloc/user_music_event.dart';
import 'package:tunezmusic/presentation/user_music/bloc/user_music_state.dart';

class UserMusicBloc extends Bloc<UserMusicEvent, UserMusicState> {
  final ApiService _apiService;

  UserMusicBloc(this._apiService) : super(UserMusicInitial()) {
    on<FetchUserMusic>(_onFetchUserMusic);
    on<ResetUserMusicState>(_onResetUserMusicState);
  }

  Future<void> _onFetchUserMusic(
    FetchUserMusic event,
    Emitter<UserMusicState> emit,
  ) async {
    try {
      emit(UserMusicLoading());

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        emit(UserMusicError('User ID not found'));
        return;
      }

      final response = await _apiService.get('musics/getUserMusic');

      if (response['success'] == true) {
        List<Map<String, dynamic>> musicList =
            List<Map<String, dynamic>>.from(response["data"]);
        emit(UserMusicLoaded(musicList));
      } else {
        emit(UserMusicError(
            response['message'] ?? 'Failed to fetch user music'));
      }
    } catch (e) {
      emit(UserMusicError(e.toString()));
    }
  }

  Future<void> _onResetUserMusicState(
    ResetUserMusicState event,
    Emitter<UserMusicState> emit,
  ) async {
    emit(UserMusicInitial());
  }
}
