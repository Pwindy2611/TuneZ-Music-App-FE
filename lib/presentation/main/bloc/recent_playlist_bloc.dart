import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'recent_playlist_event.dart';
import 'recent_playlist_state.dart';
import 'package:tunezmusic/data/services/api_service.dart';

class RecentPlaylistBloc
    extends Bloc<RecentPlaylistEvent, RecentPlaylistState> {
  final ApiService apiService;

  RecentPlaylistBloc(this.apiService) : super(RecentPlaylistLoading()) {
    on<FetchRecentPlaylistEvent>(_fetchRecentPlaylist);
    on<ResetRecentPlaylistStateEvent>(_onResetState);
  }

  Future<void> _fetchRecentPlaylist(
      FetchRecentPlaylistEvent event, Emitter<RecentPlaylistState> emit) async {
    try {
      final response = await apiService
          .post("musics/generateRecentPlaylist", {"userId": event.userId});
      if (response['success'] == true) {
           if (kDebugMode) {
        print("Response from API: $response");
      }
        // Kiểm tra và trích xuất danh sách bài hát
        if (response['musics'] is List) {
          // Gộp tất cả danh sách bài hát của các nghệ sĩ thành một danh sách chung
         final List<dynamic> allSongs = response['musics'];

          emit(RecentPlaylistLoaded(allSongs));
        } else {
          emit(RecentPlaylistError(
              "API trả về dữ liệu không hợp lệ: 'musics' không đúng định dạng"));
        }
      } else {
        emit(RecentPlaylistError(
            "API trả về lỗi: ${response['message'] ?? 'Không rõ lỗi'}"));
      }
    } catch (e) {
      emit(RecentPlaylistError(e.toString()));
    }
  }

  void _onResetState(ResetRecentPlaylistStateEvent event, Emitter<RecentPlaylistState> emit) {
    emit(RecentPlaylistInitial());
  }
}
