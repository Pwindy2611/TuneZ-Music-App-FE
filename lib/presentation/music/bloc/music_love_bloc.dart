import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_event.dart';
import 'music_love_event.dart';
import 'music_love_state.dart';

class MusicLoveBloc extends Bloc<MusicLoveEvent, MusicLoveState> {
  final ApiService apiService; // Thay bằng URL thực tế
  final MusicLoveListBloc musicLoveListBloc; 
  MusicLoveBloc(this.apiService, this.musicLoveListBloc) : super(MusicLoveInitial()) {
    on<SaveLoveMusicEvent>(_onSaveLoveMusic);
    on<CheckMusicLoveEvent>(_onCheckMusicLove);
  }

  Future<void> _onSaveLoveMusic(
      SaveLoveMusicEvent event, Emitter<MusicLoveState> emit) async {
        print("Save love music event: ${event.musicId}");
    emit(MusicLoveLoading());

    try {
      final response = await apiService.postWithCookies(
        'love/saveLoveMusic',
        {
          "musicId": event.musicId,
        },
      );
      print("Response: ${response}");

      if (response["success"] == true) {
      musicLoveListBloc.add(FetchMusicLoveListEvent());
        emit(MusicLoveSuccess());
      } else {
        emit(MusicLoveFailure("Failed to save love music: ${response.body}"));
      }
    } catch (e) {
      emit(MusicLoveFailure("Error: $e"));
    }
  }

  Future<void> _onCheckMusicLove(
      CheckMusicLoveEvent event, Emitter<MusicLoveState> emit) async {
    emit(MusicLoveLoading());

    try {
      // Lấy danh sách nhạc yêu thích từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final musicLoveIds = prefs.getStringList('musicLoveIds') ?? [];

      // Kiểm tra xem musicId có nằm trong danh sách hay không
      final isLoved = musicLoveIds.contains(event.musicId);

      if (isLoved) {
        emit(MusicLoveSuccess()); // Nếu bài hát là yêu thích
      } else {
        emit(MusicLoveFailure("This music is not in the love list.")); // Nếu không
      }
    } catch (e) {
      emit(MusicLoveFailure("Error: $e"));
    }
  }
}