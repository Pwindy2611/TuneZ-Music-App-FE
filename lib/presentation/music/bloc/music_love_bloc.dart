import 'package:bloc/bloc.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'music_love_event.dart';
import 'music_love_state.dart';

class MusicLoveBloc extends Bloc<MusicLoveEvent, MusicLoveState> {
  final ApiService apiService; // Thay bằng URL thực tế

  MusicLoveBloc(this.apiService) : super(MusicLoveInitial()) {
    on<SaveLoveMusicEvent>(_onSaveLoveMusic);
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
        emit(MusicLoveSuccess());
      } else {
        emit(MusicLoveFailure("Failed to save love music: ${response.body}"));
      }
    } catch (e) {
      emit(MusicLoveFailure("Error: $e"));
    }
  }
}