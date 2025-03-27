// lib/blocs/home_playlist_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/playlist_helper.dart';
import 'user_playlist_event.dart';
import 'user_playlist_state.dart';

class HomePlaylistBloc extends Bloc<HomePlaylistEvent, HomePlaylistState> {
  final ApiService apiService;

  HomePlaylistBloc(this.apiService) : super(HomePlaylistInitial()) {
    on<FetchHomePlaylistEvent>(_fetchHomePlaylist);
  }

  Future<void> _fetchHomePlaylist(
      FetchHomePlaylistEvent event, Emitter<HomePlaylistState> emit) async {
    try {
      final response = await apiService.get("playlists/generatePlaylist");

      if (kDebugMode) {
        print("Response from API: $response");
      }

      List<Map<String, dynamic>> playlists = PlaylistHelper.processPlaylistData(response);

      if (kDebugMode) {
  debugPrint("Processed Playlists: $playlists");
}

      emit(HomePlaylistLoaded(playlists));
    } catch (e) {
      if (kDebugMode) {
        print("generateUserPlaylist Error: $e");
      }
      emit(HomePlaylistError(e.toString()));
    }
  }
}
