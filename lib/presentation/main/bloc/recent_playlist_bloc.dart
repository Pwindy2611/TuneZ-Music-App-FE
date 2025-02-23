import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'recent_playlist_event.dart';
import 'recent_playlist_state.dart';
import 'package:tunezmusic/data/services/api_service.dart';

class RecentPlaylistBloc extends Bloc<RecentPlaylistEvent, RecentPlaylistState> {
  final ApiService apiService;

  RecentPlaylistBloc(this.apiService) : super(RecentPlaylistLoading()) {
    on<FetchRecentPlaylistEvent>(_fetchRecentPlaylist);
  }

  Future<void> _fetchRecentPlaylist(
      FetchRecentPlaylistEvent event, Emitter<RecentPlaylistState> emit) async {
    try {
      final response =
          await apiService.post("musics/generateRecentPlaylist", {"userId": event.userId});
          if (kDebugMode) {
            print("RecentPlaylist"+response);
          }
      emit(RecentPlaylistLoaded(response['data'] ?? []));
    } catch (e) {
      if (kDebugMode) {
       print("generateRecentPlaylist"+e.toString());
      }
      emit(RecentPlaylistError(e.toString()));
    }
  }
}
