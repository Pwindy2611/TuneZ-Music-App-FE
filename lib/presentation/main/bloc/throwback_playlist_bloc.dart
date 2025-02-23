import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'throwback_playlist_event.dart';
import 'throwback_playlist_state.dart';
import 'package:tunezmusic/data/services/api_service.dart';

class ThrowbackPlaylistBloc extends Bloc<ThrowbackPlaylistEvent, ThrowbackPlaylistState> {
  final ApiService apiService;

  ThrowbackPlaylistBloc(this.apiService) : super(ThrowbackPlaylistLoading()) {
    on<FetchThrowbackPlaylistEvent>(_fetchThrowbackPlaylist);
  }

  Future<void> _fetchThrowbackPlaylist(
      FetchThrowbackPlaylistEvent event, Emitter<ThrowbackPlaylistState> emit) async {
    try {
      final response =
          await apiService.post("musics/generateThrowBackPlaylist", {"userId": event.userId});
            if (kDebugMode) {
            print("ThrowBackPlaylist"+response);
          }
      emit(ThrowbackPlaylistLoaded(response['data'] ?? []));
    } catch (e) {
       if (kDebugMode) {
        print("ThrowBackPlaylist"+e.toString());
      }
      emit(ThrowbackPlaylistError(e.toString()));
    }
  }
}
