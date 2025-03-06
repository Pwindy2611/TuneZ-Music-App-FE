import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_playlist_event.dart';
import 'user_playlist_state.dart';
import 'package:tunezmusic/data/services/api_service.dart';

class HomePlaylistBloc extends Bloc<HomePlaylistEvent, HomePlaylistState> {
  final ApiService apiService;

  HomePlaylistBloc(this.apiService) : super(HomePlaylistLoading()) {
    on<FetchHomePlaylistEvent>(_fetchHomePlaylist);
  }

  Future<void> _fetchHomePlaylist(
      FetchHomePlaylistEvent event, Emitter<HomePlaylistState> emit) async {
    try {
      final response = await apiService
          .get("playlists/generateUserPlaylist?userId=${event.userId}");

      if (kDebugMode) {
        print("Response from API: $response");
      }

      if (response['success'] == true) {
        // Kiểm tra và trích xuất danh sách bài hát
        if (response['musics'] is Map &&
            response['musics']['playlistsByArtist'] is Map) {
          // Gộp tất cả danh sách bài hát của các nghệ sĩ thành một danh sách chung
          final Map<String, List<dynamic>> artistPlaylists =
              Map<String, List<dynamic>>.from(response['musics']['playlistsByArtist']);

          emit(HomePlaylistLoaded(artistPlaylists));
        } else {
          emit(HomePlaylistError(
              "API trả về dữ liệu không hợp lệ: 'musics.playlistsByArtist' không đúng định dạng"));
        }
      } else {
        emit(HomePlaylistError(
            "API trả về lỗi: ${response['message'] ?? 'Không rõ lỗi'}"));
      }
    } catch (e) {
      if (kDebugMode) {
        print("generateUserPlaylist Error: $e");
      }
      emit(HomePlaylistError(e.toString()));
    }
  }
}
