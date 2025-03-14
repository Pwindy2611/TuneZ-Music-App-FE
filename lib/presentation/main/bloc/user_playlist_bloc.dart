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
        .get("playlists/generatePlaylist?userId=${event.userId}");

    if (kDebugMode) {
      print("Response from API: $response");
    }

    if (response['success'] == true) {
      if (response['data'] is List && response['data'].isNotEmpty) {
        List<dynamic> rawPlaylists = response['data'];

        List playlists = rawPlaylists.expand((innerList) {
          return innerList.map<Map<String, dynamic>>((playlist) {
            return {
              "title": playlist["title"],
              "coverImage": playlist["coverImage"],
            };
          });
        }).toList();

        emit(HomePlaylistLoaded(playlists));
      } else {
        emit(HomePlaylistError(
            "API trả về dữ liệu không hợp lệ: 'data' không đúng định dạng hoặc rỗng: $response"));
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