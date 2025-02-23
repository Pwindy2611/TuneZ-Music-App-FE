import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_playlist_event.dart';
import 'user_playlist_state.dart';
import 'package:tunezmusic/data/services/api_service.dart';

class UserPlaylistBloc extends Bloc<UserPlaylistEvent, UserPlaylistState> {
  final ApiService apiService;

  UserPlaylistBloc(this.apiService) : super(UserPlaylistLoading()) {
    on<FetchUserPlaylistEvent>(_fetchUserPlaylist);
  }

  Future<void> _fetchUserPlaylist(
      FetchUserPlaylistEvent event, Emitter<UserPlaylistState> emit) async {
    try {
      final response = await apiService
          .post("musics/generateUserPlaylist", {"userId": event.userId});

      if (kDebugMode) {
        print("Response from API: $response");
      }

      if (response['success'] == true) {
        // Kiểm tra và trích xuất danh sách bài hát
        if (response['musics'] is Map &&
            response['musics']['playlistsByArtist'] is Map) {
          // Gộp tất cả danh sách bài hát của các nghệ sĩ thành một danh sách chung
          final List<dynamic> allSongs = response['musics']['playlistsByArtist']
              .values
               .expand((songs) => songs as List<dynamic>)
              .toList();

          emit(UserPlaylistLoaded(allSongs));
        } else {
          emit(UserPlaylistError(
              "API trả về dữ liệu không hợp lệ: 'musics.playlistsByArtist' không đúng định dạng"));
        }
      } else {
        emit(UserPlaylistError(
            "API trả về lỗi: ${response['message'] ?? 'Không rõ lỗi'}"));
      }
    } catch (e) {
      if (kDebugMode) {
        print("generateUserPlaylist Error: $e");
      }
      emit(UserPlaylistError(e.toString()));
    }
  }
}
